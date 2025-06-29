import { Game } from "./game";
import { Pixels } from "./pixels";

const GRAB_DELAY = 0.2;
const DBL_DELAY = 0.3;
const MOVE_TOLERANCE = 2;

enum MouseState {
    Normal = 0,
    MaybeGrab,
    Dragging,
}

export class AdvancedMouse {
    private sinceMouseDown: number;
    private sinceLastClick?: number;
    private lastX: number;
    private lastY: number;
    private lastClickX: number;
    private lastClickY: number;
    private state: MouseState;
    private game: Game;
    private scaler: Pixels;

    constructor(game: Game, scaler: Pixels) {
        this.sinceLastClick = undefined;
        this.sinceMouseDown = 0;
        this.lastX = 0;
        this.lastY = 0;
        this.lastClickX = 0;
        this.lastClickY = 0;
        this.state = MouseState.Normal;
        this.game = game;
        this.scaler = scaler;
    }

    private waitExpaired() {
        if (this.state == MouseState.MaybeGrab) {
            this.state = MouseState.Dragging;
            this.game.onGrab(this.scaler.posTo(this.lastX, this.lastY));
        }
    }

    doMouseDown(x: number, y: number) {
        if (this.state == MouseState.Normal) {
            this.state = MouseState.MaybeGrab;
            this.lastX = x;
            this.lastY = y;
            this.sinceMouseDown = love.timer.getTime();
        }
    }

    doMouseUp(x: number, y: number) {
        if (this.state == MouseState.MaybeGrab) {
            this.state = MouseState.Normal;
            if (this.sinceLastClick &&
                love.timer.getTime() - this.sinceLastClick < DBL_DELAY &&
                math.abs(x - this.lastClickX) < MOVE_TOLERANCE &&
                math.abs(y - this.lastClickY) < MOVE_TOLERANCE) {
                this.sinceLastClick = undefined;
                this.game.onDblClick(this.scaler.posTo(x, y));
            } else {
                this.sinceLastClick = love.timer.getTime();
                this.lastClickX = x;
                this.lastClickY = y;
            }
            this.game.onClick(this.scaler.posTo(x, y));
        } else if (this.state == MouseState.Dragging) {
            this.state = MouseState.Normal;
            this.game.onDrop(this.scaler.posTo(x, y));
        }
    }

    doMouseMove(x: number, y: number) {
        if (this.state == MouseState.Dragging) {
            this.game.onDrag(this.scaler.posTo(x, y));
        } else if (math.abs(x - this.lastX) > MOVE_TOLERANCE || math.abs(y - this.lastY) > MOVE_TOLERANCE) {
            this.waitExpaired();
        }
    }

    doUpdate() {
        if (love.timer.getTime() - this.sinceMouseDown > GRAB_DELAY) {
            this.waitExpaired();
        }
    }
}