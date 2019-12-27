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
    sprite = love.graphics.newImage("placeholder/player.png"),
    WALK = 100
}
Player.sprite:setFilter("nearest", "nearest")
Player.__index = Player

function Player:new(pos, vel, acc)
    local player = {
        weapon = 1, -- 1: Fogo; 2: Agua; 3: Planta
        pos = pos or Vec:new(),
        vel = vel or Vec:new(),
        acc = acc or Vec:new(),
        shoot_vel = 450,
        dir = 1
    }
    setmetatable(player, self)

    function player:draw(pos)
        local real_pos
        if self.dir == 1 then
            real_pos = pos * UTIL.game.scale
            love.graphics.draw(Player.sprite, real_pos.x, real_pos.y, 0, UTIL.game.scale, UTIL.game.scale)
        else
            pos.x = pos.x + Player.sprite:getWidth()
            real_pos = (pos) * UTIL.game.scale
            love.graphics.draw(Player.sprite, real_pos.x, real_pos.y, 0, -UTIL.game.scale, UTIL.game.scale)
        end
    end

    function player:update(dt)
        self.pos = self.pos + self.vel * dt
        self.vel = self.vel + self.acc * dt
    end

    function player:shoot()
        local pos = self.pos:clone()
        if self.dir == 1 then
            pos.x = pos.x + Player.sprite:getWidth()
        end
        return Bullet:new(self.weapon, self.pos, Vec:new(self.dir * self.shoot_vel, 0))
    end

    function player:walk(dir)
        self.vel.x = dir * Player.WALK
        -- self.dir = dir ~= 0 ? dir : self.dir
        self.dir = dir ~= 0 and dir or self.dir
    end

    function player:getCollider()
        local p2 = Vec:new(Player.sprite:getWidth(), Player.sprite:getHeight())
        p2 = self.pos + p2
        return Collider:new(self.pos, p2)
    end

    return player
end

return Player
