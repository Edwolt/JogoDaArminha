UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Vec = Modules.Vec
local Collider = Modules.Collider

--* Bullet Class
local Bullet = {
    width = 6,
    height = 4
}
Bullet.__index = Bullet

function Bullet:new(weapon, pos, vel)
    local bullet = {
        weapon = weapon,
        pos = pos or Vec:new(),
        vel = vel or Vec:new()
    }
    setmetatable(bullet, self)

    function bullet:draw(pos)
        local real_pos = (self.pos - pos) * UTIL.game.scale

        if self.weapon == 1 then -- Fogo
            love.graphics.setColor(255, 0, 0)
        elseif self.weapon == 2 then -- Agua
            love.graphics.setColor(0, 0, 255)
        elseif self.weapon == 3 then -- Planta
            love.graphics.setColor(0, 255, 0)
        else
            love.graphics.setColor(255, 255, 255)
        end
        love.graphics.rectangle(
            "fill",
            real_pos.x,
            real_pos.y,
            Bullet.width * UTIL.game.scale,
            Bullet.height * UTIL.game.scale
        )

        love.graphics.setColor(255, 255, 255)
    end

    function bullet:update(dt)
        self.pos = self.pos + self.vel * dt
    end

    function bullet:getCollider()
        return Collider:new(self.pos, self.pos + Vec:new(Bullet.width, Bullet.height))
    end

    return bullet
end

return Bullet
