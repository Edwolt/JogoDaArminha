-- Vec Class
local Vec = {}
function Vec:new(x, y)
    local vec = {
        x = x or 0,
        y = y or 0
    }
    setmetatable(vec, self)
    self.__index = self

    function vec:add(other)
        return Vec:new(
            self.x + other.x, --
            self.y + other.y
        )
    end

    function vec:sub(other)
        return Vec:new(
            self.x - other.x, --
            self.y - other.y
        )
    end

    function vec:mul(num)
        return Vec:new(
            self.x * num, --
            self.y * num
        )
    end

    function vec:div(num)
        return Vec:new(
            self.x / num, --
            self.y / num
        )
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

return Vec
