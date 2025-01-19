if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local cards = require "cards"
local decks = require "decks"
local Vector = require "vector"
local ui = require "ui"
local settings = require "settings"

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
---@type Vector
local old_pos = Vector(0, 0)

---@type number?
local since_last_mousedown = nil

local menu_layout = "menu_en"

---@type love.Image
local menu_background

local background_offset = 0.0

local screen_transform = love.math.newTransform()

local hand_latched = false

local target_pos = Vector(0, 0)

---@type Deck
local target_deck

---@enum AppState
local AppState = {
    Game = 1,
    Menu = 2,
    Win = 3
}

---@enum Animation
local Animation = {
    None = 1,
    Grabbing = 2,
    Dropping = 3,
    Returning = 4,
    NewGame = 5,
    Victory = 6
}

local state = AppState.Game
local animation = Animation.None

_G.DOUBLE_CLICK_TIME = 0.3
_G.HAND_MOVE_SPEED = 400.0

---@param scale number
local function set_scale(scale)
    screen_transform:reset()
    screen_transform:scale(scale, scale)
    love.window.setMode(SCREEN_WIDTH * scale, SCREEN_HEIGHT * scale)
end

local function check_win()
    for _, home in pairs(homes) do
        print(#home.cards)
        if #home.cards < 13 then return end
    end
    state = AppState.Win
    print("Win!")
end

---@param command string
---@param value any
local function ui_callback(command, value)
    if value then
        print(command .. " - " .. value)
    else
        print(command)
    end
    if command == "lang" then
        menu_layout = "menu_" .. value
        settings.language = value
    elseif command == "scale" then
        set_scale(value)
        settings.scale = value
    elseif command == "menu" then
        state = AppState.Menu
    elseif command == "close" then
        state = AppState.Game
        settings.save()
    elseif command == "quit" then
        settings.save()
        love.event.quit()
    end
end

function love.load()
    settings.load()
    DOUBLE_CLICK_TIME = settings.dblclick
    menu_layout = "menu_" .. settings.language
    set_scale(settings.scale)

    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    menu_background = love.graphics.newImage("menu_back.png")
    cards.init()
    all_decks, reserve, homes = decks.init()
    ui.init(ui_callback)

    --screen_transform:scale(3, 3)
end

function love.update(dt)
    if state == AppState.Menu then
        background_offset = background_offset - dt * 5.0
        if -background_offset > 350 then
            background_offset = background_offset + 350
        end
    else
        if #hand > 0 then
            local mx, my = screen_transform:inverseTransformPoint(love.mouse.getPosition())
            mx = math.floor(mx - CARD_WIDTH / 2);
            if #hand == 1 then
                my = math.floor(my - CARD_HEIGHT / 2);
            else
                my = math.floor(my - FLAT_OFFSET / 2);
            end

            if animation == Animation.Grabbing then
                target_pos.x = mx
                target_pos.y = my
            elseif animation == Animation.None then
                hand_x = mx
                hand_y = my
            end
        end

        if animation == Animation.Grabbing or
            animation == Animation.Dropping or
            animation == Animation.Returning then
            local hand_vec = Vector(hand_x, hand_y)
            if hand_vec:distance(target_pos) > HAND_MOVE_SPEED * dt then
                local direction = hand_vec:direction(target_pos)
                hand_vec = hand_vec + direction * HAND_MOVE_SPEED * dt
                hand_x = hand_vec.x
                hand_y = hand_vec.y
            else
                if animation == Animation.Dropping then
                    if target_deck:trydrop(hand_x, hand_y, hand) then
                        cards.move_multiple(hand, target_deck.cards)
                        ---@cast old_place FlatDeck
                        if old_place ~= target_deck and old_place.covered ~= nil and old_place.covered >= #old_place.cards then
                            old_place.covered = #old_place.cards - 1
                        end
                        check_win()
                    end
                elseif animation == Animation.Returning then
                    if old_place then old_place:revert_drop(hand) end
                end
                animation = Animation.None
            end
        end
    end
end

function love.draw()
    -- scaling
    love.graphics.push()
    love.graphics.applyTransform(screen_transform)

    if state == AppState.Game then
        ui.draw("game")
    end

    for _, deck in ipairs(all_decks) do
        deck:draw()
    end

    if #hand > 0 then
        cards.draw_multiple(hand, hand_x, hand_y)
    end

    if state == AppState.Menu then
        love.graphics.draw(menu_background, background_offset, 0)
        love.graphics.draw(menu_background, background_offset + 350, 0)
        ui.draw(menu_layout)
    end

    love.graphics.pop()
end

function love.mousepressed(x, y, button, istouch, presses)
    local mx, my = screen_transform:inverseTransformPoint(x, y)
    mx = math.floor(mx)
    my = math.floor(my)

    if state == AppState.Menu then
        ui.mouse_down(menu_layout, mx, my)
        return
    else
        ui.mouse_down("game", mx, my)
    end

    if reserve:click(mx, my) then return end

    for _, deck in ipairs(all_decks) do
        local pos = deck:trygrab(mx, my, hand)
        if pos then
            old_place = deck
            old_pos = pos
            animation = Animation.Grabbing
            hand_x = pos.x
            hand_y = pos.y
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
            check_win()
        end
        since_last_mousedown = nil
    else
        --[[if since_last_mousedown then
            print(love.timer.getTime() - since_last_mousedown)
        end]]
        since_last_mousedown = love.timer.getTime()
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    local mx, my = screen_transform:inverseTransformPoint(x, y)
    mx = math.floor(mx)
    my = math.floor(my)
    local mouse_pressed = love.mouse.isDown(1)
    if state == AppState.Menu then
        ui.mouse_move(menu_layout, mx, my, mouse_pressed)
    else
        ui.mouse_move("game", mx, my, mouse_pressed)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    local mx, my = screen_transform:inverseTransformPoint(x, y)
    mx = math.floor(mx)
    my = math.floor(my)

    if state == AppState.Menu then
        ui.mouse_up(menu_layout, mx, my)
        return
    else
        ui.mouse_up("game", mx, my)
    end

    if #hand == 0 then return end
    ---@type Deck?
    local candidate = nil
    local distance = 1.0e10
    local hand_pos = Vector(hand_x, hand_y)
    local candidate_pos = Vector(0, 0)
    local candidate_acc = DropAccept.Decline
    for _, deck in ipairs(all_decks) do
        local accept, deck_pos = deck:candrop(hand_x, hand_y, hand)
        if accept ~= DropAccept.Decline and deck_pos then
            local deck_distance = hand_pos:distance2(deck_pos)
            if deck_distance < distance then
                candidate = deck
                candidate_pos.x = deck_pos.x
                candidate_pos.y = deck_pos.y
                candidate_acc = accept
                -- TODO: Process not acceptable places
                if deck.covered then
                    candidate_pos.y = candidate_pos.y + FLAT_OFFSET
                end
                distance = deck_distance
            end
        end
    end
    if candidate and candidate_acc == DropAccept.Accept then
        target_deck = candidate
        target_pos = candidate_pos
        animation = Animation.Dropping
    elseif old_place then
        target_deck = old_place
        target_pos = old_pos
        animation = Animation.Returning
    end
end
