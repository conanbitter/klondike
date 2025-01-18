local Object = require "lib.classic"
local Vector = require "vector"
local settings = require "settings"

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

---@type fun(cmd:string, value:any)?
local _callback

---@class UIElement: Object
---@field x number
---@field y number
---@field width number
---@field height number
---@field state number
---@field faces love.Quad[]
---@field command string
---@field value any
---@field is_inside fun(self:UIElement, x:number, y:number):boolean
---@field draw fun(self:UIElement)
---@field on_mouse_move fun(self:UIElement, x:number, y:number, pressed:boolean)
---@field on_mouse_down fun(self:UIElement, x:number, y:number):boolean
---@field on_mouse_up fun(self:UIElement, x:number, y:number)
---@field activate fun(self:UIElement)
---@overload fun(x:number, y:number, width:number, height:number, faces:Vector[], command:string, value:any):UIElement
local UIElement = Object:extend()

---@param x number
---@param y number
---@param width number
---@param height number
---@param faces Vector[]
---@param command string
---@param value any
function UIElement:new(x, y, width, height, faces, command, value)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.faces = {}
    for _, face in ipairs(faces) do
        table.insert(self.faces, love.graphics.newQuad(face.x, face.y, width, height, ui_texture))
    end
    self.state = 1
    self.command = command
    self.value = value
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

function UIElement:activate()
    if _callback then _callback(self.command, self.value) end
end

---@class Button: UIElement
---@field was_pressed boolean
---@field state ButtonState
---@overload fun(x:number, y:number, width:number, height:number, faces:Vector[], command:string):Button
local Button = UIElement:extend()

function Button:new(x, y, width, height, faces, command)
    Button.super.new(self, x, y, width, height, faces, command)
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
        self.state = ButtonState.Normal
        if self.was_pressed then
            self:activate()
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
        return true
    end
    return false
end

---@class Switch: UIElement
---@field others Switch[]
---@field enabled boolean
---@field enable fun(self:Switch)
---@overload fun(x:number, y:number, width:number, height:number, faces:Vector[], command:string, value:any):Switch
local Switch = UIElement:extend()

function Switch:new(x, y, width, height, faces, command, value)
    Switch.super.new(self, x, y, width, height, faces, command, value)
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
    if self:is_inside(x, y) then
        if not self.enabled then
            for _, sw in pairs(self.others) do
                sw.enabled = false
                sw.state = SwitchState.Off
            end
            self.enabled = true
            self.state = SwitchState.HoveredOn
            self:activate()
        end
        return true
    end
    return false
end

function Switch:enable()
    self.enabled = true
    self.state = SwitchState.On
end

local module = {}

---@type { [string]:UIElement[] }
local ui_layouts

---@param callback fun(cmd:string, value:any)
function module.init(callback)
    ui_texture = love.graphics.newImage("ui.png")

    local scale_group = {
        Switch(145, 100, 31, 26, {
            Vector(1, 109),
            Vector(1, 136),
            Vector(1, 163),
            Vector(1, 190),
        }, "scale", 1),
        Switch(177, 100, 31, 26, {
            Vector(33, 109),
            Vector(33, 136),
            Vector(33, 163),
            Vector(33, 190),
        }, "scale", 2),
        Switch(209, 100, 31, 26, {
            Vector(65, 109),
            Vector(65, 136),
            Vector(65, 163),
            Vector(65, 190),
        }, "scale", 3),
        Switch(241, 100, 31, 26, {
            Vector(97, 109),
            Vector(97, 136),
            Vector(97, 163),
            Vector(97, 190),
        }, "scale", 4),
    }
    for _, sw in pairs(scale_group) do
        sw.others = scale_group
    end
    scale_group[settings.scale]:enable()

    local lang_group = {
        Switch(128, 250, 43, 29, {
            Vector(129, 97),
            Vector(129, 127),
            Vector(129, 157),
            Vector(129, 187),
        }, "lang", "en"),
        Switch(179, 250, 43, 29, {
            Vector(173, 97),
            Vector(173, 127),
            Vector(173, 157),
            Vector(173, 187),
        }, "lang", "ru"),
    }
    for _, sw in pairs(lang_group) do
        sw.others = lang_group
    end
    if settings.language == "en" then
        lang_group[1]:enable()
    elseif settings.language == "ru" then
        lang_group[2]:enable()
    end

    local close_button = Button(312, 2, 36, 36, {
        Vector(249, 106),
        Vector(249, 143),
        Vector(249, 180),
    }, "close")

    ui_layouts = {
        game = {
            Button(108, 2, 31, 31, {
                Vector(217, 121),
                Vector(217, 153),
                Vector(217, 185),
            }, "menu"),
        },
        menu_en = {
            Button(136, 70, 78, 26, {
                Vector(1, 1),
                Vector(1, 28),
                Vector(1, 55),
            }, "new"),
            UIElement(78, 100, 43, 26, { Vector(1, 82) }, ""),
            scale_group[1],
            scale_group[2],
            scale_group[3],
            scale_group[4],
            Button(153, 130, 42, 26, {
                Vector(80, 1),
                Vector(80, 28),
                Vector(80, 55),
            }, "quit"),
            lang_group[1],
            lang_group[2],
            close_button
        },
        menu_ru = {
            Button(130, 70, 89, 26, {
                Vector(123, 1),
                Vector(123, 28),
                Vector(123, 55),
            }, "new"),
            UIElement(78, 100, 65, 26, { Vector(45, 82) }, ""),
            scale_group[1],
            scale_group[2],
            scale_group[3],
            scale_group[4],
            Button(145, 130, 57, 26, {
                Vector(213, 1),
                Vector(213, 28),
                Vector(213, 55),
            }, "quit"),
            lang_group[1],
            lang_group[2],
            close_button
        }
    }
    _callback = callback
end

---@param layout string
function module.draw(layout)
    for _, elt in ipairs(ui_layouts[layout]) do
        elt:draw()
    end
end

---@param layout string
---@param x number
---@param y number
---@param pressed boolean
function module.mouse_move(layout, x, y, pressed)
    for _, elt in ipairs(ui_layouts[layout]) do
        elt:on_mouse_move(x, y, pressed)
    end
end

---@param layout string
---@param x number
---@param y number
---@return boolean
function module.mouse_down(layout, x, y)
    for _, elt in ipairs(ui_layouts[layout]) do
        if elt:on_mouse_down(x, y) then return true end
    end
    return false
end

---@param layout string
---@param x number
---@param y number
function module.mouse_up(layout, x, y)
    for _, elt in ipairs(ui_layouts[layout]) do
        elt:on_mouse_up(x, y)
    end
end

return module
