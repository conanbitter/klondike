local Object = require "lib.classic"

local GRAB_DELAY = 0.2
local DBL_DELAY = 0.3
local MOVE_TOLERANCE = 2

---@enum MouseState
local MouseState = {
    Normal = 1,
    MaybeGrab = 2,
    Dragging = 3,
}

---@class AdvancedMouse
---@field private sinceMouseDown number
---@field private sinceLastClick number?
---@field private lastX number
---@field private lastY number
---@field private lastClickX number
---@field private lastClickY number
---@field private state MouseState
---@field doMouseDown fun(self:AdvancedMouse, x:number, y:number)
---@field doMouseUp fun(self:AdvancedMouse, x:number, y:number)
---@field doMouseMove fun(self:AdvancedMouse, x:number, y:number)
---@field doUpdate fun(self:AdvancedMouse)
---@field private waitExpaired fun(self:AdvancedMouse)
---@field onGrab fun(x:number,y:number)
---@field onDrag fun(x:number,y:number)
---@field onDrop fun(x:number,y:number)
---@field onClick fun(x:number,y:number)
---@field onDblClick fun(x:number, y:number)
---@overload fun():AdvancedMouse
local AdvancedMouse = Object:extend()

local function dummyEvent()

end

function AdvancedMouse:new()
    self.sinceLastClick = nil
    self.sinceMouseDown = 0
    self.lastX = 0
    self.lastY = 0
    self.lastClickX = 0
    self.lastClickY = 0
    self.state = MouseState.Normal
    self.onGrab = dummyEvent
    self.onDrag = dummyEvent
    self.onDrop = dummyEvent
    self.onClick = dummyEvent
    self.onDblClick = dummyEvent
end

function AdvancedMouse:doMouseDown(x, y)
    if self.state == MouseState.Normal then
        self.state = MouseState.MaybeGrab
        self.lastX = x
        self.lastY = y
        self.sinceMouseDown = love.timer.getTime()
    end
end

function AdvancedMouse:doMouseUp(x, y)
    if self.state == MouseState.MaybeGrab then
        self.state = MouseState.Normal
        if self.sinceLastClick and
            love.timer.getTime() - self.sinceLastClick < DBL_DELAY and
            math.abs(x - self.lastClickX) < MOVE_TOLERANCE and
            math.abs(y - self.lastClickY) < MOVE_TOLERANCE then
            self.sinceLastClick = nil
            self.onDblClick(x, y)
        else
            self.sinceLastClick = love.timer.getTime()
            self.lastClickX = x
            self.lastClickY = y
        end
        self.onClick(x, y)
    elseif self.state == MouseState.Dragging then
        self.state = MouseState.Normal
        self.onDrop(x, y)
    end
end

function AdvancedMouse:doMouseMove(x, y)
    if self.state == MouseState.Dragging then
        self.onDrag(x, y)
    elseif math.abs(x - self.lastX) > MOVE_TOLERANCE or math.abs(y - self.lastY) > MOVE_TOLERANCE then
        self:waitExpaired()
    end
end

function AdvancedMouse:doUpdate()
    if love.timer.getTime() - self.sinceMouseDown > GRAB_DELAY then
        self:waitExpaired()
    end
end

function AdvancedMouse:waitExpaired()
    if self.state == MouseState.MaybeGrab then
        self.state = MouseState.Dragging
        self.onGrab(self.lastX, self.lastY)
    end
end

return AdvancedMouse
