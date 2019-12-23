local Content = Content or {}
Content.Menu = Content.Menu or require "content.menu"
Content.Game = Content.Game or require "content.game"

function Content:new()
    return Content.Menu:new()
end

return Content
