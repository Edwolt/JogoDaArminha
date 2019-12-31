UTIL = UTIL or require "util"
Fonts = Fonts or require "fonts"

Enums = Enums or require "enums"
local Elements = Enums.Elements

Modules = Modules or require "modules"
local List = Modules.List
local Vec = Modules.Vec
local Key = Modules.Key

local function collisionResolve(obj, col)
    if col == nil then
        return
    end

    local pcol = obj:getCollider()
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
    obj.pos = obj.pos + min
    return vnum
end

--* Game Class
Contents = Contents or {}
Contents.Game = Contents.Game or {}
local Game = Contents.Game
Game.Player = Game.Player or require "game.player"
Game.Enemy = Game.Enemy or require "game.enemy"
Game.Bullet = Game.Bullet or require "game.bullet"
Game.Scene = Game.Scene or require "game.scene"
Game.Block = Game.Block or require "game.block"

Game.__index = Game

function Game:new()
    local game = {
        player = Game.Player:new(Vec:new(65, 65), nil, Vec:new(0, UTIL.gravity)),
        enemys = List:new(Game.Enemy),
        bullets = List:new(Game.Bullet),
        key = {
            q = Key:new(0.2, "q"),
            e = Key:new(0.2, "e"),
            space = Key:new(0.25, "space")
        },
        dev = false, -- Draw the colliders
        score = 0
    }
    local s = Game.Scene:new("level")
    game.scene = s.scene
    game.player.pos = s.pos
    game.spawns = s.spawns
    setmetatable(game, self)

    function game:draw()
        -- love.graphics.clear(222, 176, 245)

        local player_pos = UTIL.game:toVec() / 2
        local sprite_center = self.player.tam:toVec() / 2
        player_pos = player_pos - sprite_center
        local scene_pos = self.player.pos - player_pos
        self.scene:draw(scene_pos)
        self.player:draw(player_pos)
        self.enemys:draw(scene_pos)
        self.bullets:draw(scene_pos)
        self.player:drawLife()

        if self.dev then
            self.scene:drawDev(scene_pos, {255, 255, 0}, {0, 255, 0})
            self.enemys:drawDev(scene_pos, {0, 255, 255})
            self.player:drawDev(player_pos, {0, 0, 255})
            self.bullets:drawDev(scene_pos, {255, 0, 255})
            UTIL.printw("FPS: " .. love.timer.getFPS(), Fonts.PressStart2P, 5, 5, UTIL.window.width - 100, "left", 1)
        end

        UTIL.printw("Score: " .. self.score, Fonts.PressStart2P, 50, 50, UTIL.window.width - 100, "left", 3)
    end

    function game:update(dt)
        for _, i in pairs(self.key) do
            i:update(dt)
        end

        -- Inputs
        if self.key.space:press() then
            self.bullets:add(self.player:shoot())
        end
        if self.key.q:press() then
            self.player.weapon = Elements.leftRotate(self.player.weapon)
        end
        if self.key.e:press() then
            self.player.weapon = Elements.rightRotate(self.player.weapon)
        end
        self.dev = love.keyboard.isDown("tab")

        local walk = 0
        if love.keyboard.isDown("a", "left") then
            walk = walk - 1
        end
        if love.keyboard.isDown("d", "right") then
            walk = walk + 1
        end

        for _, i in self.spawns:ipairs() do
            local enemy = i:spawn()
            if enemy then
                self.enemys:add(enemy)
            end
        end
        self.player:walk(walk)

        -- Updates
        self.scene:update(dt)
        self.spawns:update(dt)
        self.enemys:update(dt)
        self.player:update(dt)
        self.bullets:update(dt)

        -- Collisions
        local i, col = self.scene:floorCollision(self.player:getCollider())
        if col then
            if i.element == Elements.WATER and i.hot >= 1 then
                self.player.life = self.player.life - i.hot * dt
                if self.player.life < 0 then
                    return "Menu"
                end
            end
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
                local vnum = collisionResolve(self.player, col)
                if vnum == 1 or vnum == 3 then
                    self.player.vel.x = 0
                elseif vnum == 4 and self.player.vel.y <= 0 then
                    self.player.vel.y = 0
                elseif vnum == 2 and self.player.vel.y >= 0 then
                    self.player.vel.y = 0
                end
                _, col = self.scene:wallCollision(self.player:getCollider())
            end
        end

        for _, enemy in self.enemys:ipairs() do
            local ecol = enemy:getCollider()

            i, col = self.scene:floorCollision(ecol)
            if col then
                if i.element == Elements.WATER and i.hot >= 1 then
                    enemy.life = enemy.life - i.hot * dt
                end
            end

            i, col = self.scene:wallCollision(ecol)
            if col then
                local vnum = collisionResolve(enemy, col)
                if (vnum == 1 or vnum == 3) and (not i:getFloor()) then
                    enemy:virar()
                elseif vnum == 4 and enemy.vel.y <= 0 then
                    enemy.vel.y = 0
                elseif vnum == 2 and enemy.vel.y >= 0 then
                    enemy.vel.y = 0
                end
                i, col = self.scene:wallCollision(ecol)
            end
        end

        -- Bullet
        for k, i in self.bullets:ipairs() do
            local col = i:getCollider()
            if self.scene:wallCollision(col) then
                self.bullets:remove(k)
            end
            for _, enemy in self.enemys:ipairs() do
                if enemy:getCollider():collision(col) then
                    enemy.life = enemy.life - 5
                    self.bullets:remove(k)
                end
            end
            self.scene:changeBlocks(i.element, i:getArea())
        end

        -- Remove died enemys
        for k, i in self.enemys:ipairs() do
            if i.life <= 0 then
                self.score = self.score + 1
                self.enemys:remove(k)
            end
        end
    end

    function game:escape()
        return "Menu"
    end

    return game
end

return Game
