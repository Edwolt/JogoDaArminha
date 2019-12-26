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
        scene = Game.scene,
        key = {
            q = 0,
            e = 0,
            space = 0
        }
    }
    setmetatable(game, self)

    function game:draw()
        self.bullets:draw()
        self.scene:draw(self.player.pos)
        self.player:draw(self.player.pos)
    end

    function game:update(dt)
        if love.keyboard.isDown("space") and self.key.space <= 0 then
            self.bullets:add(self.player:shoot())
        end
        if love.keyboard.isDown("q") and self.key.q <= 0 then
            self.player.weapon = self.player.weapon - 1
            if self.player.weapon < 1 then
                self.player.weapon = 3
            end
            self.key.q = 1
        end
        if love.keyboard.isDown("e") and self.key.q <= 0 then
            self.player.weapon = self.player.weapon + 1
            if self.player.weapon <= 0 then
                self.player.weapon = 3
            end
            self.key.e = 1
        end
        for k, i in pairs(self.key) do
            if i > 0 then
                self.key[k] = self.key[k] - dt
            end
        end

        self.player:update(dt)
        self.bullets:update(dt)
    end

    function game:escape()
        return "Menu"
    end

    return game
end

return Game
