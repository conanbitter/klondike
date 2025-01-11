local module = {}

---@class Vector
---@field x number
---@field y number
---@field distance2 fun(self: Vector, other: Vector):number

---comment
---@param self Vector
---@param other Vector
---@return number
local function vector_distance2(self, other)
    return (self.x - other.x) * (self.x - other.x) + (self.y - other.y) * (self.y - other.y)
end

---@param x number
---@param y number
---@return Vector
function module.new_vector(x, y)
    return {
        x = x,
        y = y,
        distance2 = vector_distance2
    }
end

return module
