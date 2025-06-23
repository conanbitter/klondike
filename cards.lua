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

---@class CardSlice
---@field src Card[]
---@field pos number
---@field count number
---@field fromBottom fun(source:Card[], count:number?):CardSlice
---@field fromTop fun(source:Card[], count:number?):CardSlice
---@field move fun(self:CardSlice, to:Card, pos:number?)
---@overload fun(source:Card[], index:number, count:number):CardSlice
local CardSlice = Object:extend()

---@param source Card[]
---@param index number
---@param count number
function CardSlice:new(source, index, count)
    self.src = source
    self.pos = index
    self.count = count
end

function CardSlice.fromBottom(source, count)
    if count == nil then
        count = 1
    end
    return CardSlice(source, 1, count)
end

function CardSlice.fromTop(source, count)
    if count == nil then
        return CardSlice(source, #source, 1)
    else
        return CardSlice(source, #source - count + 1, count)
    end
end

function CardSlice:move(to, pos)
    if pos == nil then
        pos = #to + 1
    end
    local startpos = pos
    for i = 1, self.count do
        local card = table.remove(self.src, self.pos)
        table.insert(to, pos, card)
        pos = pos + 1
    end
    self.src = to
    self.pos = startpos
end

---@param card Card
function PrintCard(card)
    print("Card ", card.rank, card.suit)
end

---@param array Card[]
function PrintCardArray(array)
    for _, v in ipairs(array) do
        PrintCard(v)
    end
end

---@param slice CardSlice
function PrintCardSlice(slice)
    for i = slice.pos, slice.pos + slice.count - 1 do
        PrintCard(slice.src[i])
    end
end

return {
    Suit = Suit,
    Rank = Rank,
    Card = Card,
    CardSlice = CardSlice,
    drawCard = drawCard,
    FLAT_OFFSET = FLAT_OFFSET
}
