UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Vec = Modules.Vec
local Collider = Modules.Collider

Contents = Contents or {}
Contents.Game = Contents.Game or {}
Contents.Game.Bullet = Contents.Game.Bullet or require "game.bullet"
local Bullet = Contents.Game.Bullet

--* Player Class
local Player = {
    sprite = love.graphics.newImage("placeholder/player.png")
}
Player.sprite:setFilter("nearest", "nearest")
Player.__index = Player

function Player:new(pos)
    local player = {
        weapon = 1,
        pos = pos or Vec:new(0, 0),
        vel = Vec:new(0, 0),
        acc = Vec:new(0, 450)
    }
    setmetatable(player, self)

    function player:changeWeapon(weapon)
        -- 1: Fogo
        -- 2: Agua
        -- 3: Planta
        if 1 <= weapon and weapon <= 3 then
            player.weapon = weapon
        end
    end

    function player:draw(pos) -- TODO
        local real_pos = pos / UTIL.game.scale
        love.graphics.draw(Player.sprite, real_pos.x, real_pos.y, 0, UTIL.game.scale)
    end

    function player:center()
        local center = Vec:new(UTIL.game.width / 2, UTIL.game.height / 2)
        center.x = center.x - Player.sprite:getWidth() / 2
        center.y = center.y - Player.sprite:getHeight() / 2
        return center
    end

    function player:update(dt)
        self.pos = self.pos + self.vel * dt
        self.vel = self.vel + self.acc * dt
    end

    function player:shoot()
        return Bullet:new(self.weapon, self.pos, Vec:new(450, 0))
    end

    function player:stop()
        self.vel = Vec:new(0, 0)
    end

    function player:getCollider()
        local p2 = Vec:new(Player.sprite:getWidth(), Player.sprite:getHeight())
        p2 = self.pos + p2
        return Collider:new(self.pos, p2)
    end

    function player:drawCollider(pos)
        love.graphics.setColor(0, 0, 255)
        local col = self:getCollider()
        local aux1 = col.p1 - pos
        local aux2 = col.p2 - col.p1
        aux1 = aux1 * UTIL.game.scale
        aux2 = aux2 * UTIL.game.scale
        love.graphics.rectangle("line", aux1.x, aux1.y, aux2.x, aux2.y)

        love.graphics.setColor(255, 255, 255)
    end

    return player
end

return Player
