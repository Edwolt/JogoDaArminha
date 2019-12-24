Contents = Contents or {}
Contents.Game = Contents.Game or {}
Contents.Game.Bullet = Contents.Game.Bullet or require "game.bullet"
local Bullet = Contents.Game.Bullet

UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Vec = Modules.Vec

--* Player Class
local Player = {
    sprite = love.graphics.newImage("placeholder/player.png")
}
Player.sprite:setFilter("nearest", "nearest")
Player.__index = Player

function Player:new()
    local player = {
        weapon = 1,
        pos = Vec:new(200, 0),
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
        local realPos = self.pos * UTIL.game.scale
        love.graphics.draw(Player.sprite, realPos.x, realPos.y, 0, UTIL.game.scale)
    end

    function player:update(dt)
        self.vel = self.vel + self.acc * dt
        self.pos = self.pos + self.vel * dt
    end

    function player:shoot()
        return Bullet:new(self.weapon, self.pos, Vec:new(200, 0))
    end

    return player
end

return Player
