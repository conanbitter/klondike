import { CARD_WIDTH, CardSlice } from "./cards";
import { Deck } from "./decks";
import { Drawable, Game } from "./game";
import { Vec2 } from "./geometry";

export class Animator {
    animations: LuaMap<Deck, Animation>;
    game: Game;

    constructor(game: Game) {
        this.animations = new LuaMap<Deck, Animation>();
        this.game = game;
    }

    setAnimation(deck: Deck, anim: Animation) {
        this.animations.set(deck, anim);
        this.game.addDrawable(anim, anim.layer);
    }

    getAnimation(deck: Deck): Animation | undefined {
        return this.animations.get(deck);
    }

    clearAnimation(deck: Deck) {
        const animation = this.animations.get(deck);
        if (animation) {
            this.game.removeDrawable(animation);
            this.animations.delete(deck);
        }
    }

    update(game: Game) {
        for (const [deck, anim] of this.animations) {
            anim.update(game);
        }
    }
}

export abstract class Animation implements Drawable {
    parent: Deck;
    layer: number;

    abstract update(game: Game): void;
    abstract draw(): void;

    constructor(parent: Deck, layer: number) {
        this.parent = parent;
        this.layer = layer;
    }
}

export class HandAnim extends Animation {
    cards: CardSlice;
    pos: Vec2;

    constructor(parent: Deck, count: number, initPos: Vec2) {
        super(parent, 2);
        this.cards = CardSlice.fromTop(parent.cards, count);
        this.pos = initPos;
    }

    update(game: Game): void {
        this.pos.x = game.mousePos.x - CARD_WIDTH / 2;
        this.pos.y = game.mousePos.y;
    }

    draw(): void {
        this.cards.draw(this.pos.x, this.pos.y);
    }
}