local Object = require "lib.classic"
local Vec2 = require "geometry".Vec2

local defaultFlags = {
    minwidth = SCREEN_WIDTH,
    minheight = SCREEN_HEIGHT,
    resizable = true,
    vsync = 1,
}

---@class Pixels
---@field private canvas love.Canvas
---@field private scale number
---@field private posX number
---@field private posY number
---@field private oldWidth number
---@field private oldHeight number
---@field begin fun(self:Pixels)
---@field finish fun(self:Pixels)
---@field setScale fun(self:Pixels, newScale:number)
---@field updateSize fun(self:Pixels, width:number, height:number)
---@field posTo fun(self:Pixels, pos:Vec2):Vec2
---@overload fun():Pixels
local Pixels = Object:extend()

function Pixels:new(initScale)
    self.canvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.scale = 1
    self.posX = 0
    self.posY = 0
    self.oldWidth = 0
    self.oldHeight = 0
end

function Pixels:begin()
    love.graphics.setCanvas(self.canvas)
end

function Pixels:finish()
    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.posX, self.posY, nil, self.scale, self.scale)
end

function Pixels:setScale(newScale)
    self.scale = newScale
    self.posX = 0
    self.posY = 0
    self.oldWidth = SCREEN_WIDTH * self.scale
    self.oldHeight = SCREEN_HEIGHT * self.scale
    love.window.setMode(self.oldWidth, self.oldHeight, defaultFlags)
end

function Pixels:updateSize(width, height)
    if width == self.oldWidth and height == self.oldHeight then
        return
    end
    self.scale = math.floor(math.min(width / SCREEN_WIDTH, height / SCREEN_HEIGHT))
    self.posX = math.floor((width - SCREEN_WIDTH * self.scale) / 2)
    self.posY = math.floor((height - SCREEN_HEIGHT * self.scale) / 2)
    self.oldWidth = width
    self.oldHeight = height
end

function Pixels:posTo(pos)
    return Vec2(
        math.floor((pos.x - self.posX) / self.scale),
        math.floor((pos.y - self.posY) / self.scale))
end

return Pixels
