UTIL = UTIL or require "util"

Enums = Enums or require "enums"
local Elements = Enums.Elements

Modules = Modules or require "modules"
local List = Modules.List
local Vec = Modules.Vec

Contents = Contents or {}
Contents.Game = Contents.Game or {}
Contents.Game.Block = Contents.Game.Block or require "game.block"
local Block = Contents.Game.Block
Contents.Game.Enemy = Contents.Game.Enemy or require "game.enemy"
local Enemy = Contents.Game.Enemy

--* Spawn Class
local Spawn = {}
Spawn.__index = Spawn

function Spawn:new(pos, time)
    local spawn = {
        pos = pos,
        clock = 1,
        time = time or 1
    }
    setmetatable(spawn, self)

    function spawn:spawn()
        if self.clock <= 0 then
            self.clock = time
            return Enemy:new(Elements.DIRT, self.pos, Vec:new(500, 0), Vec:new(0, UTIL.gravity))
        end
    end

    function spawn:forceSpawn()
        return Enemy:new(Elements.DIRT, self.pos, Vec:new(500, 0), Vec:new(0, UTIL.gravity))
    end

    function spawn:update(dt)
        -- clock = clock - dt > 0 ? self.clock : 0
        self.clock = self.clock - dt > 0 and self.clock - dt or 0
    end

    return spawn
end

--* Scene Class
local Scene = {}
Scene.__index = Scene

function Scene:new(path)
    local tilemap = require("tilemap/" .. path)
    local layer = tilemap.layers[1]

    local scene = {blocks = List:new(Block)}
    local spawns = List:new(Spawn)
    local position = Vec:new()
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
            elseif layer.data[k] == 3 then
                local pos = Vec:new(x * tilemap.tilewidth, y * tilemap.tileheight)
                spawns:add(pos, 1)
            elseif layer.data[k] == 4 then
                position = Vec:new(x * tilemap.tilewidth, y * tilemap.tileheight)
            end
        end
    end

    function scene:draw(pos)
        self.blocks:draw(pos)
    end

    function scene:drawDev(pos, color1, color2)
        for _, i in self.blocks:ipairs() do
            i:drawDev(pos, color1, color2)
        end
    end

    function scene:update(dt)
        self.blocks:update(dt)
    end

    function scene:changeBlocks(element, that)
        for _, i in self.blocks:ipairs() do
            local this = i:getWall()
            if this and this:collision(that) then
                i:change(element, 10)
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

    return {pos = position, spawns = spawns, scene = scene}
end

return Scene
