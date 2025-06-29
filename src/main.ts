if (os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1") {
    require("lldebugger").start();
}

import * as atlas from "./atlas";
import { Game } from "./game";
import { Pixels } from "./pixels";

let pixels: Pixels;
let game: Game;

love.load = () => {
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255);
    love.graphics.setDefaultFilter("nearest", "nearest");
    pixels = new Pixels();
    pixels.setScale(3);
    atlas.InitAtlas();
    game = new Game();
    game.newGame();
}

love.draw = () => {
    pixels.begin();
    love.graphics.clear();
    game.draw();
    pixels.finish();
};

love.resize = (width, height) => {
    pixels.updateSize(width, height);
};

love.keypressed = (key, scancode, isrepeat) => {
    switch (scancode) {
        case "1":
            print("[DEBUG] Show Grab rects");
            game.debugBounds = 1;
            break;
        case "2":
            print("[DEBUG] Show Drop rects");
            game.debugBounds = 2;
            break;
        case "3":
            print("[DEBUG] Show Click rects");
            game.debugBounds = 3;
            break;
        case "4":
            print("[DEBUG] Show DblClick rects");
            game.debugBounds = 4;
            break;
        case "0":
            print("[DEBUG] Hide rects");
            game.debugBounds = 0;
            break;

        default:
            break;
    }
};