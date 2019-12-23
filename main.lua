function love.load()
end

function love.draw()
end

function love.update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.keyreleased(key)
    if key == "w" then
        game.player:stopJump()
    end
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
