Content = Content or require "content"
Modules = Modules or require "modules"

local content
function love.load()
    content = Content:new()
end

function love.draw()
    content:draw()
end

function love.update(dt)
    content = content:update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        content:escape()
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
