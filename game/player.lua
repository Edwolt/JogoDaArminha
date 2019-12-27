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
    sprite = {
        love.graphics.newImage("images/fire.png"),
        love.graphics.newImage("images/water.png"),
        love.graphics.newImage("images/plant.png")
    },
    WALK = 200,
    JUMP = 530
}
for _, i in ipairs(Player.sprite) do
    i:setFilter("nearest", "nearest")
end
Player.width = Player.sprite[2]:getWidth()
Player.height = Player.sprite[2]:getHeight()

Player.__index = Player

function Player:new(pos, vel, acc)
    local player = {
        weapon = 1, -- 1:Fire; 2:Water; 3:Plant
        pos = pos or Vec:new(),
        vel = vel or Vec:new(),
        acc = acc or Vec:new(),
        shoot_vel = 450,
        dir = 1,
        onJump = false
    }
    setmetatable(player, self)

    function player:draw(pos)
        local real_pos
        if self.dir == 1 then
            real_pos = pos * UTIL.game.scale
            love.graphics.draw(Player.sprite[self.weapon], real_pos.x, real_pos.y, 0, UTIL.game.scale, UTIL.game.scale)
        else
            pos.x = pos.x + Player.width
            real_pos = (pos) * UTIL.game.scale
            love.graphics.draw(Player.sprite[self.weapon], real_pos.x, real_pos.y, 0, -UTIL.game.scale, UTIL.game.scale)
        end
    end

    function player:update(dt)
        self.vel = self.vel + self.acc * dt
        self.pos = self.pos + self.vel * dt
    end

    function player:shoot()
        local pos = self.pos:clone()
        if self.dir == 1 then
            pos.x = pos.x + Player.width
        end
        return Bullet:new(self.weapon, pos, Vec:new(self.dir * self.shoot_vel, 0))
    end

    function player:walk(dir)
        self.vel.x = dir * Player.WALK

        -- self.dir = dir ~= 0 ? dir : self.dir
        self.dir = dir ~= 0 and dir or self.dir
    end

    function player:jump()
        self.vel.y = -Player.JUMP
        self.onJump = true
    end

    function player:stopJump()
        if self.onJump then
            self.vel.y = self.vel.y / 2
            self.onJump = false
        end
    end

    function player:getCollider()
        local p2 = Vec:new(Player.width, Player.height)
        p2 = self.pos + p2
        return Collider:new(self.pos, p2)
    end

    return player
end

return Player
