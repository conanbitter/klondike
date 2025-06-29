import { Canvas, DisplayFlags } from "love.graphics";
import { SCREEN_HEIGHT, SCREEN_WIDTH } from "./conf";
import { Vec2 } from "./geometry";

const DEFAULT_FLAGS: DisplayFlags = {
    minwidth: SCREEN_WIDTH,
    minheight: SCREEN_HEIGHT,
    resizable: true,
    vsync: true,
}

export class Pixels {
    private canvas: Canvas;
    private scale: number = 1;
    private posX: number = 0;
    private posY: number = 0;
    private oldWidth: number = 0;
    private oldHeight: number = 0;

    constructor() {
        this.canvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT);
    }

    begin() {
        love.graphics.setCanvas(this.canvas);
    }

    finish() {
        love.graphics.setCanvas()
        love.graphics.draw(this.canvas, this.posX, this.posY, undefined, this.scale, this.scale);
    }

    setScale(newScale: number) {
        this.scale = newScale;
        this.posX = 0;
        this.posY = 0;
        this.oldWidth = SCREEN_WIDTH * this.scale;
        this.oldHeight = SCREEN_HEIGHT * this.scale;
        love.window.setMode(this.oldWidth, this.oldHeight, DEFAULT_FLAGS);
    }

    updateSize(width: number, height: number) {
        if (width == this.oldWidth && height == this.oldHeight) return;
        this.scale = math.floor(math.min(width / SCREEN_WIDTH, height / SCREEN_HEIGHT));
        this.posX = math.floor((width - SCREEN_WIDTH * this.scale) / 2);
        this.posY = math.floor((height - SCREEN_HEIGHT * this.scale) / 2);
        this.oldWidth = width;
        this.oldHeight = height;
    }

    posTo(x: number, y: number): Vec2 {
        return new Vec2(
            math.floor((x - this.posX) / this.scale),
            math.floor((y - this.posY) / this.scale));
    }
}