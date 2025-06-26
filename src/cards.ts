import * as atlas from "./atlas";

export const CARD_WIDTH = 42;
export const CARD_HEIGHT = 60;
export const FLAT_OFFSET = 14;

export enum Suit {
    Hearts = 0,
    Diamonds,
    Clubs,
    Spades
}

export enum Rank {
    Ace = 0,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Ten,
    Jack,
    Queen,
    King
}

export class Card {
    suit: Suit;
    rank: Rank;

    constructor(suit: Suit, rank: Rank) {
        this.suit = suit;
        this.rank = rank;
    }

    draw(x: number, y: number) {
        atlas.Draw(atlas.CARDS[this.suit][this.rank], x, y);
    }
}

export class CardSlice {
    source: Card[];
    index: number;
    count: number;

    constructor(source: Card[], index: number, count: number) {
        this.source = source;
        this.index = index;
        this.count = count;
    }

    move(to: Card[], toIndex?: number) {
        const index = toIndex || to.length;
        //let startIndex = index;
        to.splice(index, 0, ...this.source.splice(this.index, this.count));
        this.source = to;
        this.index = index;
    }

    draw(x: number, y: number) {
        let ypos = y;
        for (const i of $range(this.index, this.index + this.count - 1)) {
            this.source[i].draw(x, ypos);
            ypos += FLAT_OFFSET;
        }
    }

    static fromBottom(source: Card[], count?: number): CardSlice {
        const fcount = count || 1;
        return new CardSlice(source, 0, fcount);
    }

    static fromTop(source: Card[], count?: number): CardSlice {
        const fcount = count || 1;
        return new CardSlice(source, source.length - fcount, fcount);
    }
}

export function PrintCard(card: Card) {
    print("Card ", card.rank, card.suit)
}

export function PrintCardArray(cards: Card[]) {
    for (const card of cards) {
        PrintCard(card);
    }
}

export function PrintCardSlice(slice: CardSlice) {
    for (const i of $range(slice.index, slice.index + slice.count - 1)) {
        PrintCard(slice.source[i]);
    }
}