Content = Content or {}
Content.Game = Content.Game or require "content.game"
local Game = Content.Game

Fonts = Fonts or require "font"
UTIL = UTIL or require "util"

--* Menu Class
local Menu = {}
Menu.__index = Menu

function Menu:new()
    local menu = {
        options = {
            {
                opt = "Jogar",
                func = function()
                    return Game:new()
                end
            }
        }
    }
    setmetatable(menu, self)

    function menu:update(dt)
        if love.keyboard.isDown("return") then
            return Game:new()
        end
        return self
    end

    function menu:draw()
        local text =
            '"Se você não souber usar, sua arma será sua maior inimiga, mas se souber usar, ela se tornará a sua maior arma"'
        love.graphics.setFont(Fonts.PressStart2P)
        love.graphics.printf(text, 10, 50, UTIL.window.width / 3 - 20, "center", 0, 3)

        local text = "Pressione <Enter> para jogar"
        love.graphics.setFont(Fonts.PressStart2P)
        love.graphics.printf(text, 10, UTIL.window.height - 100, UTIL.window.width / 2 - 20, "center", 0, 2)
    end

    function menu:escape()
        love.event.quit()
    end

    return menu
end

return Menu
