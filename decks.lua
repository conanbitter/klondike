local module = {}

local cards = require "cards"

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

---@class Deck
---@field x number
---@field y number
---@field cards Card[]
---@field placeholder love.Quad?
---@field draw fun(self:Deck)
---@field is_empty fun(self:Deck):boolean
---@field give fun(self:Deck, offset:number, other:Deck)
---@field trygrab fun(self:Deck, x:number, y:number, cursor:Deck):boolean
---@field trydrop fun(self:Deck, cursor:Deck):boolean

---@param self Deck
---@return boolean
local function desk_is_empty(self)
    return #self.cards == 0
end

---@param self Deck
---@param offset number
---@param other Deck
local function desk_give(self, offset, other)
    for i = offset, #self.cards do
        table.insert(other.cards, self.cards[i])
        self.cards[i] = nil
    end
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
        give = desk_give,
        trygrab = nil,
        trydrop = nil,
    }
end

_G.FLAT_OFFSET = 14

---@class FlatDeck:Deck
---@field covered number

---@param self FlatDeck
local function draw_flat(self)
    if self:is_empty() and self.placeholder then
        cards.draw(self.placeholder, self.x, self.y)
    end
    for i, card in ipairs(self.cards) do
        if i <= self.covered then
            cards.draw(cards.back, self.x, self.y + (i - 1) * FLAT_OFFSET)
        else
            cards.draw_card(card, self.x, self.y + (i - 1) * FLAT_OFFSET)
        end
    end
end

---@param self FlatDeck
---@param x number
---@param y number
---@param cursor Deck
---@return boolean
local function trygrab_flat(self, x, y, cursor)
    if self:is_empty() then return false end
    if x < self.x or x > self.x + CARD_WIDTH then return false end
    if y < self.y + self.covered * FLAT_OFFSET or y >= self.y + CARD_HEIGHT + (#self.cards - 1) * FLAT_OFFSET then return false end
    local index = math.floor((y - self.y) / FLAT_OFFSET) + 1
    if index > #self.cards then index = #self.cards end
    self:give(index, cursor)
    return true
end

---@param self FlatDeck
---@param cursor Deck
---@return boolean
local function trydrop_flat(self, cursor)
    local offset = (#self.cards - 1) * FLAT_OFFSET
    if offset < 0 then offset = 0 end
    return module.card_intersect(cursor.x, cursor.y, self.x, self.y + offset)
end

---@param x number
---@param y number
---@return FlatDeck
local function new_flat_deck(x, y)
    local result = new_deck(x, y) --[[@as FlatDeck]]
    result.covered = 0
    result.draw = draw_flat
    result.trygrab = trygrab_flat
    result.trydrop = trydrop_flat
    return result
end

---@class Home:Deck
---@field suit Suit

---@param self Home
local function home_draw(self)
    if self:is_empty() then
        cards.draw(self.placeholder, self.x, self.y)
    else
        cards.draw_card(self.cards[#self.cards], self.x, self.y)
    end
end

---@param self Home
---@param x number
---@param y number
---@param cursor Deck
---@return boolean
local function home_trygrab(self, x, y, cursor)
    if self:is_empty() then return false end
    if x < self.x or
        x > self.x + CARD_WIDTH or
        y < self.y or
        y >= self.y + CARD_HEIGHT then
        return false
    end
    self:give(#self.cards, cursor)
    return true
end

---@param self Home
---@param cursor Deck
---@return boolean
local function home_trydrop(self, cursor)
    return module.card_intersect(cursor.x, cursor.y, self.x, self.y) and
        #cursor.cards == 1
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
        cards.draw(self.placeholder, self.x, self.y)
        return
    end
    if self.index < #self.cards then
        cards.draw(cards.back, self.x, self.y)
    else
        cards.draw(self.placeholder, self.x, self.y)
    end
    if self.index > 0 then
        cards.draw_card(self.cards[self.index], self.x + RESERVE_OFFSET, self.y)
    end
end

---@param self Reserve
---@param x number
---@param y number
---@param cursor Deck
---@return boolean
local function reserve_trygrab(self, x, y, cursor)
    if self:is_empty() or self.index == 0 then return false end
    if x < self.x + RESERVE_OFFSET or
        x > self.x + CARD_WIDTH + RESERVE_OFFSET or
        y < self.y or
        y >= self.y + CARD_HEIGHT then
        return false
    end
    table.insert(cursor.cards, self.cards[self.index])
    table.remove(self.cards, self.index)
    self.index = self.index - 1
    return true
end

---@param self Reserve
---@param cursor Deck
---@return boolean
local function reserve_trydrop(self, cursor)
    return false
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
    result.trydrop = reserve_trydrop
    result.click = reserve_click
    return result
end

function module.init()
    local main_deck = {}
    local decks = {
        all = {},
        homes = {},
        bases = {},
        cursor = new_flat_deck(0, 0),
        reserve = new_reserve(10, 10),
        active = {},
    }

    for suit = 1, 4 do
        for rank = 1, 13 do
            table.insert(main_deck, new_card(suit, rank))
        end
    end

    local test_deck = new_flat_deck(10, 100)
    for i = 1, 10 do
        table.insert(test_deck.cards, main_deck[#main_deck])
        table.remove(main_deck, #main_deck)
    end
    test_deck.covered = #test_deck.cards - 5

    table.insert(decks.all, test_deck)
    table.insert(decks.active, test_deck)

    test_deck = new_flat_deck(100, 100)
    for i = 1, 10 do
        table.insert(test_deck.cards, main_deck[#main_deck])
        table.remove(main_deck, #main_deck)
    end
    test_deck.covered = #test_deck.cards - 1

    table.insert(decks.all, test_deck)
    table.insert(decks.active, test_deck)

    local test_home = new_home(300, 10, Suit.Clubs)
    table.insert(decks.all, test_home)
    table.insert(decks.active, test_home)

    for i = 1, 10 do
        table.insert(decks.reserve.cards, main_deck[#main_deck])
        table.remove(main_deck, #main_deck)
    end
    table.insert(decks.all, decks.reserve)
    table.insert(decks.active, decks.reserve)

    decks.cursor.placeholder = nil
    table.insert(decks.all, decks.cursor)

    return decks
end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return boolean
function module.card_intersect(x1, y1, x2, y2)
    return x1 - x2 <= CARD_WIDTH and
        x2 - x1 <= CARD_WIDTH and
        y1 - y2 <= CARD_HEIGHT and
        y2 - y1 <= CARD_HEIGHT
end

return module
