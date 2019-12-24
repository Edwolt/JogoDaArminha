Modules = Modules or require "modules"
local Vec = Modules.Vec
local Array = Modules.Array

--* Game Class
local Game = {
    Player = require "game.player",
    Bullet = require "game.bullet"
}

Game.__index = Game

function Game:new()
    local game = {
        player = Game.Player:new(),
        bullets = Array:new(Game.Bullet)
    }
    setmetatable(game, self)

    function game:draw()
        self.player:draw()
        self.bullets:draw()
    end

    function game:update(dt)
        self.player:update(dt)
        self.bullets:update(dt)
    end

    function game:escape()
        return "Menu"
    end

    return game
end

return Game
