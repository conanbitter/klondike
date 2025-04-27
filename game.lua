local Object = require "lib.classic"
local decks = require "decks"
local cards = require "cards"

---@class Game
---@field private decks Deck[]
---@field private flatDecks FlatDeck[]
---@field private homes HomeDeck[]
---@field private reserve ReserveDeck
---@field draw fun(self:Game)
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
end

function Game:draw()
    for _, deck in ipairs(self.decks) do
        deck:draw()
    end
end

return Game
