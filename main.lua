local cards = require "cards"
local decks = require "decks"

function love.load()
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    cards.load()
    decks.init()
end

function love.draw()
    -- scaling
    love.graphics.push()
    love.graphics.scale(3, 3)

    cards.draw(cards.back, 10, 10)
    cards.draw(cards.placeholder_homes[Suit.Clubs], 100, 10)

    local mx, my = love.graphics.inverseTransformPoint(love.mouse.getPosition())
    cards.draw_card(Suit.Diamonds, Rank.Queen, mx - CARD_WIDTH / 2, my - CARD_HEIGHT / 2)

    love.graphics.pop()
end
