Modules = Modules or require "modules"
local Vec = Modules.Vec

local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(pos, vel, acc)
    local enemy = {
        pos = pos or Vec:new(),
        vel = vel or Vec:new(),
        acc = acc or Vec:new(),
        life = 10
    }
    setmetatable(enemy, self)

    function enemy:update(dt)
        self.vel = self.vel + self.acc * dt
        self.pos = self.vel + self.pos * dt
    end

    return enemy
end
return Enemy
