import { CARD_WIDTH, CardSlice } from "./cards";
import { Deck } from "./decks";
import { Game } from "./game";
import { Vec2 } from "./geometry";

export class Animator {
    animations: LuaMap<Deck, Animation>;

    constructor() {
        this.animations = new LuaMap<Deck, Animation>();
    }

    setAnimation(deck: Deck, anim: Animation) {
        this.animations.set(deck, anim);
    }

    getAnimation(deck: Deck): Animation | undefined {
        return this.animations.get(deck);
    }

    clearAnimation(deck: Deck) {
        this.animations.delete(deck);
    }

    update(game: Game) {
        for (const [deck, anim] of this.animations) {
            anim.update(game);
        }
    }
}

export abstract class Animation {
    parent: Deck;

    abstract update(game: Game): void;

    constructor(parent: Deck) {
        this.parent = parent;
    }
}

export class HandAnim extends Animation {
    cards: CardSlice;
    pos: Vec2;

    constructor(parent: Deck, count: number) {
        super(parent);
        this.cards = CardSlice.fromTop(parent.cards, count);
        this.pos = new Vec2(0, 0);
    }

    update(game: Game): void {
        this.pos.x = game.mousePos.x - CARD_WIDTH / 2;
        this.pos.y = game.mousePos.y;
    }
}