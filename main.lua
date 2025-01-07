if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local cards = require "cards"
local decks = require "decks"

local deck_list
---@type Deck?
local old_place = nil

local screen_transform = love.math.newTransform()

function love.load()
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    cards.init()
    deck_list = decks.init()

    screen_transform:scale(3, 3)
end

function love.draw()
    -- scaling
    love.graphics.push()
    love.graphics.applyTransform(screen_transform)

    if not deck_list.cursor:is_empty() then
        local mx, my = love.graphics.inverseTransformPoint(love.mouse.getPosition())
        deck_list.cursor.x = mx - CARD_WIDTH / 2;
        if #deck_list.cursor.cards == 1 then
            deck_list.cursor.y = my - CARD_HEIGHT / 2;
        else
            deck_list.cursor.y = my - FLAT_OFFSET / 2;
        end
    end

    if not decks.card_intersect(100, 100, deck_list.cursor.x, deck_list.cursor.y) then
        cards.draw(cards.back, 100, 100)
    else
        cards.draw(cards.placeholder_refresh, 100, 100)
    end

    for _, deck in ipairs(deck_list.all) do
        deck:draw()
    end

    love.graphics.pop()
end

function love.mousepressed(x, y, button, istouch, presses)
    local mx, my = screen_transform:inverseTransformPoint(x, y)
    mx = math.floor(mx)
    my = math.floor(my)
    for _, deck in ipairs(deck_list.active) do
        if deck:trygrab(mx, my, deck_list.cursor) then
            old_place = deck
            break
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if not deck_list.cursor:is_empty() and old_place then
        deck_list.cursor:give(1, old_place)
    end
end
