Fonts = Fonts or require "fonts"
UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Key = Modules.Key

--* Option Table
local function newOption(text, class)
    return {
        text = text,
        class = class
    }
end

--* Menu Class
local Menu = {}
Menu.__index = Menu

function Menu:new()
    local menu = {
        options = {
            newOption("Jogar", "Game"),
            newOption("Creditos", "Credits")
        },
        sel = 1,
        key = {
            down = Key:new(0.1, "s", "down"),
            up = Key:new(0.1, "w", "up")
        }
    }
    setmetatable(menu, self)

    function menu:update(dt)
        for _, i in pairs(self.key) do
            i:update(dt)
        end

        if love.keyboard.isDown("return") then
            return self.options[self.sel].class
        end

        if self.key.down:press() then
            -- sel = sel < #options ? sel + 1 : #options
            self.sel = self.sel < #self.options and self.sel + 1 or #self.options
        end
        if self.key.up:press() then
            -- sel = sel > 1 ? sel - 1 : 1
            self.sel = self.sel > 1 and self.sel - 1 or 1
        end
    end

    function menu:draw()
        love.graphics.setFont(Fonts.PressStart2P)
        local limit = UTIL.window.width - 100
        local text =
            '"Se você não souber usar, sua arma será sua maior inimiga, mas se souber usar, ela se tornará a sua maior arma"'
        text = text
        local y = 50
        y = y + UTIL.printw("Jogo da Arminha", Fonts.PressStart2P, 50, y, limit, "center", 5)
        y = y + 50
        y = y + UTIL.printw(text, Fonts.PressStart2P, 50, y, limit, "center", 3)
        y = y + 200
        local x = UTIL.window.width / 2 - 100
        for n, i in ipairs(self.options) do
            if n == self.sel then
                local w = Fonts.PressStart2P:getWidth("> ") * 3
                y = y + UTIL.printw("> " .. i.text, Fonts.PressStart2P, x - w, y, limit, "left", 3)
            else
                y = y + UTIL.printw(i.text, Fonts.PressStart2P, x, y, limit, "left", 3)
            end
        end
    end

    function menu:escape()
        love.event.quit()
    end

    return menu
end

return Menu
