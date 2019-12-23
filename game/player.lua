Modules = Modules or require "modules"
local Vec = Modules.Vec

--* Player Class
local Player = {}
Player.__index = Player
function Player:new()
    local player = {
        weapon = 1,
        pos = Vec:new(),
        vel = Vec:new(),
        acel = Vec:new()
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
    end

    function player:update(dt)
        self.vel = self.vel + (self.acel * dt)
        self.pos = self.pos + (self.pos * dt)
    end

    return player
end

return Player
