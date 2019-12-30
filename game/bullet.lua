UTIL = UTIL or require "util"

Modules = Modules or require "modules"
local Vec = Modules.Vec
local Collider = Modules.Collider
local Dim = Modules.Dim

--* Bullet Class
local Bullet = {
    tam = Dim:new(6, 4),
    area = Dim:new(96, 96)
}
Bullet.__index = Bullet

function Bullet:new(weapon, pos, vel)
    local bullet = {
        element = weapon,
        pos = pos or Vec:new(),
        vel = vel or Vec:new()
    }
    setmetatable(bullet, self)

    function bullet:draw(pos)
        local real_pos = (self.pos - pos) * UTIL.game.scale

        if self.element == 1 then -- Fogo
            love.graphics.setColor(255, 0, 0)
        elseif self.element == 2 then -- Agua
            love.graphics.setColor(0, 0, 255)
        elseif self.element == 3 then -- Planta
            love.graphics.setColor(0, 255, 0)
        else
            love.graphics.setColor(255, 255, 255)
        end
        love.graphics.rectangle(
            "fill",
            real_pos.x,
            real_pos.y,
            self.tam.width * UTIL.game.scale,
            self.tam.height * UTIL.game.scale
        )

        love.graphics.setColor(255, 255, 255)
    end

    function bullet:drawDev(pos, color)
        local area = self:getArea()
        local aux1 = area.p1 - pos
        local aux2 = area.p2 - pos
        Collider:new(aux1, aux2):draw(color)
    end

    function bullet:update(dt)
        self.pos = self.pos + self.vel * dt
    end

    function bullet:getCollider()
        return Collider:new(self.pos, self.pos + self.tam:toVec())
    end

    function bullet:getArea()
        local p1 = self.pos + self.tam:toVec() / 2 - self.area:toVec() / 2
        return Collider:new(p1, p1 + self.area:toVec())
    end

    return bullet
end

return Bullet
