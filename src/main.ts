import * as atlas from "./atlas";
import { Pixels } from "./pixels";

let pixels: Pixels;

love.load = () => {
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255);
    love.graphics.setDefaultFilter("nearest", "nearest");
    pixels = new Pixels();
    pixels.setScale(3);
    atlas.InitAtlas();
}

love.draw = () => {
    pixels.begin();
    love.graphics.clear();
    atlas.Draw(atlas.CARDS[0][2], 100, 100)
    pixels.finish();
};

love.resize = (width, height) => {
    pixels.updateSize(width, height);
}