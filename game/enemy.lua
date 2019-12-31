UTIL = UTIL or require "util"

Modules = Modules or require "modules"
local Vec = Modules.Vec
local Collider = Modules.Collider
local Dim = Modules.Dim

Enums = Enums or require "enums"
local Elements = Enums.Elements

--* Enemy Class
local Enemy = {
    sprite = {
        [Elements.DIRT] = love.graphics.newImage("images/enemy.png"),
        [Elements.FIRE] = love.graphics.newImage("images/enemyf.png"),
        [Elements.WATER] = love.graphics.newImage("images/enemyw.png"),
        [Elements.PLANT] = love.graphics.newImage("images/enemyp.png")
    }
}
Enemy.__index = Enemy

for _, i in ipairs(Enemy.sprite) do
    i:setFilter("nearest", "nearest")
end

function Enemy:new(el, pos, vel, acc)
    local enemy = {
        pos = pos or Vec:new(),
        vel = vel or Vec:new(),
        acc = acc or Vec:new(),
        life = 10,
        element = el or Elements.DIRT
    }
    setmetatable(enemy, self)

    function enemy:draw(pos)
        local real_pos = (self.pos - pos) * UTIL.game.scale
        love.graphics.draw(self.sprite[self.element], real_pos.x, real_pos.y, 0, UTIL.game.scale, UTIL.game.scale)
    end

    function enemy:drawDev(pos, color)
        local col = self:getCollider()
        local aux1 = col.p1 - pos
        local aux2 = col.p2 - pos
        Collider:new(aux1, aux2):draw(color)
    end

    function enemy:getCollider()
        local sprite = self.sprite[self.element]
        local p2 = Dim:extract(sprite):toVec()
        p2 = self.pos + p2
        return Collider:new(self.pos, p2)
    end

    function enemy:update(dt)
        self.vel = self.vel + self.acc * dt
        self.pos = self.pos + self.vel * dt
    end

    function enemy:virar()
        self.vel.x = -self.vel.x
    end

    return enemy
end

local Fire = {}
local Water = {}
local Plant = {}

return Enemy
