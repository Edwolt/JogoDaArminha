Fonts = Fonts or require "font"
--

--[[ Game Class ]] local Game = {
    Player = require "game.player"
}

function Game:new()
    local game = {}
    setmetatable(game, self)
    self.__index = self

    function game:draw()
    end

    function game:update(dt)
        return self
    end

    function game:escape()
    end

    return game
end
--

--[[ Menu Class ]] local Menu = {}
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
        love.graphics.printf(text, 10, 10, 100, "center", 0, 3, 3)
    end

    function menu:escape()
        love.event.quit()
    end

    return menu
end
--

--[[ Content Wrapper ]] local Content = {Menu, Game}
function Content:new()
    return Menu:new()
end

return Content
