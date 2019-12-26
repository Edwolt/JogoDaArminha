UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Vec = Modules.Vec

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

    function player:draw() -- TODO
        local real_center = self:center() * UTIL.game.scale

        love.graphics.draw(Player.sprite, real_center.x, real_center.y, 0, UTIL.game.scale)
    end

    function player:center()
        local center = Vec:new(UTIL.game.width / 2, UTIL.game.height / 2)
        center.x = center.x - Player.sprite:getWidth() / 2
        center.y = center.y - Player.sprite:getHeight() / 2
        return center
    end

    function player:update(dt)
        self.vel = self.vel + self.acc * dt
        self.pos = self.pos + self.vel * dt
    end

    function player:shoot()
        return Bullet:new(self.weapon, self.pos, Vec:new(450, 0))
    end

    return player
end

return Player
