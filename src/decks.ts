import { Quad } from "love.graphics";
import { Card, CARD_HEIGHT, CARD_WIDTH, FLAT_OFFSET, Suit } from "./cards";
import { Rect, Vec2 } from "./geometry";
import * as atlas from "./atlas";
import { Animation, HandAnim } from "./animations";
import { Drawable, Game } from "./game";

export abstract class Deck implements Drawable {
    pos: Vec2;
    cards: Card[];
    placeholder: Quad;
    boundsGrab?: Rect;
    boundsDrop?: Rect;
    boundsClick?: Rect;
    boundsDblClick?: Rect;
    game: Game;

    abstract drawAnim(animation?: Animation): void;
    abstract updateBounds(): void;

    onGrab(point: Vec2) { }
    onDrop(hand: Card[]) { }
    onClick(point: Vec2) { }
    onDblClick(point: Vec2) { }

    constructor(x: number, y: number, placeholder: Quad, parent: Game) {
        this.pos = new Vec2(x, y);
        this.cards = [];
        this.placeholder = placeholder;
        this.game = parent;
        parent.addDrawable(this, 0);
    }

    draw(): void {
        const animation = this.game.animator.getAnimation(this);
        this.drawAnim(animation);
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

    constructor(x: number, y: number, parent: Game) {
        super(x, y, atlas.PLACEHOLDER_EMPTY, parent);
        this.covered = 0;
    }

    drawAnim(animation?: Animation): void {
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
        } else if (animation instanceof HandAnim) {
            animation.cards.draw(animation.pos.x, animation.pos.y);
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

    onGrab(point: Vec2): void {
        this.game.animator.setAnimation(this, new HandAnim(this, 2));
    }
}

export class HomeDeck extends Deck {
    suit: Suit;

    constructor(x: number, y: number, suit: Suit, parent: Game) {
        super(x, y, atlas.PLACEHOLDER_HOMES[suit], parent);
        this.suit = suit;
    }

    drawAnim(animation?: Animation): void {
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

    constructor(x: number, y: number, parent: Game) {
        super(x, y, atlas.PLACEHOLDER_REFRESH, parent);
        this.index = -1;
        this.pos2 = new Vec2(x + RESERVE_OFFSET, y);
    }

    drawAnim(animation?: any): void {
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