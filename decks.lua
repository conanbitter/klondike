local module = {}

local cards = require "cards"

---@class Card
---@field suit Suit
---@field rank Rank

---@param suit Suit
---@param rank Rank
---@return Card
local function new_card(suit, rank)
    return {
        suit = suit,
        rank = rank
    }
end

function module.init()
    local main_deck = {}

    for suit = 1, 4 do
        for rank = 1, 13 do
            table.insert(main_deck, new_card(suit, rank))
        end
    end

    return main_deck[1]
end

return module
