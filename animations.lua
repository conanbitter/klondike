local Object = require "lib.classic"
local Vec2 = require "geometry".Vec2
local CardSlice = require "cards".CardSlice
local CARD_WIDTH = require "cards".CARD_WIDTH

---@class Animator
---@field animations table<Deck, Animation>
---@field setAnimation fun(self:Animator, deck:Deck, anim:Animation)
---@field clearAnimation fun(self:Animator, deck:Deck)
---@field update fun(self:Animator, game:Game)
---@overload fun():Animator
local Animator = Object:extend()

function Animator:new()
    self.animations = {}
end

function Animator:setAnimation(deck, anim)
    self.animations[deck] = anim
end

function Animator:clearAnimation(deck)
    self.animations[deck] = nil
end

function Animator:update(game)
    for _, anim in pairs(self.animations) do
        anim:update(game)
    end
end

---@class Animation : Object
---@field parent Deck
---@field update fun(self:Animation, game:Game)
---@overload fun(parent:Deck):Animation
local Animation = Object:extend()

function Animation:new(parent)
    self.parent = parent
end

function Animation:update(game)
end

---@class HandAnim : Animation
---@field cards CardSlice
---@field pos Vec2
---@overload fun(parent:Deck, index:number):HandAnim
local HandAnim = Animation:extend()

---@param parent Deck
---@param index number
function HandAnim:new(parent, index)
    HandAnim.super.new(self, parent)
    self.pos = Vec2(0, 0)
    self.cards = CardSlice.fromTop(parent, index)
end

---@param game Game
function HandAnim:update(game)
    self.pos.x = game.mousePos.x - CARD_WIDTH / 2
    self.pos.y = game.mousePos.y
end

return {
    HandAnim = HandAnim
}
