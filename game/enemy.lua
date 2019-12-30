Modules = Modules or require "modules"
local Vec = Modules.Vec

--* Enemy Class
local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(el, pos, vel, acc)
    local enemy = {
        pos = pos or Vec:new(),
        vel = vel or Vec:new(),
        acc = acc or Vec:new(),
        life = 10,
        element = el
    }
    setmetatable(enemy, self)

    function enemy:update(dt)
        self.vel = self.vel + self.acc * dt
        self.pos = self.vel + self.pos * dt
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
