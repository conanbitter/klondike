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
---@field draw function()
---@field is_empty function():boolean
---@field give function(offset number,other Deck)
---@field trygrab function(x number,y number, cursor Deck):boolean

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
        trygrab = nil
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
    if x < self.x or x > self.x + CARD_WIDTH then return false end
    if y < self.y + self.covered * FLAT_OFFSET or y >= self.y + CARD_HEIGHT + (#self.cards - 1) * FLAT_OFFSET then return false end
    local index = math.floor((y - self.y) / FLAT_OFFSET) + 1
    if index > #self.cards then index = #self.cards end
    self:give(index, cursor)
    return true
end

---@param x number
---@param y number
---@return FlatDeck
local function new_flat_deck(x, y)
    local result = new_deck(x, y) --[[@as FlatDeck]]
    result.covered = 0
    result.draw = draw_flat
    result.trygrab = trygrab_flat
    return result
end

function module.init()
    local main_deck = {}
    local decks = {
        all = {},
        homes = {},
        bases = {},
        cursor = new_flat_deck(0, 0),
        active = {},
    }

    for suit = 1, 4 do
        for rank = 1, 13 do
            table.insert(main_deck, new_card(suit, rank))
        end
    end

    local test_deck = new_flat_deck(10, 10)
    for i = 1, 10 do
        table.insert(test_deck.cards, main_deck[#main_deck])
        table.remove(main_deck, #main_deck)
    end
    test_deck.covered = #test_deck.cards - 5

    table.insert(decks.all, test_deck)
    table.insert(decks.active, test_deck)

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
