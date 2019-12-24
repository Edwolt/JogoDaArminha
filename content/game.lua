Modules = Modules or require "modules"
local Array = Modules.Array

--* Game Class
Contents = Contents or {}
Contents.Game = Contents.Game or {}
local Game = Contents.Game
Game.Player = Game.Player or require "game.player"
Game.Bullet = Game.Bullet or require "game.bullet"

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
        if love.keyboard.isDown("space") then
            self.bullets:add(self.player:shoot())
        end
    end

    function game:escape()
        return "Menu"
    end

    return game
end

return Game
