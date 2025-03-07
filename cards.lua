local module = {}

_G.CARD_WIDTH = 42
_G.CARD_HEIGHT = 60
_G.FLAT_OFFSET = 14

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

function module.init()
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
        [Suit.Hearts] = love.graphics.newQuad(126, 240, CARD_WIDTH, CARD_HEIGHT, sprites),
        [Suit.Diamonds] = love.graphics.newQuad(168, 240, CARD_WIDTH, CARD_HEIGHT, sprites),
        [Suit.Clubs] = love.graphics.newQuad(210, 240, CARD_WIDTH, CARD_HEIGHT, sprites),
        [Suit.Spades] = love.graphics.newQuad(252, 240, CARD_WIDTH, CARD_HEIGHT, sprites),
    }
end

---@param item love.Quad
---@param x number
---@param y number
function module.draw_other(item, x, y)
    love.graphics.draw(sprites, item, x, y)
end

---@param card Card
---@param x number
---@param y number
function module.draw_single(card, x, y)
    love.graphics.draw(sprites, card_quads[card.suit][card.rank], x, y)
end

---@param cards Card[]
---@param x number
---@param y number
function module.draw_multiple(cards, x, y)
    for i, card in ipairs(cards) do
        module.draw_single(card, x, y + (i - 1) * FLAT_OFFSET)
    end
end

---@param suit1 Suit
---@param suit2 Suit
---@return boolean
function module.suit_compatible(suit1, suit2)
    if suit1 == Suit.Clubs or suit1 == Suit.Spades then
        return suit2 == Suit.Hearts or suit2 == Suit.Diamonds
    else
        return suit2 == Suit.Clubs or suit2 == Suit.Spades
    end
end

---@param src Card[]
---@param dst Card[]
---@param from ?number
function module.move_multiple(src, dst, from)
    for i = from or 1, #src do
        table.insert(dst, src[i])
        src[i] = nil
    end
end

---@param src Card[]
---@param src_pos number
---@param dst Card[]
---@param dst_pos ?number
---@overload fun(src:Card[], dst:Card[])
function module.move_single(src, src_pos, dst, dst_pos)
    if dst == nil and type(src_pos) == "table" then
        dst = src_pos --[=[@as Card[]]=]
        src_pos = #src
    end
    if dst_pos == nil then
        table.insert(dst, src[src_pos])
    else
        table.insert(dst, dst_pos, src[src_pos])
    end
    table.remove(src, src_pos)
end

return module
