local Object = require "lib.classic"
local atlas = require "atlas"

local CARD_WIDTH = 42
local CARD_HEIGHT = 60
local FLAT_OFFSET = 14

---@enum Suit
local Suit = {
    Hearts = 1,
    Diamonds = 2,
    Clubs = 3,
    Spades = 4
}

---@enum Rank
local Rank = {
    Ace = 1,
    Two = 2,
    Three = 3,
    Four = 4,
    Five = 5,
    Six = 6,
    Seven = 7,
    Eight = 8,
    Nine = 9,
    Ten = 10,
    Jack = 11,
    Queen = 12,
    King = 13
}

---@class Card
---@field suit Suit
---@field rank Rank
---@overload fun(suit:Suit,rank:Rank):Card
local Card = Object:extend()

---@param suit Suit
---@param rank Rank
function Card:new(suit, rank)
    self.suit = suit
    self.rank = rank
end

---@param card Card
---@param x number
---@param y number
local function drawCard(card, x, y)
    atlas.draw(atlas.cards[card.suit][card.rank], x, y)
end

return {
    Suit = Suit,
    Rank = Rank,
    Card = Card,
    drawCard = drawCard,
    FLAT_OFFSET = FLAT_OFFSET
}
