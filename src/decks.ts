import { Quad } from "love.graphics";
import { Card, FLAT_OFFSET } from "./cards";
import { Rect, Vec2 } from "./geometry";
import * as atlas from "./atlas";

abstract class Deck {
    pos: Vec2;
    cards: Card[];
    placeholder: Quad;
    boundsGrab?: Rect;
    boundsDrop?: Rect;
    boundsClick?: Rect;
    boundsDblClick?: Rect;

    abstract draw(animation?: any): void;

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

    constructor(x: number, y: number, placeholder: Quad) {
        super(x, y, placeholder);
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
                    card.draw(this.pos.x, this.pos.y + (i - 1) * FLAT_OFFSET);
                }
            });
        }
    }
}
