Fonts = Fonts or require "fonts"

--* Line Table
local function newLine(text, scale)
    return {
        text = text or "",
        scale = scale or 3
    }
end

--* Credits Class
Credits = {
    lines = {
        newLine("Autores:", 5),
        newLine("Eduardo Souza Rocha"),
        newLine("Victor Isaias de Almeida Rocha")
    }
}
Credits.__index = Credits

function Credits:new()
    local credits = {}
    setmetatable(credits, self)

    function credits:update(dt)
    end

    function credits:draw()
        local y = 50
        local limit = (UTIL.window.width - 100)
        for _, i in ipairs(Credits.lines) do
            y = y + UTIL.printw(i.text, Fonts.PressStart2P, 50, y, limit, "center", i.scale)
        end
    end

    function credits:escape()
        return "Menu"
    end

    return credits
end

return Credits
