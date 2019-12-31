--* List Class
local List = {}
List.__index = List

function List:new(class)
    local list = {
        vet = {},
        class = class
    }
    setmetatable(list, self)

    function list:add(obj, ...)
        if getmetatable(obj) == class then
            table.insert(self.vet, obj)
        else
            table.insert(self.vet, class:new(obj, ...))
        end
    end

    function list:remove(k)
        table.remove(self.vet, k)
    end

    function list:draw(...)
        for _, i in ipairs(self.vet) do
            i:draw(...)
        end
    end

    function list:drawDev(...)
        if not self.vet[1] or not self.vet[1].drawDev then
            return
        end

        for _,i in ipairs(self.vet) do
            i:drawDev(...)
        end
    end

    function list:update(dt, ...)
        for _, i in ipairs(self.vet) do
            i:update(dt, ...)
        end
    end

    function list:ipairs()
        return ipairs(self.vet)
    end
    return list
end

return List
