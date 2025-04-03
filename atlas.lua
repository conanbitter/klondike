local module = {}

local TEX_WIDTH = 0
local TEX_HEIGHT = 0

---@type love.Image
local texture

--#region Cards

---@type love.Quad[][]
module.cards = {
    --Hearts
    {
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Ace
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Two
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Three
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Four
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Five
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Six
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Seven
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Eight
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Nine
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Ten
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Jack
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Queen
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --King
    },
    --Diamonds
    {
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Ace
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Two
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Three
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Four
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Five
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Six
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Seven
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Eight
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Nine
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Ten
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Jack
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Queen
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --King
    },
    --Clubs
    {
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Ace
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Two
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Three
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Four
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Five
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Six
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Seven
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Eight
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Nine
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Ten
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Jack
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Queen
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --King
    },
    --Spades
    {
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Ace
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Two
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Three
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Four
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Five
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Six
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Seven
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Eight
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Nine
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Ten
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Jack
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Queen
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --King
    }
}

---@type love.Quad
module.card_back = love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT)

---@type love.Quad
module.placeholder_empty = love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT)

---@type love.Quad
module.placeholder_refresh = love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT)

---@type love.Quad[]
module.placeholder_homes = {
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Hearts
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Diamonds
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Clubs
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT), --Spades
}

--#endregion

--#region UI

---@type love.Quad
module.label_scale_en = love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT)

---@type love.Quad
module.label_scale_ru = love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT)

---@type love.Quad[]
module.button_menu = {
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
}

---@type love.Quad[]
module.button_close = {
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
}

---@type love.Quad[]
module.button_new_en = {
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
}

---@type love.Quad[]
module.button_new_ru = {
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
}

---@type love.Quad[]
module.button_quit_en = {
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
}

---@type love.Quad[]
module.button_quit_ru = {
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
}

---@type love.Quad[][]
module.option_scale = {
    { --1x
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    },
    { --2x
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    },
    { --3x
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    },
    { --4x
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    }
}

---@type love.Quad[][]
module.option_lang = {
    { --EN
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    },
    { --RU
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
        love.graphics.newQuad(0, 1, 2, 3, TEX_WIDTH, TEX_HEIGHT),
    }
}

--#endregion

function module.init()
    texture = love.graphics.newImage("sprites.png")
end

---@param sprite love.Quad
---@param x number
---@param y number
function module.draw(sprite, x, y)
    love.graphics.draw(texture, sprite, x, y)
end

return module
