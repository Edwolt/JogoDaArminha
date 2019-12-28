UTIL = UTIL or require "util"

Enums = Enums or require "enums"
local Elements = Enums.Elements

Modules = Modules or require "modules"
local Array = Modules.Array
local Vec = Modules.Vec

Contents = Contents or {}
Contents.Game = Contents.Game or {}
Contents.Game.Block = Contents.Game.Block or require "game.block"
local Block = Contents.Game.Block

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
                scene.blocks:add(pos, Elements.GRASS)
            elseif layer.data[k] == 2 then
                -- Dirt
                local pos = Vec:new(x * tilemap.tilewidth, y * tilemap.tileheight)
                scene.blocks:add(pos, Elements.DIRT)
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
        for _, i in self.blocks:ipairs() do
            local this = i:getWall()
            if this and this:collision(that) and i.value == Elements.GRASS then
                i.value = element
                i.clock = 1
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
