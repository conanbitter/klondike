local cards = require "cards"

function love.load()
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    cards.load()
end

function love.draw()
    -- scaling
    love.graphics.push()
    love.graphics.scale(3, 3)

    cards.draw(cards.back, 10, 10)
    cards.draw(cards.placeholder_homes[cards.Suit.Clubs], 100, 10)
    cards.draw_card(cards.Suit.Diamonds, cards.Rank.Queen, 10, 200)

    love.graphics.pop()
end
