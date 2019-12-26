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
            if layer.data[k] == 0 then --TODO
            elseif layer.data[k] == 0 then
            end
        end
    end

    local scene = {
        sheet = sheet,
        layer = layer,
        colliders = colliders
    }

    return scene
end
