Fonts = Fonts or require "fonts"
UTIL = UTIL or require "util"

--* Line Table
local function newLine(text, scale, align)
    return {
        text = text or "",
        scale = scale or 2,
        align = align or "left"
    }
end

--* Help Class
local Help = {
    lines = {
        newLine("Instruções", 5, "center"),
        newLine(
            "Para ver as instruções entre no menu principal, use as setas ou o ws para selecionar instruções e aperte enter"
        ),
        newLine(),
        newLine(),
        newLine("Objetivo", 3, "center"),
        newLine("O Objetivo do jogo é matar o máximo de inimigos possíveis"),
        newLine("Quanto mais inimigos você matar, maior será sua pontuação"),
        newLine("Você tem 3 tipos de armas diferente, arma de fogo, água e planta"),
        newLine(),
        newLine("Armas", 3, "center"),
        newLine(">Fogos", 2.25),
        newLine("Bom contra inimigo do tipo planta e ineficiente com o do tipo água"),
        newLine("Se passar por um bloco molhado ele aquece e passa a dar dano em que o toca"),
        newLine(">Água", 2.25),
        newLine("Bom contra inimigo do tipo fogo e ineficiente com o do tipo planta"),
        newLine("Molha cada bloco que passa"),
        newLine(),
        newLine(">Planta", 2.25),
        newLine("Bom contra inimigo do tipo agua e ineficiente com o do tipo fogo"),
        newLine(),
        newLine("História", 3, "center"),
        newLine("Estava tão ocupado fazendo o jogo que esqueci de criar a história do jogo"),
        newLine(),
        newLine("Controles", 3, "center"),
        newLine("espaço atira"),
        newLine("wasd e setas movimenta"),
        newLine("tab mostra colisores e o FPS e vidas")
    },
    vel_y = 250
}
Help.__index = Help

function Help:new()
    local help = {
        pos_y = 50
    }
    setmetatable(help, self)

    function help:draw()
        local y = self.pos_y
        local limit = (UTIL.window.width - 100)
        for _, i in ipairs(self.lines) do
            y = y + UTIL.printw(i.text, Fonts.PressStart2P, 50, y, limit, i.align, i.scale)
        end
    end

    function help:update(dt)
        if love.keyboard.isDown("s", "down") then
            self.pos_y = self.pos_y - dt * self.vel_y
        end

        if love.keyboard.isDown("w", "up") then
            self.pos_y = self.pos_y + dt * self.vel_y
        end
    end

    function help:escape()
        return "Menu"
    end

    return help
end

return Help
