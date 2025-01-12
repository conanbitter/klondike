if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local cards = require "cards"
local decks = require "decks"
local vector = require "vector"
local ui = require "ui"

---@type Deck[]
local all_decks
---@type Reserve
local reserve
---@type Home[]
local homes
---@type Card[]
local hand = {}
---@type number
local hand_x = 0
---@type number
local hand_y = 0
---@type Deck?
local old_place = nil

---@type number?
local since_last_mousedown = nil

local screen_transform = love.math.newTransform()

---@type { [string]:UIElement[] }
local ui_layouts

_G.DOUBLE_CLICK_TIME = 0.3

function love.load()
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    cards.init()
    all_decks, reserve, homes = decks.init()
    ui_layouts = ui.init()

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

    for _, elt in ipairs(ui_layouts.game) do
        elt:draw()
    end

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

    if since_last_mousedown and
        love.timer.getTime() - since_last_mousedown < DOUBLE_CLICK_TIME and
        #hand == 1 then
        local home = homes[hand[1].suit]
        if (home:is_empty() and hand[1].rank == Rank.Ace) or
            (not home:is_empty() and hand[1].rank == home.cards[#home.cards].rank + 1) then
            cards.move_single(hand, home.cards)
            ---@cast old_place FlatDeck
            if old_place and old_place.covered ~= nil and old_place.covered >= #old_place.cards then
                old_place.covered = #old_place.cards - 1
            end
        end
        since_last_mousedown = nil
    else
        --[[if since_last_mousedown then
            print(love.timer.getTime() - since_last_mousedown)
        end]]
        since_last_mousedown = love.timer.getTime()
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    --TODO fix fallback for Reserve
    if #hand == 0 then return end
    ---@type Deck?
    local candidate = nil
    local distance = 1.0e10
    local hand_pos = vector.new_vector(hand_x, hand_y)
    for _, deck in ipairs(all_decks) do
        local deck_pos = deck:candrop(hand_x, hand_y)
        if deck_pos then
            local deck_distance = hand_pos:distance2(deck_pos)
            if deck_distance < distance then
                candidate = deck
                distance = deck_distance
            end
        end
    end
    if candidate then
        if candidate:trydrop(hand_x, hand_y, hand) then
            cards.move_multiple(hand, candidate.cards)
            ---@cast old_place FlatDeck
            if old_place ~= candidate and old_place.covered ~= nil and old_place.covered >= #old_place.cards then
                old_place.covered = #old_place.cards - 1
            end
            return
        end
    end
    if old_place then
        old_place:revert_drop(hand)
    end
end
