---@type love.Image
local sprites

function love.load()
    sprites = love.graphics.newImage("sprites.png")
    love.graphics.setBackgroundColor(62 / 255, 140 / 255, 54 / 255)
end

function love.draw()
    love.graphics.print("Hello World", 400, 300)
    love.graphics.draw(sprites, 20, 20)
end
