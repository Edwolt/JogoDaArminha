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
        value = value, -- 1:Floor ; 2:Wall
        clock = 0
    }

    function block:draw(pos)
        local real_pos = (self.pos - pos) * UTIL.game.scale
        if value == 1 then
            love.graphics.draw(Block.sprite.grass, real_pos.x, real_pos.y, 0, UTIL.game.scale)
        elseif value == 2 then
            love.graphics.draw(Block.sprite.dirt, real_pos.x, real_pos.y, 0, UTIL.game.scale)
        end
    end

    function block:update(dt)
        if self.value ~= 1 and self.value ~= 2 then
            self.clock = self.clock - dt
            if self.clock <= 0 then
                self.value = 2
                self.clock = 0
            end
        end
    end

    function block:getWall()
        local p2 = Vec:new(Block.width, Block.height)
        p2 = p2 + self.pos
        return Collider:new(self.pos, p2)
    end

    function block:getFloor()
        if self.value == 1 then
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
    setmetatable(scene, self)

    for y = 0, layer.height - 1 do
        for x = 0, layer.width - 1 do
            local k = y * layer.width + x + 1
            if layer.data[k] == 0 then
                -- Air: Do nothing
            elseif layer.data[k] == 1 then
                -- Grass
                local pos = Vec:new(x * tilemap.tilewidth, y * tilemap.tileheight)
                table.insert(scene.blocks, Block:new(pos, 1))
            elseif layer.data[k] == 2 then
                -- Dirt
                local pos = Vec:new(x * tilemap.tilewidth, y * tilemap.tileheight)
                table.insert(scene.blocks, Block:new(pos, 2))
            end
        end
    end

    function scene:draw(pos)
        for _, i in ipairs(self.blocks) do
            i:draw(pos)
        end
    end

    function scene:update(dt)
        for _, i in ipairs(self.blocks) do
            i:update(dt)
        end
    end

    function scene:wallCollision(that)
        for _, i in ipairs(self.blocks) do
            local this = i:getWall()
            if this and this:collision(that) then
                return i, this
            end
        end
    end

    function scene:floorCollision(that)
        for _, i in ipairs(self.blocks) do
            local this = i:getFloor()
            if this and this:collision(that) then
                return i, this
            end
        end
    end

    return scene
end

return Scene
