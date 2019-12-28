UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Collider = Modules.Collider
local Array = Modules.Array
local Vec = Modules.Vec
local Dim = Modules.Dim

--* Block Class
local Block = {
    sprite = {
        dirt = love.graphics.newImage("images/dirt.png"),
        grass = love.graphics.newImage("images/grass.png")
    },
    DIRT = 1,
    GRASS = 2
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
        if value == Block.GRASS then
            love.graphics.draw(self.sprite.grass, real_pos.x, real_pos.y, 0, UTIL.game.scale)
        elseif value == Block.DIRT then
            love.graphics.draw(self.sprite.dirt, real_pos.x, real_pos.y, 0, UTIL.game.scale)
        end
    end

    function block:update(dt)
        if self.value ~= Block.DIRT and self.value ~= Block.GRASS then
            self.clock = self.clock - dt
            if self.clock <= 0 then
                self.value = Block.GRASS
                self.clock = 0
            end
        end
    end

    function block:getWall()
        local p2 = self.tam:toVec() + self.pos
        return Collider:new(self.pos, p2)
    end

    function block:getFloor()
        if self.value == Block.GRASS then
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

--* Scene Class
local Scene = {}
Scene.__index = Scene

function Scene:new(path)
    local tilemap = require("tilemap/" .. path)
    local layer = tilemap.layers[1]

    local scene = {blocks = Array:new(Block)}
    setmetatable(scene, self)

    for y = 0, layer.height - 1 do
        for x = 0, layer.width - 1 do
            local k = y * layer.width + x + 1
            if layer.data[k] == 0 then
                -- Air: Do nothing
            elseif layer.data[k] == 1 then
                -- Grass
                local pos = Vec:new(x * tilemap.tilewidth, y * tilemap.tileheight)
                scene.blocks:add(pos, Block.GRASS)
            elseif layer.data[k] == 2 then
                -- Dirt
                local pos = Vec:new(x * tilemap.tilewidth, y * tilemap.tileheight)
                scene.blocks:add(pos, Block.DIRT)
            end
        end
    end

    function scene:draw(pos)
        self.blocks:draw(pos)
    end

    function scene:update(dt)
        self.blocks:update(dt)
    end

    function scene:changeBlocks(element, that)
        for _, i in self.bolcks:ipairs() do
            local this = i:getWall()
            if this and this:collision(that) and this.value == 2 then
            end
        end
    end

    function scene:wallCollision(that)
        for _, i in self.blocks:ipairs() do -- TODO Otimizar (Uma QuadTree deve ajudar)
            local this = i:getWall()
            if this and this:collision(that) then
                return i, this
            end
        end
    end

    function scene:floorCollision(that)
        for _, i in self.blocks:ipairs() do -- TODO Otimizar (Uma QuadTree deve ajudar)
            local this = i:getFloor()
            if this and this:collision(that) then
                return i, this
            end
        end
    end

    return scene
end

return Scene
