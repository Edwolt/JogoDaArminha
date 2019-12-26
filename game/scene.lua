Modules = Modules or require "modules"
local Colliders = Modules.Colliders

--* Scene Class
local Scene = {}
Scene.__index = Scene

function Scene:new(path)
    local tilemap = require("tilemap/" .. path)
    -- sheet
    local tileset = tilemap.tilesets[1]
    local sheet = love.graphics.newImage(tileset.image:sub(3))
    sheet:setFilter("nearest", "nearest")

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
                local x1 = x * tilemap.tilewidth
                local y1 = y * tilemap.tileheight
                local x2 = (x + 1) * tilemap.tilewidth
                local y2 = (y + 1) * tilemap.tileheight
                colliders:add(x1, y1, x2, y2)
                -- TODO create floor
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
        sheet = sheet,
        layer = layer,
        floor = floor,
        colliders = colliders
    }
    setmetatable(scene, self)

    return scene
end
