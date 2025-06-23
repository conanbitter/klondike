if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local AdvancedMouse = require "mouse"
local Pixels = require "pixels"
local atlas = require "atlas"
local cards = require "cards"
local Game = require "game"

---@type AdvancedMouse
local mouse = AdvancedMouse()

---@type Pixels
local pixels

---@type Game
local game

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
    game = Game()
    game:new_game()

    local tb1 = { cards.Card(1, 1), cards.Card(1, 2), cards.Card(1, 3), cards.Card(1, 4), cards.Card(1, 5) }
    print("tb1 start")
    PrintCardArray(tb1)
    local tb2 = { cards.Card(2, 1), cards.Card(2, 2), cards.Card(2, 3), cards.Card(2, 4), cards.Card(2, 5) }
    print("tb2 start")
    PrintCardArray(tb2)
    print("test top")
    PrintCardSlice(cards.CardSlice.fromTop(tb1, 2))
    print("test bottom")
    PrintCardSlice(cards.CardSlice.fromBottom(tb1, 2))
    local tbslice = cards.CardSlice(tb1, 3, 2)
    print("slice")
    PrintCardSlice(tbslice)
    tbslice:move(tb2, 2)
    print("tb1 end")
    PrintCardArray(tb1)
    print("tb2 end")
    PrintCardArray(tb2)
end

function love.update(dt)
    mouse:doUpdate()
end

function love.draw()
    pixels:begin()
    love.graphics.clear()
    game:draw()
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

function love.keypressed(key, scancode, isrepeat)
    if scancode == "1" then
        print("[DEBUG] Show Grab rects")
        game.debug = 1
    elseif scancode == "2" then
        print("[DEBUG] Show Drop rects")
        game.debug = 2
    elseif scancode == "3" then
        print("[DEBUG] Show Click rects")
        game.debug = 3
    elseif scancode == "4" then
        print("[DEBUG] Show DblClick rects")
        game.debug = 4
    elseif scancode == "0" then
        print("[DEBUG] Hide rects")
        game.debug = 0
    end
end
