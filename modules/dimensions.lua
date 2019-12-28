Modules = Modules or {}
Modules.Vec = Modules.Vec or require "modules.vec"
local Vec = Modules.Vec

--* Dimensions class
local Dimensions = {}
Dimensions.__index = Dimensions

function Dimensions:new(width, height)
    local dimensions = {width = width, height = height}

    function dimensions:toVec()
        return Vec:new(self.width, self.height)
    end

    return dimensions
end

return Dimensions
