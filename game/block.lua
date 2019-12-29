Enums = Enums or require "enums"
local Elements = Enums.Elements

Modules = Modules or require "modules"
local Dim = Modules.Dim
local Collider = Modules.Collider

--*
local Sprites = {}
local Commons = {}
local Dirt = {}
local Grass = {}
local Water = {}
local Block = {}

--* Local functions
local nofunc = function()
end

local function changeBlock(old, new)
    old.draw = new.draw
    old.update = new.update
    old.change = new.change
    old.getWall = new.getWall
    old.getFloor = new.getFloor
end

--* Sprites
Sprites = {
    dirt = love.graphics.newImage("images/dirt.png"),
    grass = love.graphics.newImage("images/grass.png"),
    water = {
        love.graphics.newImage("images/w1.png"),
        love.graphics.newImage("images/w2.png"),
        love.graphics.newImage("images/w3.png"),
        love.graphics.newImage("images/w4.png"),
        love.graphics.newImage("images/w5.png")
    }
}
Sprites.dirt:setFilter("nearest", "nearest")
Sprites.grass:setFilter("nearest", "nearest")
for _, i in ipairs(Sprites.water) do
    i:setFilter("nearest", "nearest")
end

--* Commons
Commons = {}
function Commons:getWall()
    local p2 = self.tam:toVec() + self.pos
    return Collider:new(self.pos, p2)
end

--* Dirt Block
Dirt = {}
function Dirt:draw(pos)
    local real_pos = (self.pos - pos) * UTIL.game.scale
    love.graphics.draw(Sprites.dirt, real_pos.x, real_pos.y, 0, UTIL.game.scale)
end

Dirt.update = nofunc
Dirt.change = nofunc
Dirt.getWall = Commons.getWall
Dirt.getFloor = nofunc

--* Grass Block
Grass = {}
function Grass:draw(pos)
    local real_pos = (self.pos - pos) * UTIL.game.scale
    love.graphics.draw(Sprites.grass, real_pos.x, real_pos.y, 0, UTIL.game.scale)
end

Grass.update = nofunc

function Grass:change(element, clock)
    if element == Elements.WATER then
        changeBlock(self, Water)
        self.clock = clock
        self.hot = 0
    else
        changeBlock(self, Dirt)
    end
end

Grass.getWall = Commons.getWall

function Grass:getFloor()
    local x1 = self.pos.x + 3
    local y1 = self.pos.y
    local x2 = self.pos.x + self.tam.width - 3
    local y2 = self.pos.y + 2
    return Collider:new(x1, y1, x2, y2)
end

--TODO Fire Block

--* Water Block
Water = {} -- {clock, water}
function Water:draw(pos)
    local real_pos = (self.pos - pos) * UTIL.game.scale

    if self.hot <= 0 then
        love.graphics.draw(Sprites.water[1], real_pos.x, real_pos.y, 0, UTIL.game.scale)
    elseif 0 < self.hot and self.hot <= 1 then
        love.graphics.draw(Sprites.water[2], real_pos.x, real_pos.y, 0, UTIL.game.scale)
    elseif 1 < self.hot and self.hot <= 2 then
        love.graphics.draw(Sprites.water[3], real_pos.x, real_pos.y, 0, UTIL.game.scale)
    elseif 2 < self.hot and self.hot <= 3 then
        love.graphics.draw(Sprites.water[4], real_pos.x, real_pos.y, 0, UTIL.game.scale)
    elseif 3 < self.hot then
        love.graphics.draw(Sprites.water[5], real_pos.x, real_pos.y, 0, UTIL.game.scale)
    end
end

function Water:update(dt)
    self.clock = self.clock - dt
    if self.clock < 0 then
        changeBlock(self, Grass)
        self.clock = nil
    end
    -- hot = hot - dt*K >= 0 ? hot - dt*K : 0
    self.hot = self.hot - dt >= 0 and self.hot - dt or 0
end

function Water:change(element, clock)
    if element == Elements.WATER then
        self.clock = clock
    elseif element == Elements.FIRE then
        self.hot = 5
    elseif element == Elements.PLANT then
        self.hot = nil
        changeBlock(self, Grass)
    end
end

Water.getWall = Commons.getWall

function Water:getFloor()
    local x1 = self.pos.x + 3
    local y1 = self.pos.y
    local x2 = self.pos.x + self.tam.width - 3
    local y2 = self.pos.y + 2
    return Collider:new(x1, y1, x2, y2)
end

--TODO Plant Block

--* Block Class
Block = {
    sprite = {
        dirt = love.graphics.newImage("images/dirt.png"),
        grass = love.graphics.newImage("images/grass.png")
    }
}

Block.tam = Dim:extract(Block.sprite.dirt)

Block.__index = Block

function Block:new(pos, value)
    local block = {
        pos = pos
    }
    setmetatable(block, self)

    if value == Elements.GRASS then
        changeBlock(block, Grass)
    else
        changeBlock(block, Dirt)
    end

    return block
end

return Block
