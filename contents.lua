local Contents = Contents or {}
Contents.Menu = Contents.Menu or require "content.menu"
Contents.Credits = Contents.Credits or require "content.credits"
Contents.Game = Contents.Game or require "content.game"

function Contents:new()
    return Contents.Menu:new()
end

return Contents
