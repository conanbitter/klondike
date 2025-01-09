if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local cards = require "cards"
local decks = require "decks"

---@type Deck[]
local all_decks
---@type Reserve
local reserve
---@type Card[]
local hand = {}
---@type number
local hand_x = 0
---@type number
local hand_y = 0
---@type Deck?
local old_place = nil

local screen_transform = love.math.newTransform()

function love.load()
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    cards.init()
    all_decks, reserve = decks.init()

    screen_transform:scale(3, 3)
end

function love.update(dt)
    if #hand > 0 then
        local mx, my = screen_transform:inverseTransformPoint(love.mouse.getPosition())
        hand_x = math.floor(mx - CARD_WIDTH / 2);
        if #hand == 1 then
            hand_y = math.floor(my - CARD_HEIGHT / 2);
        else
            hand_y = math.floor(my - FLAT_OFFSET / 2);
        end
    end
end

function love.draw()
    -- scaling
    love.graphics.push()
    love.graphics.applyTransform(screen_transform)

    for _, deck in ipairs(all_decks) do
        deck:draw()
    end

    if #hand > 0 then
        cards.draw_multiple(hand, hand_x, hand_y)
    end

    love.graphics.pop()
end

function love.mousepressed(x, y, button, istouch, presses)
    local mx, my = screen_transform:inverseTransformPoint(x, y)
    mx = math.floor(mx)
    my = math.floor(my)

    if reserve:click(mx, my) then return end

    for _, deck in ipairs(all_decks) do
        if deck:trygrab(mx, my, hand) then
            old_place = deck
            break
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    --TODO fix fallback for Reserve
    if #hand == 0 then return end
    for _, deck in ipairs(all_decks) do
        if deck:trydrop(hand_x, hand_y, hand) then
            cards.move_multiple(hand, deck.cards)
            ---@cast old_place FlatDeck
            if old_place ~= deck and old_place.covered ~= nil and old_place.covered >= #old_place.cards then
                old_place.covered = #old_place.cards - 1
            end
            return
        end
    end
    if old_place then
        cards.move_multiple(hand, old_place.cards)
    end
end
