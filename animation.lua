local module = {}

local MIN_SPEED = 250
local MAX_SPEED = 4000
local MAX_DISTANCE = math.sqrt(SCREEN_WIDTH * SCREEN_WIDTH + SCREEN_HEIGHT * SCREEN_HEIGHT)
local SPEED_MUL = (MAX_SPEED - MIN_SPEED) / MAX_DISTANCE
local MAX_TIME = 0.1

local anim_start = 0
local anim_fixed = false

---@param a number
---@param b number
---@return number
local function max(a, b)
    if a > b then
        return a
    else
        return b
    end
end

---@param distance number
---@return number
local function speed_dist(distance)
    return SPEED_MUL * distance + MIN_SPEED
end

---@param distance number
---@param dt number
---@return number
local function speed_fixed(distance, dt)
    local last_time = love.timer.getTime() - dt
    local time = MAX_TIME + anim_start - last_time
    return distance / time
end

---@param pos Vector
---@param to Vector
---@param dt number
---@return boolean
function module.move(pos, to, dt)
    local distance = pos:distance(to)
    local speed
    if anim_fixed then
        speed = max(speed_dist(distance), speed_fixed(distance, dt)) * dt
    else
        speed = speed_dist(distance) * dt
    end
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

---@param fixed boolean?
function module.start(fixed)
    if fixed then
        anim_fixed = true
    else
        anim_fixed = false
    end
    anim_start = love.timer.getTime()
end

return module
