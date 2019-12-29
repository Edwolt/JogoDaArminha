UTIL = UTIL or require "util"

Enums = Enums or require "enums"
local Elements = Enums.Elements

Modules = Modules or require "modules"
local Vec = Modules.Vec
local Collider = Modules.Collider
local Dim = Modules.Dim

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

local player_sprite = love.graphics.newImage("images/player.png")
Player.tam = Dim:extract(player_sprite)
player_sprite = nil

Player.__index = Player

function Player:new(pos, vel, acc)
    local player = {
        weapon = Elements.FIRE, -- 1:Fire; 2:Water; 3:Plant
        pos = pos or Vec:new(),
        vel = vel or Vec:new(),
        acc = acc or Vec:new(),
        shoot_vel = 450,
        dir = 1,
        onJump = false,
        life = 30 -- TODO
    }
    setmetatable(player, self)

    function player:draw(pos)
        local real_pos
        if self.dir == 1 then
            real_pos = pos * UTIL.game.scale
            love.graphics.draw(self.sprite[self.weapon], real_pos.x, real_pos.y, 0, UTIL.game.scale, UTIL.game.scale)
        else
            pos.x = pos.x + self.tam.width
            real_pos = (pos) * UTIL.game.scale
            love.graphics.draw(self.sprite[self.weapon], real_pos.x, real_pos.y, 0, -UTIL.game.scale, UTIL.game.scale)
        end
    end

    function player:lifeDraw()
        local pos = Vec:new(UTIL.window.width / 2, UTIL.window.height - 50)
        local bar = Dim:new(self.life * 10, 20)
        pos = pos - bar:toVec() / 2
        local border = 1

        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("fill", pos.x - border, pos.y - border, bar.width + 2 * border, bar.height + 2 * border)
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle("fill", pos.x, pos.y, bar.width, bar.height)
        love.graphics.setColor(255, 255, 255)
    end

    function player:update(dt)
        self.vel = self.vel + self.acc * dt
        self.pos = self.pos + self.vel * dt
    end

    function player:shoot()
        local pos = self.pos:clone()
        if self.dir == 1 then
            pos.x = pos.x + self.tam.width
        end
        return Bullet:new(self.weapon, pos, Vec:new(self.dir * self.shoot_vel, 0))
    end

    function player:walk(dir)
        self.vel.x = dir * self.WALK

        -- self.dir = dir ~= 0 ? dir : self.dir
        self.dir = dir ~= 0 and dir or self.dir
    end

    function player:jump()
        self.vel.y = -self.JUMP
        self.onJump = true
    end

    function player:stopJump()
        if self.onJump then
            self.vel.y = self.vel.y / 2
            self.onJump = false
        end
    end

    function player:getCollider()
        local p2 = self.tam:toVec()
        p2 = self.pos + p2
        return Collider:new(self.pos, p2)
    end

    return player
end

return Player
