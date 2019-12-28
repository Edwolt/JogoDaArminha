Modules = Modules or {}
Modules.Vec = Modules.Vec or require "modules.vec"
local Vec = Modules.Vec

--* Dimensions class
local Dim = {}
Dim.__index = Dim

function Dim:new(width, height)
    local dim = {width = width, height = height}

    function dim:toVec()
        return Vec:new(self.width, self.height)
    end

    return dim
end

return Dim
