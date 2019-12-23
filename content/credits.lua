Content = Content or {}
Content.Menu = Content.Menu or require "content.menu"
local Menu = Content.Menu

Credits = {}
Credits.__index = Credits

function Credits:new()
    local credits = {}
    setmetatable(credits, Credits)

    function credits:update(dt)
    end

    function credits:draw()
    end

    function credits:escape()
        return "Menu"
    end

    return credits
end

return Credits
