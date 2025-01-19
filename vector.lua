local Object = require "lib.classic"

local module = {}

---@class Vector
---@field x number
---@field y number
---@field distance2 fun(self: Vector, other: Vector):number
---@field distance fun(self: Vector, other: Vector):number
---@field direction fun(self: Vector, to: Vector):Vector
---@overload fun(x:number, y:number):Vector
local Vector = Object:extend()

---@param other Vector
---@return number
function Vector:distance2(other)
    return (self.x - other.x) * (self.x - other.x) + (self.y - other.y) * (self.y - other.y)
end

---@param other Vector
---@return number
function Vector:distance(other)
    return math.sqrt((self.x - other.x) * (self.x - other.x) + (self.y - other.y) * (self.y - other.y))
end

---@param other Vector
---@return Vector
function Vector:__add(other)
    return Vector(self.x + other.x, self.y + other.y)
end

---@param scale number
---@return Vector
function Vector:__mul(scale)
    return Vector(self.x * scale, self.y * scale)
end

---@param scale number
---@return Vector
function Vector:__div(scale)
    return Vector(self.x / scale, self.y / scale)
end

---@param to Vector
---@return Vector
function Vector:direction(to)
    local distance = self:distance(to)
    return Vector((to.x - self.x) / distance, (to.y - self.y) / distance)
end

---@param self Vector
---@param x number
---@param y number
function Vector:new(x, y)
    self.x = x
    self.y = y
end

return Vector
