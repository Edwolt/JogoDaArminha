Fonts = Fonts or require "font"
UTIL = UTIL or require "util"

--* Game Class
local Game = {
    Player = require "game.player"
}

function Game:new()
    local game = {
        player = Game.Player:new()
    }
    setmetatable(game, self)
    self.__index = self

    function game:draw()
        self.player:draw()
    end

    function game:update(dt)
        return self
    end

    function game:escape()
    end

    return game
end

--* Menu Class
local Menu = {}
function Menu:new()
    local menu = {}
    setmetatable(menu, self)
    self.__index = self

    function menu:update(dt)
        if love.keyboard.isDown("return") then
            return Game:new()
        end
        return self
    end

    function menu:draw()
        local text =
            '"Se você não souber usar, sua arma será sua maior inimiga, mas se souber usar, ela se tornará a sua maior arma"'
        love.graphics.setFont(Fonts.PressStart2P)
        love.graphics.printf(text, 10, 50, UTIL.window.width / 3 - 20, "center", 0, 3)

        local text = "Pressione <Enter> para jogar"
        love.graphics.setFont(Fonts.PressStart2P)
        love.graphics.printf(text, 10, UTIL.window.height - 100, UTIL.window.width / 2 - 20, "center", 0, 2)
    end

    function menu:escape()
        love.event.quit()
    end

    return menu
end

--* Credits Class

--* Content Wrapper
local Content = {Menu, Game}
function Content:new()
    return Menu:new()
end

return Content
