Modules = Modules or require "modules"
local Array = Modules.Array
local Vec = Modules.Vec

--* Game Class
Contents = Contents or {}
Contents.Game = Contents.Game or {}
local Game = Contents.Game
Game.Player = Game.Player or require "game.player"
Game.Bullet = Game.Bullet or require "game.bullet"
Game.Scene = Game.Scene or require "game.scene"

Game.scene = Game.Scene:new("level")

Game.__index = Game

function Game:new()
    local game = {
        player = Game.Player:new(Vec:new(32 * 30, 32 * 10), nil, Vec:new(0, UTIL.values.gravity)),
        bullets = Array:new(Game.Bullet),
        scene = Game.scene
    }
    setmetatable(game, self)

    function game:draw()
        self.bullets:draw()
        self.scene:draw(self.player.pos)
        self.player:draw(self.player.pos)
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
