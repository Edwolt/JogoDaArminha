local UTIL = {}

UTIL.window = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

UTIL.game = {}
UTIL.game.height = 1000
UTIL.game.scale = UTIL.window.height / UTIL.game.height
UTIL.game.width = UTIL.window.width / UTIL.game.scale

return UTIL
