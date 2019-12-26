UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Colliders = Modules.Colliders
local Vec = Modules.Vec

--* Scene Class
local Scene = {}
Scene.__index = Scene

function Scene:new(path)
    local tilemap = require("tilemap/" .. path)

    -- sheet and others informations
    local _tileset = tilemap.tilesets[1]
    local tileset = {
        sheet = love.graphics.newImage(_tileset.image:sub(3)),
        -- Tile dimensions
        twidth = _tileset.tilewidth,
        theight = _tileset.tileheight,
        -- Image dimensions
        iwidth = _tileset.imagewidth,
        iheight = _tileset.imageheight,
        columns = _tileset.columns
    }
    tileset.sheet:setFilter("nearest", "nearest")

    -- layer
    local layer = tilemap.layers[1]

    -- colliders
    local floor = Colliders:new()
    local colliders = Colliders:new()
    for x = 0, layer.height - 1 do
        for y = 0, layer.width - 1 do
            local k = y * self.width + x + 1
            if layer.data[k] == 0 then
                -- Air: Do nothing
            elseif 1 <= layer.data[k] or layer.data[k] <= 3 then
                -- Grass/Water
                -- TODO create floor
                local x1 = x * tilemap.tilewidth
                local y1 = y * tilemap.tileheight
                local x2 = (x + 1) * tilemap.tilewidth
                local y2 = (y + 1) * tilemap.tileheight
                colliders:add(x1, y1, x2, y2)
            elseif layer.data[k] == 4 then
                -- Dirt
                local x1 = x * tilemap.tilewidth
                local y1 = y * tilemap.tileheight
                local x2 = (x + 1) * tilemap.tilewidth
                local y2 = (y + 1) * tilemap.tileheight
                colliders:add(x1, y1, x2, y2)
            end
        end
    end

    local scene = {
        tileset = tileset,
        layer = layer,
        floor = floor,
        colliders = colliders
    }
    setmetatable(scene, self)

    function scene:draw(pos)
        for x = 0, self.layer.height - 1 do
            for y = 0, self.width - 1 do
                local k = y * self.layer.width + x + 1
                if self.data[k] ~= 0 then
                    local i = self.data[k] - 1

                    local image_pos = Vec:new(i % self.tileset.columns, math.floor(i / self.columns))

                    local quad = love.graphics.newQuad()
                end
            end
        end
    end

    return scene
end
