UTIL = UTIL or require "util"
Modules = Modules or require "modules"
local Colliders = Modules.Colliders
local Vec = Modules.Vec

local function newQuad(tile_pos, tileset)
    return love.graphics.newQuad(
        tile_pos.x * tileset.twidth,
        tile_pos.y * tileset.theight,
        tileset.twidth,
        tileset.theight,
        tileset.iwidth,
        tileset.iheight
    )
end

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
    for y = 0, layer.height - 1 do
        for x = 0, layer.width - 1 do
            local k = y * layer.width + x + 1
            if layer.data[k] == 0 then
                -- Air: Do nothing
            elseif 1 <= layer.data[k] and layer.data[k] <= 3 then
                -- Grass/Water
                local x1 = x * tilemap.tilewidth
                local y1 = y * tilemap.tileheight
                local x2 = (x + 1) * tilemap.tilewidth
                local y2 = (y + 1) * tilemap.tileheight
                colliders:add(x1, y1, x2, y2)
                floor:add(x1 + 3, y1, x2 - 3, y1 + 2)
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
        for y = 0, self.layer.height - 1 do
            for x = 0, self.layer.width - 1 do
                local k = y * self.layer.width + x + 1
                if self.layer.data[k] ~= 0 then
                    local i = self.layer.data[k] - 1

                    local tile_pos = Vec:new(i % self.tileset.columns, math.floor(i / self.tileset.columns))

                    local quad = newQuad(tile_pos, self.tileset)

                    self:_draw(Vec:new(x, y), quad, pos)
                end
            end
        end
        self:drawColliders(pos) -- TODO retirar
    end

    function scene:_draw(screen_pos, quad, pos)
        local real_pos = pos * UTIL.game.scale
        local x = screen_pos.x * self.tileset.twidth
        local y = screen_pos.y * self.tileset.theight

        love.graphics.draw(
            self.tileset.sheet,
            quad,
            x * UTIL.game.scale - real_pos.x,
            y * UTIL.game.scale - real_pos.y,
            0,
            UTIL.game.scale,
            UTIL.game.scale
        )
    end

    function scene:drawColliders(pos)
        love.graphics.setColor(255, 0, 0)
        for _, i in ipairs(self.colliders.vet) do
            local aux1 = i.p1 - pos
            local aux2 = i.p2 - i.p1
            aux1 = aux1*UTIL.game.scale
            aux2 = aux2*UTIL.game.scale
            love.graphics.rectangle("line", aux1.x, aux1.y, aux2.x, aux2.y)
        end
        love.graphics.setColor(0, 255, 0)
        for _, i in ipairs(self.floor.vet) do
            local aux1 = i.p1 - pos
            local aux2 = i.p2 - i.p1
            aux1 = aux1*UTIL.game.scale
            aux2 = aux2*UTIL.game.scale
            love.graphics.rectangle("line", aux1.x, aux1.y, aux2.x, aux2.y)
        end
        love.graphics.setColor(255, 255, 255)
    end

    return scene
end

return Scene
