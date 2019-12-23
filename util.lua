local UTIL = {}

UTIL.window = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

UTIL.game = {}
UTIL.game.height = 1000
UTIL.game.scale = UTIL.window.height / UTIL.game.height
UTIL.game.width = UTIL.window.width / UTIL.game.scale

--* Wrapper Function para love.graphic.printf
function UTIL.printw(text, font, x, y, limit, align, scale)
    love.graphics.setFont(font)
    local font_width = font:getWidth(text)
    local font_height = font:getHeight()
    local text_height = scale * (font_width * scale / limit + 1) * font_height
    love.graphics.printf(text, x, y, limit / scale, align, 0, scale)
    return text_height
end

return UTIL
