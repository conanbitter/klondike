local module = {}

local MIN_SPEED = 300
local MAX_SPEED = 5000
local MAX_DISTANCE = math.sqrt(SCREEN_WIDTH * SCREEN_WIDTH + SCREEN_HEIGHT * SCREEN_HEIGHT)
local SPEED_MUL = (MAX_SPEED - MIN_SPEED) / MAX_DISTANCE

---@param pos Vector
---@param to Vector
---@param dt number
---@return boolean
function module.move(pos, to, dt)
    local distance = pos:distance(to)
    local speed = (SPEED_MUL * distance + MIN_SPEED) * dt
    if distance > speed then
        local direction = pos:direction(to)
        pos.x = pos.x + speed * direction.x
        pos.y = pos.y + speed * direction.y
        return false
    else
        pos.x = to.x
        pos.y = to.y
        return true
    end
end

return module
