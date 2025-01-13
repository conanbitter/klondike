local Object = require "lib.classic"
local vector = require "vector"

---@enum ButtonState
local ButtonState = {
    Normal = 1,
    Hovered = 2,
    Pressed = 3,
}

---@enum SwitchState
local SwitchState = {
    Off = 1,
    On = 2,
    HoveredOff = 3,
    HoveredOn = 4,
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
---@overload fun(x:number, y:number, width:number, height:number, faces:Vector[]):Button
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

---@class Switch: UIElement
---@field others Switch[]
---@field enabled boolean
---@overload fun(x:number, y:number, width:number, height:number, faces:Vector[]):Switch
local Switch = UIElement:extend()

function Switch:new(x, y, width, height, faces)
    Switch.super.new(self, x, y, width, height, faces)
    self.others = {}
    self.enabled = false
    self.state = SwitchState.Off
end

function Switch:on_mouse_move(x, y, pressed)
    if self:is_inside(x, y) then
        if self.enabled then
            self.state = SwitchState.HoveredOn
        else
            self.state = SwitchState.HoveredOff
        end
    else
        if self.enabled then
            self.state = SwitchState.On
        else
            self.state = SwitchState.Off
        end
    end
end

function Switch:on_mouse_down(x, y)
    if self:is_inside(x, y) and not self.enabled then
        for _, sw in pairs(self.others) do
            sw.enabled = false
            sw.state = SwitchState.Off
        end
        self.enabled = true
        self.state = SwitchState.HoveredOn
        print "Switch"
    end
end

local module = {}

function module.init()
    ui_texture = love.graphics.newImage("ui.png")
    local group = {
        Switch(100, 100, 31, 26, {
            vector.new_vector(202, 1),
            vector.new_vector(202, 28),
            vector.new_vector(202, 55),
            vector.new_vector(202, 82),
        }),
        Switch(150, 100, 31, 26, {
            vector.new_vector(234, 1),
            vector.new_vector(234, 28),
            vector.new_vector(234, 55),
            vector.new_vector(234, 82),
        })
    }
    for _, sw in pairs(group) do
        sw.others = group
    end
    return {
        game = {
            Button(107, 2, 31, 31, {
                vector.new_vector(170, 1),
                vector.new_vector(170, 33),
                vector.new_vector(170, 65),
            }),
            group[1],
            group[2],
        }
    }
end

return module
