Content = Content or {}
Content.Game = Content.Game or require "content.game"
local Game = Content.Game

Fonts = Fonts or require "font"
UTIL = UTIL or require "util"

--* Option Class
local Option = {}
Option.__index = Option

function Option:new(opt, class, param)
    local option = {
        opt = opt,
        param = param
    }

    function option:func()
        if self.param then
            return class:new(table.unpack(self.param))
        else
            return class:new()
        end
    end

    return option
end

--* Menu Class
local Menu = {}
Menu.__index = Menu

function Menu:new()
    local menu = {
        options = {
            Option:new("Jogar", Game),
            Option:new("Credits", Credits, {Menu})
        },
        sel = 1,
        wait = 0
    }
    setmetatable(menu, self)

    function menu:update(dt)
        if love.keyboard.isDown("return") then
            return self.options[self.sel]:func()
        end

        if self.wait <= 0 then
            if love.keyboard.isDown("s", "down") then
                -- sel = sel < #options ? sel + 1 : #options
                self.sel = self.sel < #self.options and self.sel + 1 or #self.options
                self.wait = 0.1
            elseif love.keyboard.isDown("w", "up") then
                -- sel = sel > 1 ? sel - 1 : 1
                self.sel = self.sel > 1 and self.sel - 1 or 1
                self.wait = 0.1
            end
        end
        self.wait = self.wait - dt

        return self
    end

    function menu:draw()
        love.graphics.setFont(Fonts.PressStart2P)
        local limit = (UTIL.window.width - 100)
        local text =
            '"Se você não souber usar, sua arma será sua maior inimiga, mas se souber usar, ela se tornará a sua maior arma"'
        text = text
        local y = 50
        y = y + self:printw(text, Fonts.PressStart2P, 50, y, limit, "center", 3)
        y = y + 200
        local x = UTIL.window.width / 2 - 100
        for n, i in ipairs(self.options) do
            if n == self.sel then
                local w = Fonts.PressStart2P:getWidth("> ")
                y = y + self:printw("> " .. i.opt, Fonts.PressStart2P, x - w, y, limit, "left", 3)
            else
                y = y + self:printw(i.opt, Fonts.PressStart2P, x, y, limit, "left", 3)
            end
        end
    end

    function menu:printw(text, font, x, y, limit, align, scale)
        love.graphics.setFont(font)
        local font_width = font:getWidth(text)
        local font_height = font:getHeight()
        local text_height = scale * (font_width * scale / limit + 1) * font_height
        love.graphics.printf(text, x, y, limit / scale, align, 0, scale)
        return text_height
    end

    function menu:escape()
        love.event.quit()
    end

    return menu
end

return Menu
