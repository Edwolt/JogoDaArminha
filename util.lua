Modules = Modules or require "modules"
local Dimensions = Modules.Dimensions

local UTIL = {}

UTIL.window = Dimensions:new(love.graphics.getWidth(), love.graphics.getHeight())

UTIL.game = {}
UTIL.game.height = 500
UTIL.game.scale = UTIL.window.height / UTIL.game.height
UTIL.game.width = UTIL.window.width / UTIL.game.scale

UTIL.values = {
    gravity = 1000
}

--* Wrapper Function para love.graphic.printf
function UTIL.printw(text, font, x, y, limit, align, scale)
    x = x or 0
    y = y or 0
    limit = limit or UTIL.window.width
    align = align or "left"
    scale = scale or 1

    if font then
        love.graphics.setFont(font)
    end

    local fontdim = Dimensions:new(font:getWidth(text), font:getHeight())

    local text_height = scale * (fontdim.width * scale / limit + 1) * fontdim.height
    love.graphics.printf(text, x, y, limit / scale, align, 0, scale)
    return text_height
end

return UTIL
