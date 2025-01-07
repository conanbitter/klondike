local module = {}

_G.CARD_WIDTH = 42
_G.CARD_HEIGHT = 60

---@enum Suit
_G.Suit = {
    Hearts = 1,
    Diamonds = 2,
    Clubs = 3,
    Spades = 4
}

---@enum Rank
_G.Rank = {
    Ace = 1,
    Two = 2,
    Three = 3,
    Four = 4,
    Five = 5,
    Six = 6,
    Seven = 7,
    Eight = 8,
    Nine = 9,
    Ten = 10,
    Jack = 11,
    Queen = 12,
    King = 13
}

---@type love.Image
local sprites

---@type love.Quad[][]
local card_quads = {}

---@type love.Quad
module.back = nil

---@type love.Quad
module.placeholder_empty = nil

---@type love.Quad
module.placeholder_refresh = nil

---@type love.Quad[]
module.placeholder_homes = {}

function module.load()
    sprites = love.graphics.newImage("sprites.png")
    module.back = love.graphics.newQuad(0, 240, CARD_WIDTH, CARD_HEIGHT, sprites)

    for suit = 1, 4 do
        card_quads[suit] = {}
        for rank = 1, 13 do
            card_quads[suit][rank] = love.graphics.newQuad(
                (rank - 1) * CARD_WIDTH,
                (suit - 1) * CARD_HEIGHT,
                CARD_WIDTH,
                CARD_HEIGHT,
                sprites)
        end
    end

    module.placeholder_empty = love.graphics.newQuad(42, 240, CARD_WIDTH, CARD_HEIGHT, sprites)
    module.placeholder_refresh = love.graphics.newQuad(84, 240, CARD_WIDTH, CARD_HEIGHT, sprites)
    module.placeholder_homes = {
        [module.Suit.Hearts] = love.graphics.newQuad(126, 240, CARD_WIDTH, CARD_HEIGHT, sprites),
        [module.Suit.Diamonds] = love.graphics.newQuad(168, 240, CARD_WIDTH, CARD_HEIGHT, sprites),
        [module.Suit.Clubs] = love.graphics.newQuad(210, 240, CARD_WIDTH, CARD_HEIGHT, sprites),
        [module.Suit.Spades] = love.graphics.newQuad(252, 240, CARD_WIDTH, CARD_HEIGHT, sprites),
    }
end

---@param item love.Quad
---@param x number
---@param y number
function module.draw(item, x, y)
    love.graphics.draw(sprites, item, x, y)
end

---@param suit Suit
---@param rank Rank
---@param x number
---@param y number
function module.draw_card(suit, rank, x, y)
    love.graphics.draw(sprites, card_quads[suit][rank], x, y)
end

return module
