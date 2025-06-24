local Object = require "lib.classic"

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

---@class Animation
---@field parent Deck
---@field update fun(self:Animation, game:Game)
---@overload fun(parent:Deck):Animation
local Animation = Object:extend()

function Animation:new(parent)
    self.parent = parent
end

function Animation:update(game)
end
