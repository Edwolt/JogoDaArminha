UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Vec = Modules.Vec

--* Bullet Class
local Bullet = {}
Bullet.__index = Bullet

function Bullet:new(weapon, pos, vel)
    local bullet = {
        type = weapon,
        pos = pos or Vec:new(),
        vel = vel or Vec:new()
    }
    setmetatable(bullet, self)

    function Bullet:draw()
        local realPos = self.pos * UTIL.game.scale
        
        if self.type == 1 then
        love.graphics.setColor(255,0,0)
        elseif self.type == 2 then
            love.graphics.setColor(0,0,255)
        elseif self.type == 3 then
            love.graphics.setColor(0,255,0)
        else
            love.graphics.setColor(255,255,255)
        end

        love.graphics.rectangle("fill", realPos.x, realPos.y, 2 * UTIL.game.scale, 2 * UTIL.game.scale)
    end

    function Bullet:update(dt)
        self.pos = self.pos + self.vel * dt
    end

    return bullet
end

return Bullet
