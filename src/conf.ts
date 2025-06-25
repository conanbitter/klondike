export const SCREEN_WIDTH = 350;
export const SCREEN_HEIGHT = 300;

love.conf = (t) => {
    t.window.title = "Klondike";
    t.window.width = SCREEN_WIDTH;
    t.window.height = SCREEN_HEIGHT;
    t.window.resizable = true;
    t.window.minwidth = SCREEN_WIDTH;
    t.window.minheight = SCREEN_HEIGHT;
    t.window.vsync = 1;
    t.identity = "KlondikeCG";
};