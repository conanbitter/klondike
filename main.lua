if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end


function love.load()
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.update(dt)

end

function love.draw()

end

function love.mousepressed(x, y, button, istouch, presses)

end

function love.mousemoved(x, y, dx, dy, istouch)

end

function love.mousereleased(x, y, button, istouch, presses)

end
