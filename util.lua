local UTIL = {}

UTIL.window = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

UTIL.game = {}
UTIL.game.height = 500
UTIL.game.scale = UTIL.window.height / UTIL.game.height
UTIL.game.width = UTIL.window.width / UTIL.game.scale

UTIL.values = {
    gravity = 450
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

    local font_width = font:getWidth(text)
    local font_height = font:getHeight()
    local text_height = scale * (font_width * scale / limit + 1) * font_height
    love.graphics.printf(text, x, y, limit / scale, align, 0, scale)
    return text_height
end

return UTIL
