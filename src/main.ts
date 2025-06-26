if (os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1") {
    require("lldebugger").start();
}

import * as atlas from "./atlas";
import { Card, CardSlice, PrintCardArray, PrintCardSlice, Suit } from "./cards";
import { Pixels } from "./pixels";

let pixels: Pixels;

love.load = () => {
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255);
    love.graphics.setDefaultFilter("nearest", "nearest");
    pixels = new Pixels();
    pixels.setScale(3);
    atlas.InitAtlas();

    const tb1 = [
        new Card(1, 0),
        new Card(1, 1),
        new Card(1, 2),
        new Card(1, 3),
        new Card(1, 4),
        new Card(1, 5),
    ]
    print("tb1");
    PrintCardArray(tb1);
    print("bottom");
    PrintCardSlice(CardSlice.fromBottom(tb1, 3));
    print("top");
    PrintCardSlice(CardSlice.fromTop(tb1, 3));
    const tb2 = [
        new Card(2, 0),
        new Card(2, 1),
        new Card(2, 2),
        new Card(2, 3),
        new Card(2, 4),
        new Card(2, 5),
    ];
    print("tb2");
    PrintCardArray(tb2);
    const sl = new CardSlice(tb1, 2, 3);
    print("slice");
    PrintCardSlice(sl);

    sl.move(tb2, 4);
    print("tb1");
    PrintCardArray(tb1);
    print("tb2");
    PrintCardArray(tb2);
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