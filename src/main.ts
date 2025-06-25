import { Vec2 } from "./geometry";
import * as atlas from "./atlas";

love.load = () => {
    atlas.InitAtlas();
}

love.draw = () => {
    atlas.Draw(atlas.CARDS[0][2], 100, 100)
};