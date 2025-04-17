local Object = require "lib.classic"
local Vec2 = require "geometry".Vec2
local atlas = require "atlas"

---@class Deck
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
---@overload fun(x:number, y:number):Deck
local Deck = Object:extend()

---@param x number
---@param y number
function Deck:new(x, y)
    self.pos = Vec2(x, y)
    self.cards = {}
    self.placeholder = atlas.placeholder_empty
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
