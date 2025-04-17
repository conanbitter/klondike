local Object = require "lib.classic"

--#region Vec2

---@class Vec2
---@field x number
---@field y number
---@field distance2 fun(self: Vec2, other: Vec2):number
---@field distance fun(self: Vec2, other: Vec2):number
---@field direction fun(self: Vec2, to: Vec2):Vec2
---@overload fun(x:number, y:number):Vec2
local Vec2 = Object:extend()

function Vec2:distance2(other)
    return (self.x - other.x) * (self.x - other.x) + (self.y - other.y) * (self.y - other.y)
end

function Vec2:distance(other)
    return math.sqrt((self.x - other.x) * (self.x - other.x) + (self.y - other.y) * (self.y - other.y))
end

function Vec2:__add(other)
    return Vec2(self.x + other.x, self.y + other.y)
end

function Vec2:__mul(scale)
    return Vec2(self.x * scale, self.y * scale)
end

function Vec2:__div(scale)
    return Vec2(self.x / scale, self.y / scale)
end

function Vec2:direction(to)
    local distance = self:distance(to)
    return Vec2((to.x - self.x) / distance, (to.y - self.y) / distance)
end

---@param x number
---@param y number
function Vec2:new(x, y)
    self.x = x
    self.y = y
end

--#endregion

--#region Rect

---@class Rect
---@field x number
---@field y number
---@field w number
---@field h number
---@field inBounds fun(self:Rect, point:Vec2):boolean
---@field intersect fun(self:Rect, other:Rect):boolean
---@overload fun(x:number, y:number, w:number, h:number)
local Rect = Object:extend()

function Rect:inBounds(point)
    return point.x >= self.x and
        point.x <= self.x + self.h and
        point.y >= self.y and
        point.y <= self.y + self.h
end

function Rect:intersect(other)
    return (self.x <= other.x + other.w and self.x + self.w >= other.x) and
        (self.y <= other.y + other.h and self.y + self.h >= other.y)
end

---@param x number
---@param y number
---@param w number
---@param h number
function Rect:new(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

--#endregion

return {
    Vec2 = Vec2,
    Rect = Rect
}
