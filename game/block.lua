Enums = Enums or require "enums"
local Elements = Enums.Elements

Modules = Modules or require "modules"
local Dim = Modules.Dim
local Collider = Modules.Collider

--* Block Class
local Block = {
    sprite = {
        dirt = love.graphics.newImage("images/dirt.png"),
        grass = love.graphics.newImage("images/grass.png")
    },
}
Block.sprite.dirt:setFilter("nearest", "nearest")
Block.sprite.grass:setFilter("nearest", "nearest")

Block.tam = Dim:extract(Block.sprite.dirt)

Block.__index = Block

function Block:new(pos, value)
    local block = {
        pos = pos,
        value = value, -- 1:Floor ; 2:Wall
        clock = 0
    }
    setmetatable(block, self)

    function block:draw(pos)
        local real_pos = (self.pos - pos) * UTIL.game.scale
        if self.value == Elements.GRASS then
            love.graphics.draw(self.sprite.grass, real_pos.x, real_pos.y, 0, UTIL.game.scale)
        elseif self.value == Elements.DIRT then
            love.graphics.draw(self.sprite.dirt, real_pos.x, real_pos.y, 0, UTIL.game.scale)
        end
    end

    function block:update(dt)
        if self.value ~= Elements.DIRT and self.value ~= Elements.GRASS then
            self.clock = self.clock - dt
            if self.clock <= 0 then
                self.value = Elements.GRASS
                self.clock = 0
            end
        end
    end

    function block:change(element, clock)
        self.element = element
        self.clock = clock or 1
    end

    function block:getWall()
        local p2 = self.tam:toVec() + self.pos
        return Collider:new(self.pos, p2)
    end

    function block:getFloor()
        if self.value == Elements.GRASS then
            local x1 = self.pos.x + 3
            local y1 = self.pos.y
            local x2 = self.pos.x + self.tam.width - 3
            local y2 = self.pos.y + 2
            return Collider:new(x1, y1, x2, y2)
        end
        return nil
    end

    return block
end

return Block