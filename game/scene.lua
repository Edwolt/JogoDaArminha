UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Collider = Modules.Collider
local Vec = Modules.Vec

--* Block Class
local Block = {
    sprite = {
        dirt = love.graphics.newImage("placeholder/dirt.png"),
        grass = love.graphics.newImage("placeholder/grass.png")
    }
}
Block.sprite.dirt:setFilter("nearest", "nearest")
Block.sprite.grass:setFilter("nearest", "nearest")

Block.width = Block.sprite.dirt:getWidth()
Block.height = Block.sprite.dirt:getHeight()

Block.__index = Block

function Block:new(pos, value)
    local block = {
        pos = pos,
        value = value, -- 1: Wall; 2: Floor
        clock = 0
    }

    function block:draw(pos)
        local real_pos = (self.pos - pos) * UTIL.game.scale
        if value == 1 then
            love.graphics.draw(Block.sprite.dirt, real_pos.x, real_pos.y, 0, UTIL.game.scale)
        end
        if value == 2 then
            love.graphics.draw(Block.sprite.grass, real_pos.x, real_pos.y, 0, UTIL.game.scale)
        end
    end

    function block:update(dt)
        if self.value ~= 1 and self.value ~= 2 then
            self.clock = self.clock - dt
        end
        if self.clock <= 0 then
            self.value = 2
            self.clock = 0
        end
    end

    function block:getCollider()
        local p2 = Vec:new(Block.width, Block.height)
        p2 = p2 + self.pos
        return Collider:new(self.pos, p2)
    end

    function block:getFloor()
        if self.value == 2 then
            local x1 = self.pos.x + 3
            local y1 = self.pos.y
            local x2 = self.pos.x + Block.width - 3
            local y2 = self.pos.y + 2
            return Collider:new(x1, y1, x2, y2)
        end
        return nil
    end

    return block
end

--* Scene Class
local Scene = {}
Scene.__index = Scene

function Scene:new(path)
    local tilemap = require("tilemap/" .. path)
    local layer = tilemap.layers[1]

    local scene = {blocks = {}}

    for y = 0, layer.height - 1 do
        for x = 0, layer.width - 1 do
            local k = y * layer.width + x + 1
            if layer.data[k] == 0 then
                -- Air: Do nothing
            elseif layer.data[k] == 1 then
                -- Grass
                local pos = Vec:new(x * tilemap.tilewidth, y * tilemap.tileheight)
                table.insert(scene.blocks, Block:new(pos, 2))
            elseif layer.data[k] == 2 then
                -- Dirt
                local pos = Vec:new(x * tilemap.tilewidth, y * tilemap.tileheight)
                table.insert(scene.blocks, Block:new(pos, 1))
            end
        end
    end

    setmetatable(scene, self)

    function scene:draw(pos)
        for _, i in ipairs(self.blocks) do
            i:draw(pos)
        end
    end

    return scene
end

return Scene
