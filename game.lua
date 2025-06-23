local Object = require "lib.classic"
local decks = require "decks"
local cards = require "cards"

---@class Game
---@field private decks Deck[]
---@field private flatDecks FlatDeck[]
---@field private homes HomeDeck[]
---@field private reserve ReserveDeck
---@field draw fun(self:Game)
---@field new_game fun(self:Game)
---@field debug number
---@overload fun():Game
local Game = Object:extend()

function Game:new()
    self.flatDecks = {
        decks.FlatDeck(2 + 50 * 0, 70),
        decks.FlatDeck(2 + 50 * 1, 70),
        decks.FlatDeck(2 + 50 * 2, 70),
        decks.FlatDeck(2 + 50 * 3, 70),
        decks.FlatDeck(2 + 50 * 4, 70),
        decks.FlatDeck(2 + 50 * 5, 70),
        decks.FlatDeck(2 + 50 * 6, 70)
    }
    self.homes = {
        decks.HomeDeck(152 + 50 * 0, 2, cards.Suit.Hearts),
        decks.HomeDeck(152 + 50 * 1, 2, cards.Suit.Diamonds),
        decks.HomeDeck(152 + 50 * 2, 2, cards.Suit.Clubs),
        decks.HomeDeck(152 + 50 * 3, 2, cards.Suit.Spades)
    }
    self.reserve = decks.ReserveDeck(2, 2)
    self.decks = { self.reserve }
    for _, flat in ipairs(self.flatDecks) do
        table.insert(self.decks, flat)
    end
    for _, home in ipairs(self.homes) do
        table.insert(self.decks, home)
    end
    self.debug = 0
end

function Game:draw()
    for _, deck in ipairs(self.decks) do
        deck:draw()
    end

    if self.debug == 1 then
        love.graphics.setColor(1, 0.2, 0.2)
        for _, deck in ipairs(self.decks) do
            local bounds = deck.boundsGrab
            if bounds then
                love.graphics.rectangle("line", bounds.x, bounds.y, bounds.w, bounds.h)
            end
        end
        love.graphics.setColor(1, 1, 1)
    end
end

---@param card_list Card[]
local function shuffle(card_list)
    for i = 1, #card_list - 1 do
        local r = love.math.random(i, #card_list)
        card_list[i], card_list[r] = card_list[r], card_list[i]
    end
end

function Game:new_game()
    for _, deck in ipairs(self.decks) do
        deck:clear()
    end

    local main_deck = {}
    for suit = 1, 4 do
        for rank = 1, 13 do
            table.insert(main_deck, cards.Card(suit, rank))
        end
    end
    shuffle(main_deck)

    for i, base_deck in ipairs(self.flatDecks) do
        for j = 1, i do
            table.insert(base_deck.cards, table.remove(main_deck))
        end
        base_deck.covered = #base_deck.cards - 1
    end

    self.reserve.cards = main_deck
end

return Game
