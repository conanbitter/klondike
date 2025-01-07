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
---@field placeholder love.Quad
---@field draw function()

---@param self Deck
local function draw_deck(self)
    cards.draw(self.placeholder, self.x, self.y)
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
        draw = draw_deck,
    }
end

local FLAT_OFFSET = 14

---@class FlatDeck:Deck
---@field covered boolean

---@param self FlatDeck
local function draw_flat(self)
    if #self.cards == 0 then
        cards.draw(self.placeholder, self.x, self.y)
    end
    for i, card in ipairs(self.cards) do
        if self.covered and i < #self.cards then
            cards.draw(cards.back, self.x, self.y + (i - 1) * FLAT_OFFSET)
        else
            cards.draw_card(card, self.x, self.y + (i - 1) * FLAT_OFFSET)
        end
    end
end

---@param x number
---@param y number
---@return FlatDeck
local function new_flat_deck(x, y)
    local result = new_deck(x, y) --[[@as FlatDeck]]
    result.covered = true
    result.draw = draw_flat
    return result
end

function module.init()
    local main_deck = {}
    local decks = {}

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

    table.insert(decks, test_deck)

    return decks
end

return module
