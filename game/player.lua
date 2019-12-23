local Player = {}

function Player:new()
    local player = {
        weapon = 1
    }
    setmetatable(player, self)
    self.__index = self

    function player:changeWeapon(weapon)
        -- 1: Fogo
        -- 2: Agua
        -- 3: Planta
        if 1 <= weapon and weapon <= 3 then
            player.weapon = weapon
        end
    end

    return player
end

return Player
