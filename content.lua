local Game = {
    Player = require "game.player"
}

-- Game Class
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

-- Menu Class
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
    end

    function menu:escape()
        love.event.quit()
    end

    return menu
end

-- Content (Wrapper)
local Content = {Menu, Game}
function Content:new()
    return Menu:new()
end

return Content
