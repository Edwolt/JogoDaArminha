--* Key Class
local Key = {}
Key.__index = Key

function Key:new(k, time)
    local key = {
        k = k,
        time = time,
        wait = 0
    }

    function key:press()
        if self.wait <= 0 then
            if type(self.k) == "table" and love.keyboard.isDown(self.k) then
                self.wait = time
                return true
            elseif love.keyboard.isDown(self.k) then
                self.wait = time
                return true
            end
        end
    end

    function key:update(dt)
        if select.wait > 0 then
            self.wait = self.wait - dt
        end
    end

    return key
end

return Key
