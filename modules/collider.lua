Modules = Modules or {}
Modules.Vec = Modules.Vec or require "modules.vec"
local Vec = Modules.Vec

--* Collider Class
local Collider = {}
Collider.__index = Collider

-- (Vec, Vec)
-- (int, int, int, int)
function Collider:new(x1, y1, x2, y2)
    local vec1, vec2
    if x2 == nil then
        vec1 = x1
        vec2 = y1
    else
        vec1 = Vec:new(x1, y1)
        vec2 = Vec:new(x2, y2)
    end

    -- fixing vecs
    if vec1.x > vec2.x then
        vec1.x, vec2.x = vec2.x, vec1.x
    end
    if vec1.y > vec2.y then
        vec1.y, vec2.y = vec2.y, vec1.y
    end

    local collider = {
        p1 = vec1, -- top left
        p2 = vec2 -- botton right
    }
    setmetatable(collider, self)

    function collider:collision(other)
        if
            self.p1.x < other.p2.x and --
                self.p2.x > other.p1.x and
                self.p1.y < other.p2.y and
                self.p2.y > self.p1.y
         then
            return true
        end
        return false
    end
    return collider
end

return Collider
