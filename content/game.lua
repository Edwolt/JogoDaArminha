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
        player = Game.Player:new(Vec:new(65, 65), nil, Vec:new(0, UTIL.values.gravity)),
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
        player_pos = player_pos
        self.scene:draw(Vec:new())
        self.bullets:draw()
        self.player:draw(self.player.pos)

        local col = self.scene:wallCollision(self.player:getCollider())
        if col then
            col:draw(UTIL.game.scale, 0, 255, 255)
        end
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

        local walk = 0
        if love.keyboard.isDown("a", "left") then
            walk = walk - 1
        end
        if love.keyboard.isDown("d", "right") then
            walk = walk + 1
        end
        self.player:walk(walk)

        self.scene:update(dt)
        self.player:update(dt)
        self.bullets:update(dt)

        local col = self.scene:wallCollision(self.player:getCollider())
        if col then
            local pcol = self.player:getCollider()
            local aux1 = col.p1 - pcol.p2
            local aux2 = col.p2 - pcol.p1
            local vec1 = Vec:new(aux1.x, 0)
            local vec2 = Vec:new(0, aux1.y)
            local vec3 = Vec:new(aux2.x, 0)
            local vec4 = Vec:new(0, aux2.y)

            local min = vec1
            local zerar = "x"
            if vec2:norm() < min:norm() then
                min = vec2
                zerar = "y"
            end
            if vec3:norm() < min:norm() then
                min = vec3
                zerar = "x"
            end
            if vec4:norm() < min:norm() then
                min = vec4
                zerar = "y"
            end
            self.player.pos = self.player.pos + min
            self.player.vel[zerar] = 0
            self:update(0)
        end
    end

    function game:escape()
        return "Menu"
    end

    return game
end

return Game
