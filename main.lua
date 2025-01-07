local cards = require "cards"

function love.load()
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
    cards.load()
end

function love.draw()
    cards.draw(cards.back, 10, 10)
    cards.draw(cards.placeholder_homes[cards.Suit.Clubs], 100, 10)

    cards.draw_card(cards.Suit.Diamonds, cards.Rank.Queen, 10, 200)
end
