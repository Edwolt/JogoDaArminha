local Array = {}
Array.__index = Array

function Array:new(class)
    local array = {
        vet = {},
        class = class
    }
    setmetatable(array, self)

    function array:add(obj, ...)
        if getmetatable(obj) == class then
            table.insert(self.vet, obj)
        else
            table.insert(self.vet, class:new(obj, ...))
        end
    end

    function array:remove(k)
        table.remove(self.vet, k)
    end

    function array:draw(...)
        for _, i in ipairs(self.vet) do
            i:draw(...)
        end
    end

    function array:update(dt, ...)
        for _, i in ipairs(self.vet) do
            i:update(dt, ...)
        end
    end

    function array:ipairs()
        return ipairs(self.vet)
    end
    return array
end

return Array
