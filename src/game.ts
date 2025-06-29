import { Card, Suit } from "./cards";
import { Deck, FlatDeck, HomeDeck, ReserveDeck } from "./decks";
import { Vec2 } from "./geometry";

function shuffle(cardList: Card[]) {
    for (const i of $range(0, cardList.length - 2)) {
        const r = love.math.random(i, cardList.length - 1);
        cardList[i], cardList[r] = cardList[r], cardList[i];
    }
}

export class Game {
    decks: Deck[];
    flatDecks: FlatDeck[];
    homes: HomeDeck[];
    reserve: ReserveDeck;
    mousePos: Vec2;
    debugBounds: number;

    constructor() {
        this.flatDecks = [
            new FlatDeck(2 + 50 * 0, 70),
            new FlatDeck(2 + 50 * 1, 70),
            new FlatDeck(2 + 50 * 2, 70),
            new FlatDeck(2 + 50 * 3, 70),
            new FlatDeck(2 + 50 * 4, 70),
            new FlatDeck(2 + 50 * 5, 70),
            new FlatDeck(2 + 50 * 6, 70)
        ]
        this.homes = [
            new HomeDeck(152 + 50 * 0, 2, Suit.Hearts),
            new HomeDeck(152 + 50 * 1, 2, Suit.Diamonds),
            new HomeDeck(152 + 50 * 2, 2, Suit.Clubs),
            new HomeDeck(152 + 50 * 3, 2, Suit.Spades)
        ]
        this.reserve = new ReserveDeck(2, 2);
        this.decks = [this.reserve, ...this.flatDecks, ...this.homes];
        this.debugBounds = 0;
        this.mousePos = new Vec2(0, 0);
    }

    draw() {
        for (const deck of this.decks) {
            deck.draw();
        }

        switch (this.debugBounds) {
            case 1:
                love.graphics.setColor(1, 0.2, 0.2);
                for (const deck of this.decks) {
                    const bounds = deck.boundsGrab;
                    if (bounds) love.graphics.rectangle("line", bounds.x, bounds.y, bounds.w, bounds.h);
                }
                love.graphics.setColor(1, 1, 1);
                break;

            case 2:
                love.graphics.setColor(1, 0.2, 0.2);
                for (const deck of this.decks) {
                    const bounds = deck.boundsDrop;
                    if (bounds) love.graphics.rectangle("line", bounds.x, bounds.y, bounds.w, bounds.h);
                }
                love.graphics.setColor(1, 1, 1);
                break;

            case 3:
                love.graphics.setColor(1, 0.2, 0.2);
                for (const deck of this.decks) {
                    const bounds = deck.boundsClick;
                    if (bounds) love.graphics.rectangle("line", bounds.x, bounds.y, bounds.w, bounds.h);
                }
                love.graphics.setColor(1, 1, 1);
                break;

            case 4:
                love.graphics.setColor(1, 0.2, 0.2);
                for (const deck of this.decks) {
                    const bounds = deck.boundsDblClick;
                    if (bounds) love.graphics.rectangle("line", bounds.x, bounds.y, bounds.w, bounds.h);
                }
                love.graphics.setColor(1, 1, 1);
                break;
        }
    }

    newGame() {
        for (const deck of this.homes) {
            deck.clear();
        }

        const mainDeck: Card[] = [];
        for (const suit of $range(0, 3)) {
            for (const rank of $range(0, 12)) {
                mainDeck.push(new Card(suit, rank));
            }
        }
        shuffle(mainDeck);

        this.flatDecks.forEach((deck, i) => {
            deck.cards = mainDeck.splice(0, i + 1);
            deck.covered = deck.cards.length - 2;
        });

        this.reserve.cards = mainDeck;

        for (const deck of this.decks) {
            deck.updateBounds();
        }
    }
}