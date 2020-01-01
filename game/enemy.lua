UTIL = UTIL or require "util"
Fonts = Fonts or require "fonts"

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
    },
    damage = {
        WEAK = -3.5,
        NORMAL = 1,
        STRONG = 3.5
    },
    LIFE_LIMIT = 25
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
        local pos = self.pos - pos
        pos.y = pos.y - 5
        pos = pos * UTIL.game.scale
        UTIL.printw(
            tostring(self.life),
            Fonts.PressStart2P,
            pos.x - 20,
            pos.y,
            self.sprite[self.element]:getWidth() * UTIL.game.scale + 40,
            "center"
        )
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

    function enemy:bulletDamage(element)
        if self.element == Elements.DIRT then -- Dirt <- All
            self.life = self.life - self.damage.STRONG
        elseif self.element == Elements.FIRE then
            if element == Elements.FIRE then -- Fire <- Fire
                self.life = self.life - self.damage.NORMAL
            elseif element == Elements.WATER then -- Fire <- Water
                self.life = self.life - self.damage.STRONG
            elseif element == Elements.PLANT then -- Fire <- Plant
                self.life = self.life - self.damage.WEAK
            end
        elseif self.element == Elements.WATER then
            if element == Elements.FIRE then -- Water <- Fire
                self.life = self.life - self.damage.WEAK
            elseif element == Elements.WATER then -- Water <- Water
                self.life = self.life - self.damage.NORMAL
            elseif element == Elements.PLANT then -- Water <- Plant
                self.life = self.life - self.damage.STRONG
            end
        elseif self.element == Elements.PLANT then
            if element == Elements.FIRE then -- Plant <- Fire
                self.life = self.life - self.damage.STRONG
            elseif element == Elements.WATER then -- Plant <- Water
                self.life = self.life - self.damage.WEAK
            elseif element == Elements.PLANT then -- Plant <- Plant
                self.life = self.life - self.damage.NORMAL
            end
        end

        if self.life > self.LIFE_LIMIT then
            self.life = self.LIFE_LIMIT
        end
    end

    return enemy
end

local Fire = {}
local Water = {}
local Plant = {}

return Enemy
