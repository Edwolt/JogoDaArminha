--* Key Class
local Key = {}
Key.__index = Key

function Key:new(time, ...)
    local key = {
        k = {...},
        time = time,
        wait = 0
    }
    setmetatable(key, self)

    function key:press()
        if self.wait <= 0 then
            for _, i in ipairs(self.k) do
                if love.keyboard.isDown(unpack(self.k)) then
                    self.wait = time
                    return true
                end
            end
        end
        return false
    end

    function key:update(dt)
        if self.wait >= 0 then
            self.wait = self.wait - dt
        end
    end

    return key
end

return Key
