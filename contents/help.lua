Fonts = Fonts or require "fonts"
UTIL = UTIL or require "util"

--* Line Table
local function newLine(text, scale)
    return {
        text = text or "",
        scale = scale or 3
    }
end

--* Help Class
local Help = {
    lines = {
        newLine("Instruções", 7)
    },
    vel_y = 250
}
Help.__index = Help

function Help:new()
    local help = {
        pos_y = 50
    }
    setmetatable(help, self)

    function help:draw()
        local y = self.pos_y
        local limit = (UTIL.window.width - 100)
        for _, i in ipairs(self.lines) do
            y = y + UTIL.printw(i.text, Fonts.PressStart2P, 50, y, limit, "center", i.scale)
        end
    end

    function help:update(dt)
        if love.keyboard.isDown("s", "down") then
            self.pos_y = self.pos_y + dt * self.vel_y
        end
        if love.keyboard.isDown("w", "up") then
            self.pos_y = self.pos_y - dt * self.vel_y
        end
    end

    function help:escape()
        return "Menu"
    end

    return help
end

return Help
