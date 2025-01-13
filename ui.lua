local Object = require "lib.classic"
local vector = require "vector"

---@enum ButtonState
ButtonState = {
    Normal = 1,
    Hovered = 2,
    Pressed = 3,
}

---@type love.Image
local ui_texture

---@class UIElement: Object
---@field x number
---@field y number
---@field width number
---@field height number
---@field state number
---@field faces love.Quad[]
---@field is_inside fun(self:UIElement, x:number, y:number):boolean
---@field draw fun(self:UIElement)
---@field on_mouse_move fun(self:UIElement, x:number, y:number, pressed:boolean)
---@field on_mouse_down fun(self:UIElement, x:number, y:number):boolean
---@field on_mouse_up fun(self:UIElement, x:number, y:number)
---@overload fun(x:number, y:number, width:number, height:number, faces:Vector[]):UIElement
local UIElement = Object:extend()

---@param x number
---@param y number
---@param width number
---@param height number
---@param faces Vector[]
function UIElement:new(x, y, width, height, faces)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.faces = {}
    for _, face in ipairs(faces) do
        table.insert(self.faces, love.graphics.newQuad(face.x, face.y, width, height, ui_texture))
    end
    self.state = 1
end

function UIElement:is_inside(x, y)
    return x >= self.x and y >= self.y and x < self.x + self.width and y < self.y + self.height
end

function UIElement:draw()
    love.graphics.draw(ui_texture, self.faces[self.state], self.x, self.y)
end

function UIElement:on_mouse_move(x, y, pressed) end

function UIElement:on_mouse_down(x, y)
    return self:is_inside(x, y)
end

function UIElement:on_mouse_up(x, y) end

---@class Button: UIElement
---@field was_pressed boolean
---@field state ButtonState
local Button = UIElement:extend()

function Button:new(x, y, width, height, faces)
    Button.super.new(self, x, y, width, height, faces)
    self.was_pressed = false
end

function Button:on_mouse_move(x, y, pressed)
    if self:is_inside(x, y) then
        if pressed then
            if self.was_pressed then
                self.state = ButtonState.Pressed
            else
                self.state = ButtonState.Normal
            end
        else
            self.state = ButtonState.Hovered
        end
    else
        if self.was_pressed then
            self.state = ButtonState.Hovered
        else
            self.state = ButtonState.Normal
        end
    end
    --print(self.state)
end

function Button:on_mouse_up(x, y)
    if self:is_inside(x, y) then
        self.state = ButtonState.Hovered
        if self.was_pressed then
            print "Button"
        end
    else
        self.state = ButtonState.Normal
    end
    self.was_pressed = false
end

function Button:on_mouse_down(x, y)
    if self:is_inside(x, y) then
        self.was_pressed = true
        self.state = ButtonState.Pressed
    end
end

local module = {}

function module.init()
    ui_texture = love.graphics.newImage("ui.png")
    return {
        game = {
            Button(107, 2, 31, 31, {
                vector.new_vector(170, 1),
                vector.new_vector(170, 33),
                vector.new_vector(170, 65),
            })
        }
    }
end

return module
