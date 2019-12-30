local Contents = Contents or {}
Contents.Menu = Contents.Menu or require "contents.menu"
Contents.Game = Contents.Game or require "contents.game"
Contents.Help = Contents.Help or require "contents.help"
Contents.Credits = Contents.Credits or require "contents.credits"

function Contents:new() -- De onde o jogo começa
    return Contents.Menu:new()
end

return Contents
