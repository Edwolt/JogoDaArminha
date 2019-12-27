--* Vec Class
local Vec = {}
Vec.__index = Vec

function Vec:new(x, y)
    local vec = {
        x = x or 0,
        y = y or 0
    }
    setmetatable(vec, self)

    function vec:clone()
        return Vec:new(vec.x, vec.y)
    end

    function vec:norm()
        return math.sqrt(self.x * self.x + self.y * self.y)
    end

    function vec:versor()
        -- return self / ||self||
        return Vec:new(self.div(self.norm()))
    end

    return vec
end

-- Operator Overloading
function Vec.__add(vec1, vec2)
    return Vec:new(
        vec1.x + vec2.x, --
        vec1.y + vec2.y
    )
end

function Vec.__sub(vec1, vec2)
    return Vec:new(
        vec1.x - vec2.x, --
        vec1.y - vec2.y
    )
end

function Vec.__mul(vec, num)
    if getmetatable(num) == Vec then
        vec, num = num, vec
    end

    return Vec:new(
        vec.x * num, --
        vec.y * num
    )
end

function Vec.__div(vec, num)
    if getmetatable(num) == Vec then
        vec, num = num, vec
    end

    return Vec:new(
        vec.x / num, --
        vec.y / num
    )
end

function Vec.__tostring(vec)
    return "(" .. vec.x .. "," .. vec.y .. ")"
end

return Vec
