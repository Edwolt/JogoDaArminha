local Array = {}
Array.__index = Array

function Array:new(class)
    local array = {
        vet = {},
        class = class
    }

    function array:add(...)
        table.insert(self.vet, class:new(...))
    end

    function array:draw()
        for _, i in ipairs(self.vet) do
            i:draw()
        end
    end

    function array:update(dt)
        for _, i in ipairs(self.vet) do
            i:update(dt)
        end
    end

    return array
end

return Array
