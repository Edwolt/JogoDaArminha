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
            q = Key:new(0.2, "q"),
            e = Key:new(0.2, "e"),
            space = Key:new(0.25, "space")
        }
    }
    setmetatable(game, self)

    function game:draw()
        love.graphics.clear(222, 176, 245)

        local player_pos = UTIL.game:toVec() / 2
        local sprite_center = self.player.tam:toVec() / 2
        player_pos = player_pos - sprite_center
        local scene_pos = self.player.pos - player_pos
        self.scene:draw(scene_pos)
        self.bullets:draw(scene_pos)
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
                self.player.weapon = 1
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

        local _, col = self.scene:floorCollision(self.player:getCollider())
        if col then
            if love.keyboard.isDown("w", "up") then
                self.player:jump()
            end
        else
            if not love.keyboard.isDown("w", "up") then
                self.player:stopJump()
            end
        end

        _, col = self.scene:wallCollision(self.player:getCollider())
        while col do
            if col then
                self:collisionResolve(self.player, col)
                _, col = self.scene:wallCollision(self.player:getCollider())
            end
        end

        for k, i in ipairs(self.bullets.vet) do
            local col = i:getCollider()
            if self.scene:wallCollision(col) then
                self.bullets:remove(k)
            end
        end
    end

    function game:collisionResolve(player, col)
        if col == nil then
            return
        end

        local pcol = player:getCollider()
        local aux1 = col.p1 - pcol.p2
        local aux2 = col.p2 - pcol.p1
        local vec1 = Vec:new(aux1.x, 0)
        local vec2 = Vec:new(0, aux1.y)
        local vec3 = Vec:new(aux2.x, 0)
        local vec4 = Vec:new(0, aux2.y)

        local min = vec1
        local vnum = 1
        if vec2:norm() < min:norm() then
            min = vec2
            vnum = 2
        end
        if vec3:norm() < min:norm() then
            min = vec3
            vnum = 3
        end
        if vec4:norm() < min:norm() then
            min = vec4
            vnum = 4
        end
        player.pos = player.pos + min

        if vnum == 1 or vnum == 3 then
            player.vel.x = 0
        elseif vnum == 4 and player.vel.y <= 0 then
            player.vel.y = 0
        elseif vnum == 2 and player.vel.y >= 0 then
            player.vel.y = 0
        end
    end

    function game:escape()
        return "Menu"
    end

    return game
end

return Game
