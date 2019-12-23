Fonts = Fonts or require "fonts"
Content = Content or {}
Content.Menu = Content.Menu or require "content.menu"
local Menu = Content.Menu

Credits = {
    lines = {
    }
}
Credits.__index = Credits

function Credits:new()
    local credits = {}
    setmetatable(credits, Credits)

    function credits:update(dt)
    end

    function credits:draw()
        local y = 50
        local limit = (UTIL.window.width - 100)
        for _, i in ipairs(Credits.lines) do
            y = y + UTIL.printw(i, Fonts.PressStart2P, 50, y, limit, "center", 3)
        end
    end

    function credits:escape()
        return "Menu"
    end

    return credits
end

return Credits
