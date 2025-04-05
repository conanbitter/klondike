_G.SCREEN_WIDTH = 350
_G.SCREEN_HEIGHT = 300

function love.conf(t)
    t.window.title = "Klondike"
    t.window.width = SCREEN_WIDTH
    t.window.height = SCREEN_HEIGHT
    t.window.resizable = true
    t.window.minwidth = SCREEN_WIDTH
    t.window.minheight = SCREEN_HEIGHT
    t.window.vsync = 1
    t.identity = "KlondikeCG"
end
