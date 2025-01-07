if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local cards = require "cards"
local decks = require "decks"

local deck_list

function love.load()
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    cards.init()
    deck_list = decks.init()
end

function love.draw()
    -- scaling
    love.graphics.push()
    love.graphics.scale(3, 3)

    if not deck_list.cursor:is_empty() then
        local mx, my = love.graphics.inverseTransformPoint(love.mouse.getPosition())
        deck_list.cursor.x = mx - CARD_WIDTH / 2;
        deck_list.cursor.y = my - CARD_HEIGHT / 2;
    end

    for _, deck in ipairs(deck_list.all) do
        deck:draw()
    end

    love.graphics.pop()
end
