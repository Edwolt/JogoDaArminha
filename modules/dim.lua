Modules = Modules or {}
Modules.Vec = Modules.Vec or require "modules.vec"
local Vec = Modules.Vec

--* Dim Class
-- Dimensions
local Dim = {}
Dim.__index = Dim

function Dim:new(width, height)
    local dim = {width = width or 0, height = height or 0}
    setmetatable(dim, self)

    function dim:toVec()
        return Vec:new(self.width, self.height)
    end

    return dim
end

function Dim:extract(obj)
    return Dim:new(obj:getWidth(), obj:getHeight())
end

return Dim
