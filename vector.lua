local Object = require "lib.classic"

local module = {}

---@class Vector
---@field x number
---@field y number
---@field distance2 fun(self: Vector, other: Vector):number
---@overload fun(x:number, y:number)
local Vector = Object:extend()

---comment
---@param self Vector
---@param other Vector
---@return number
function Vector:distance2(other)
    return (self.x - other.x) * (self.x - other.x) + (self.y - other.y) * (self.y - other.y)
end

---@param self Vector
---@param x number
---@param y number
function Vector:new(x, y)
    self.x = x
    self.y = y
end

return Vector
