--* Game Class
local Game = {
    Player = require "game.player"
}
Game.__index = Game

function Game:new()
    local game = {
        player = Game.Player:new()
    }
    setmetatable(game, self)

    function game:draw()
        self.player:draw()
    end

    function game:update(dt)
    end

    function game:escape()
        return "Menu"
    end

    return game
end

return Game
