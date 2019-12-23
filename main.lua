Contents = Contents or require "contents"
Modules = Modules or require "modules"

local content
function love.load()
    content = Contents:new()
end

function love.draw()
    content:draw()
end

function love.update(dt)
    local change = content:update(dt)
    if change then
        content = Contents[change]:new()
    end
end

function love.keypressed(key)
    if key == "escape" then
        local change = content:escape()
        if change then
            content = Contents[change]:new()
        end
    end
end

function love.keyreleased(key)
end

--[[
function love.resize(w, h)
end
function love.focus(bool)
end
function love.keypressed(key, unicode)
end
function love.keyreleased(key, unicode)
end
function love.mousepressed(x, y, button)
end
function love.mousereleased(x, y, button)
end
function love.quit()
end
--]]
