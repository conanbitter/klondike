local module = {}

local cards = require "cards"
local Vector = require "vector"

---@class Card
---@field suit Suit
---@field rank Rank

---@param suit Suit
---@param rank Rank
---@return Card
local function new_card(suit, rank)
    return {
        suit = suit,
        rank = rank
    }
end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return boolean
local function card_intersect(x1, y1, x2, y2)
    return x1 - x2 <= CARD_WIDTH and
        x2 - x1 <= CARD_WIDTH and
        y1 - y2 <= CARD_HEIGHT and
        y2 - y1 <= CARD_HEIGHT
end

---@class Deck
---@field x number
---@field y number
---@field cards Card[]
---@field placeholder love.Quad?
---@field draw fun(self:Deck)
---@field is_empty fun(self:Deck):boolean
---@field trygrab fun(self:Deck, x:number, y:number, hand:Card[]):boolean
---@field candrop fun(self:Deck, x:number, y:number):Vector?
---@field trydrop fun(self:Deck, x:number, y:number, hand:Card[]):boolean
---@field revert_drop fun(self:Deck, hand:Card[])

---@param self Deck
---@return boolean
local function desk_is_empty(self)
    return #self.cards == 0
end

---@param self Deck
---@param hand Card[]
local function deck_revert_drop(self, hand)
    cards.move_multiple(hand, self.cards)
end

---@param x number
---@param y number
---@return Deck
local function new_deck(x, y)
    return {
        x = x,
        y = y,
        cards = {},
        placeholder = cards.placeholder_empty,
        draw = nil,
        is_empty = desk_is_empty,
        cangrab = nil,
        trygrab = nil,
        trydrop = nil,
        revert_drop = deck_revert_drop
    }
end

---@class FlatDeck:Deck
---@field covered number

---@param self FlatDeck
local function draw_flat(self)
    if self:is_empty() and self.placeholder then
        cards.draw_other(self.placeholder, self.x, self.y)
    end
    for i, card in ipairs(self.cards) do
        if i <= self.covered then
            cards.draw_other(cards.back, self.x, self.y + (i - 1) * FLAT_OFFSET)
        else
            cards.draw_single(card, self.x, self.y + (i - 1) * FLAT_OFFSET)
        end
    end
end

---@param self FlatDeck
---@param x number
---@param y number
---@param hand Card[]
---@return boolean
local function trygrab_flat(self, x, y, hand)
    if self:is_empty() then return false end
    if x < self.x or x > self.x + CARD_WIDTH then return false end
    if y < self.y + self.covered * FLAT_OFFSET or y >= self.y + CARD_HEIGHT + (#self.cards - 1) * FLAT_OFFSET then return false end
    local index = math.floor((y - self.y) / FLAT_OFFSET) + 1
    if index > #self.cards then index = #self.cards end
    cards.move_multiple(self.cards, hand, index)
    return true
end

---@param self FlatDeck
---@param x number
---@param y number
---@return Vector?
local function candrop_flat(self, x, y)
    local offset = (#self.cards - 1) * FLAT_OFFSET
    if offset < 0 then offset = 0 end
    if card_intersect(x, y, self.x, self.y + offset) then
        return Vector(self.x, self.y + offset)
    else
        return nil
    end
end

---@param self FlatDeck
---@param x number
---@param y number
---@param hand Card[]
---@return boolean
local function trydrop_flat(self, x, y, hand)
    local offset = (#self.cards - 1) * FLAT_OFFSET
    if offset < 0 then offset = 0 end
    if not card_intersect(x, y, self.x, self.y + offset) then return false end
    if self:is_empty() then return true end
    return cards.suit_compatible(self.cards[#self.cards].suit, hand[1].suit) and
        self.cards[#self.cards].rank - hand[1].rank == 1
end

---@param x number
---@param y number
---@return FlatDeck
local function new_flat_deck(x, y)
    local result = new_deck(x, y) --[[@as FlatDeck]]
    result.covered = 0
    result.draw = draw_flat
    result.trygrab = trygrab_flat
    result.candrop = candrop_flat
    result.trydrop = trydrop_flat
    return result
end

---@class Home:Deck
---@field suit Suit

---@param self Home
local function home_draw(self)
    if self:is_empty() then
        cards.draw_other(self.placeholder, self.x, self.y)
    else
        cards.draw_single(self.cards[#self.cards], self.x, self.y)
    end
end

---@param self Home
---@param x number
---@param y number
---@param hand Card[]
---@return boolean
local function home_trygrab(self, x, y, hand)
    if self:is_empty() then return false end
    if x < self.x or
        x > self.x + CARD_WIDTH or
        y < self.y or
        y >= self.y + CARD_HEIGHT then
        return false
    end
    cards.move_single(self.cards, hand)
    return true
end

---@param self Home
---@param x number
---@param y number
---@return Vector?
local function home_candrop(self, x, y)
    if card_intersect(x, y, self.x, self.y) then
        return Vector(self.x, self.y)
    else
        return nil
    end
end

---@param self Home
---@param x number
---@param y number
---@param hand Card[]
---@return boolean
local function home_trydrop(self, x, y, hand)
    local rank = 1
    if not self:is_empty() then
        rank = self.cards[#self.cards].rank + 1
    end
    return card_intersect(x, y, self.x, self.y) and
        #hand == 1 and
        hand[1].suit == self.suit and
        hand[1].rank == rank
end

---@param x number
---@param y number
---@param suit Suit
---@return Home
local function new_home(x, y, suit)
    local result = new_deck(x, y) --[[@as Home]]
    result.suit = suit
    result.placeholder = cards.placeholder_homes[suit]
    result.draw = home_draw
    result.trygrab = home_trygrab
    result.candrop = home_candrop
    result.trydrop = home_trydrop
    return result
end

local RESERVE_OFFSET = 52

---@class Reserve:Deck
---@field index number
---@field click fun(self:Reserve, x:number, y:number)

---@param self Reserve
local function reserve_draw(self)
    if self:is_empty() then
        cards.draw_other(self.placeholder, self.x, self.y)
        return
    end
    if self.index < #self.cards then
        cards.draw_other(cards.back, self.x, self.y)
    else
        cards.draw_other(self.placeholder, self.x, self.y)
    end
    if self.index > 0 then
        cards.draw_single(self.cards[self.index], self.x + RESERVE_OFFSET, self.y)
    end
end

---@param self Reserve
---@param x number
---@param y number
---@param hand Card[]
---@return boolean
local function reserve_trygrab(self, x, y, hand)
    if self:is_empty() or self.index == 0 then return false end
    if x < self.x + RESERVE_OFFSET or
        x > self.x + CARD_WIDTH + RESERVE_OFFSET or
        y < self.y or
        y >= self.y + CARD_HEIGHT then
        return false
    end
    cards.move_single(self.cards, self.index, hand)
    self.index = self.index - 1
    return true
end

---@param self Reserve
---@param x number
---@param y number
---@return Vector?
local function reserve_candrop(self, x, y)
    if card_intersect(x, y, self.x, self.y) then
        return Vector(self.x, self.y)
    elseif card_intersect(x, y, self.x + RESERVE_OFFSET, self.y) then
        return Vector(self.x + RESERVE_OFFSET, self.y)
    else
        return nil
    end
end

---@param self Reserve
---@param x number
---@param y number
---@param hand Card[]
---@return boolean
local function reserve_trydrop(self, x, y, hand)
    return false
end

---@param self Reserve
---@param hand Card[]
local function reserve_revert_drop(self, hand)
    self.index = self.index + 1
    cards.move_single(hand, 1, self.cards, self.index)
end

---@param self Reserve
---@param x number
---@param y number
---@return boolean
local function reserve_click(self, x, y)
    if x < self.x or
        x > self.x + CARD_WIDTH or
        y < self.y or
        y >= self.y + CARD_HEIGHT then
        return false
    end
    if self:is_empty() then return true end

    if self.index >= #self.cards then
        self.index = 0
    else
        self.index = self.index + 1
    end
    return true
end

---@param x number
---@param y number
---@return Reserve
local function new_reserve(x, y)
    local result = new_deck(x, y) --[[@as Reserve]]
    result.index = 0
    result.placeholder = cards.placeholder_refresh
    result.draw = reserve_draw
    result.trygrab = reserve_trygrab
    result.candrop = reserve_candrop
    result.trydrop = reserve_trydrop
    result.revert_drop = reserve_revert_drop
    result.click = reserve_click
    return result
end

---@param card_list Card[]
local function shuffle(card_list)
    for i = 1, #card_list - 1 do
        local r = love.math.random(i, #card_list)
        card_list[i], card_list[r] = card_list[r], card_list[i]
    end
end

---@return Deck[], Reserve, Home[]
function module.init()
    local main_deck = {}
    local reserve = new_reserve(2, 2)
    local decks = { reserve }
    local homes = {}

    for suit = 1, 4 do
        for rank = 1, 13 do
            table.insert(main_deck, new_card(suit, rank))
        end
    end

    shuffle(main_deck)

    for i = 1, 7 do
        local base_deck = new_flat_deck(2 + 50 * (i - 1), 70)
        for j = 1, i do
            table.insert(base_deck.cards, table.remove(main_deck))
        end
        base_deck.covered = #base_deck.cards - 1
        table.insert(decks, base_deck)
    end

    for i = 1, 4 do
        local home_deck = new_home(152 + 50 * (i - 1), 2, i)
        table.insert(decks, home_deck)
        homes[i] = home_deck
    end

    reserve.cards = main_deck

    return decks, reserve, homes
end

return module
