import { Quad } from "love.graphics";
import { Card, CARD_HEIGHT, CARD_WIDTH, FLAT_OFFSET, Suit } from "./cards";
import { Rect, Vec2 } from "./geometry";
import * as atlas from "./atlas";

export abstract class Deck {
    pos: Vec2;
    cards: Card[];
    placeholder: Quad;
    boundsGrab?: Rect;
    boundsDrop?: Rect;
    boundsClick?: Rect;
    boundsDblClick?: Rect;

    abstract draw(animation?: any): void;
    abstract updateBounds(): void;

    onGrab(point: Vec2) { }
    onDrop(hand: Card[]) { }
    onClick(point: Vec2) { }
    onDblClick(point: Vec2) { }

    constructor(x: number, y: number, placeholder: Quad) {
        this.pos = new Vec2(x, y);
        this.cards = [];
        this.placeholder = placeholder;
    }

    clear() {
        this.cards = [];
    }

    isEmpty(): boolean {
        return this.cards.length == 0;
    }
}

export class FlatDeck extends Deck {
    covered: number;

    constructor(x: number, y: number) {
        super(x, y, atlas.PLACEHOLDER_EMPTY);
        this.covered = 0;
    }

    draw(animation?: any): void {
        if (this.isEmpty()) {
            atlas.Draw(this.placeholder, this.pos.x, this.pos.y);
            return;
        }

        if (animation == null) {
            this.cards.forEach((card, i) => {
                if (i <= this.covered) {
                    atlas.Draw(atlas.CARD_BACK, this.pos.x, this.pos.y + i * FLAT_OFFSET);
                } else {
                    card.draw(this.pos.x, this.pos.y + i * FLAT_OFFSET);
                }
            });
        }
    }

    updateBounds(): void {
        if (this.isEmpty()) {
            this.boundsGrab = undefined;
            this.boundsDrop = undefined;
            this.boundsDblClick = undefined;
        }
        else {
            this.boundsGrab = new Rect(
                this.pos.x,
                this.pos.y + FLAT_OFFSET * (this.covered + 1),
                CARD_WIDTH,
                CARD_HEIGHT + FLAT_OFFSET * (this.cards.length - this.covered - 2)
            );
            this.boundsDblClick = new Rect(
                this.pos.x,
                this.pos.y + FLAT_OFFSET * (this.cards.length - 1),
                CARD_WIDTH,
                CARD_HEIGHT
            );
            this.boundsDrop = this.boundsDblClick;
        }
    }
}

export class HomeDeck extends Deck {
    suit: Suit;

    constructor(x: number, y: number, suit: Suit) {
        super(x, y, atlas.PLACEHOLDER_HOMES[suit]);
        this.suit = suit;
    }

    draw(animation?: any): void {
        if (this.isEmpty()) {
            atlas.Draw(this.placeholder, this.pos.x, this.pos.y);
        } else {
            this.cards[this.cards.length - 1].draw(this.pos.x, this.pos.y);
        }
    }

    updateBounds(): void {
        if (this.cards.length < 13) {
            this.boundsDrop = new Rect(this.pos.x, this.pos.y, CARD_WIDTH, CARD_HEIGHT);
        } else {
            this.boundsDrop = undefined;
        }
        if (this.isEmpty()) {
            this.boundsGrab = undefined;
        } else {
            this.boundsGrab = new Rect(this.pos.x, this.pos.y, CARD_WIDTH, CARD_HEIGHT);
        }
    }
}

const RESERVE_OFFSET = 52;

export class ReserveDeck extends Deck {
    pos2: Vec2;
    index: number;

    constructor(x: number, y: number) {
        super(x, y, atlas.PLACEHOLDER_REFRESH);
        this.index = -1;
        this.pos2 = new Vec2(x + RESERVE_OFFSET, y);
    }

    draw(animation?: any): void {
        if (this.isEmpty()) {
            atlas.Draw(this.placeholder, this.pos.x, this.pos.y);
            return
        }
        if (this.index < this.cards.length - 1) {
            atlas.Draw(atlas.CARD_BACK, this.pos.x, this.pos.y);
        } else {
            atlas.Draw(this.placeholder, this.pos.x, this.pos.y);
        }
        if (this.index >= 0) {
            this.cards[this.index].draw(this.pos.x + RESERVE_OFFSET, this.pos.y);
        }
    }

    updateBounds(): void {
        if (this.isEmpty() || this.index >= this.cards.length) {
            this.boundsClick = undefined;
        } else {
            this.boundsClick = new Rect(this.pos.x, this.pos.y, CARD_WIDTH, CARD_HEIGHT);
        }
        if (this.index > 0) {
            this.boundsGrab = new Rect(this.pos.x + RESERVE_OFFSET, this.pos.y, CARD_WIDTH, CARD_HEIGHT);
        }
    }
}