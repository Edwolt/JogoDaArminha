Modules = Modules or require "modules"
local Colliders = Modules.Colliders

--* Scene Class
local Scene = {}
Scene.__index = Scene

function Scene:new(path)
    local scene = {colliders = Colliders:new()}
    function scene:load(path)
        local tilemap = require("tilemap/" .. path)
        local tileset = tilemap.tilesets[1]
        local sheet = love.graphics.newImage(tileset.image:sub(3))
    end
end
