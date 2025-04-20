local Object = require "lib.classic"
local Vec2 = require "geometry".Vec2
local atlas = require "atlas"

--#region Deck

---@class Deck : Object
---@field pos Vec2
---@field cards Card[]
---@field placeholder love.Quad
---@field boundsGrab Rect?
---@field boundsDrop Rect?
---@field boundsClick Rect?
---@field boundsDblClick Rect?
---@field draw fun(self:Deck)
---@field onGrab fun(self:Deck, point:Vec2)
---@field onDrop fun(self:Deck, hand:Card[])
---@field onClick fun(self:Deck, point:Vec2)
---@field onDblClick fun(self:Deck, point:Vec2)
---@overload fun(x:number, y:number, placeholder:love.Quad):Deck
local Deck = Object:extend()

---@param x number
---@param y number
function Deck:new(x, y, placeholder)
    self.pos = Vec2(x, y)
    self.cards = {}
    self.placeholder = placeholder
    self.boundsGrab = nil
    self.boundsDrop = nil
    self.boundsClick = nil
    self.boundsDblClick = nil
end

function Deck:onGrab(point)
end

function Deck:onDrop(hand)
end

function Deck:onClick(point)
end

function Deck:onDblClick(point)
end

--#endregion

--#region FlatDeck

---@class FlatDeck : Deck
---@field covered number
---@overload fun(x:number, y:number):FlatDeck
local FlatDeck = Deck:extend()

---@param x number
---@param y number
function FlatDeck:new(x, y)
    FlatDeck.super.new(self, x, y, atlas.placeholder_empty)
    self.covered = 0
end

function FlatDeck:draw()

end

--#endregion

--#region HomeDeck

---@class HomeDeck : Deck
---@field suit Suit
---@overload fun(x:number, y:number, suit:Suit):HomeDeck
local HomeDeck = Deck:extend()

---@param x number
---@param y number
---@param suit Suit
function HomeDeck:new(x, y, suit)
    HomeDeck.super.new(self, x, y, atlas.placeholder_homes[suit])
    self.suit = suit
end

function HomeDeck:draw()

end

--#endregion

--#region ReserveDeck

local RESERVE_OFFSET = 52

---@class ReserveDeck : Deck
---@field index number
---@field pos2 Vec2
---@overload fun(x:number, y:number):ReserveDeck
local ReserveDeck = Deck:extend()

---@param x number
---@param y number
function ReserveDeck:new(x, y, suit)
    ReserveDeck.super.new(self, x, y, atlas.placeholder_refresh)
    self.index = 0
    self.pos2 = Vec2(x + RESERVE_OFFSET, y)
end

function ReserveDeck:draw()

end

--#endregion
