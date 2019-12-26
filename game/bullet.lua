UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Vec = Modules.Vec

--* Bullet Class
local Bullet = {}
Bullet.__index = Bullet

function Bullet:new(weapon, pos, vel)
    local bullet = {
        weapon = weapon,
        pos = pos or Vec:new(),
        vel = vel or Vec:new()
    }
    setmetatable(bullet, self)

    function Bullet:draw()
        local real_pos = self.pos * UTIL.game.scale

        if self.weapon == 1 then -- Fogo
            love.graphics.setColor(255, 0, 0)
        elseif self.weapon == 2 then -- Agua
            love.graphics.setColor(0, 0, 255)
        elseif self.weapon == 3 then -- Planta
            love.graphics.setColor(0, 255, 0)
        else
            love.graphics.setColor(255, 255, 255)
        end

        love.graphics.rectangle("fill", real_pos.x, real_pos.y, 2 * UTIL.game.scale, 2 * UTIL.game.scale)
    end

    function Bullet:update(dt)
        self.pos = self.pos + self.vel * dt
    end

    return bullet
end

return Bullet
