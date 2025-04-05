if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local AdvancedMouse = require "mouse"
local Pixels = require "pixels"
local atlas = require "atlas"
local cards = require "cards"

---@type AdvancedMouse
local mouse = AdvancedMouse()

---@type Pixels
local pixels

function mouse.onGrab(x, y)
    print("Grab", x, y)
end

function mouse.onDrag(x, y)
    print("Drag", x, y)
end

function mouse.onDrop(x, y)
    print("Drop", x, y)
end

function mouse.onClick(x, y)
    print("Click", x, y)
end

function mouse.onDblClick(x, y)
    print("DblClick", x, y)
end

function love.load()
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    pixels = Pixels()
    pixels:setScale(3)
    atlas.init()
end

function love.update(dt)
    mouse:doUpdate()
end

function love.draw()
    pixels:begin()
    cards.drawCard(cards.Card(cards.Suit.Spades, cards.Rank.Jack), 100, 100)
    atlas.draw(atlas.cards[2][3], 10, 10)
    pixels:finish()
end

function love.resize(width, height)
    pixels:updateSize(width, height)
end

function love.mousepressed(x, y, button, istouch, presses)
    mouse:doMouseDown(x, y)
end

function love.mousemoved(x, y, dx, dy, istouch)
    mouse:doMouseMove(x, y)
end

function love.mousereleased(x, y, button, istouch, presses)
    mouse:doMouseUp(x, y)
end
