Modules = Modules or require "modules"
local Array = Modules.Array
local Vec = Modules.Vec
local Key = Modules.Key

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
            q = Key:new(0.05, "q"),
            e = Key:new(0.05, "e"),
            space = Key:new(0.01, "space")
        }
    }
    setmetatable(game, self)

    function game:draw()
        local player_pos = Vec:new(UTIL.game.width / 2, UTIL.game.height / 2)
        local sprite_center = Vec:new(Game.Player.sprite:getWidth() / 2, Game.Player.sprite:getHeight() / 2)
        player_pos = player_pos - 
        self.scene:draw(Vec:new())
        self.bullets:draw()
        self.player:draw(player_pos)
    end

    function game:update(dt)
        for _, i in pairs(self.key) do
            i:update(dt)
        end

        if self.key.space:press() then
            self.bullets:add(self.player:shoot())
        end
        if self.key.q:press() then
            self.player.weapon = self.player.weapon - 1
            if self.player.weapon < 1 then
                self.player.weapon = 3
            end
        end
        if self.key.e:press() then
            self.player.weapon = self.player.weapon + 1
            if self.player.weapon > 3 then
                self.player.weapon = 0
            end
        end
        local walk = self.player:update(dt)
        self.bullets:update(dt)
    end

    function game:escape()
        return "Menu"
    end

    return game
end

return Game
