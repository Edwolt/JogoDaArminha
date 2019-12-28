Enums = Enums or require "enums"
local Elements = Enums.Elements

Modules = Modules or require "modules"
local Dim = Modules.Dim
local Collider = Modules.Collider


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

--* Commons
local Commons = {}
function Commons:getWall()
    local p2 = self.tam:toVec() + self.pos
    return Collider:new(self.pos, p2)
end

--* Dirt Block
local Dirt = {}
function Dirt:draw(pos)
    local real_pos = (self.pos - pos) * UTIL.game.scale
    love.graphics.draw(self.sprite.dirt, real_pos.x, real_pos.y, 0, UTIL.game.scale)
end

Dirt.update = nofunc
Dirt.change = nofunc
Dirt.getWall = Commons.getWall
Dirt.getFloor = nofunc

--* Grass Block
local Grass = {}
function Grass:draw(pos)
    local real_pos = (self.pos - pos) * UTIL.game.scale
    love.graphics.draw(self.sprite.grass, real_pos.x, real_pos.y, 0, UTIL.game.scale)
end

Grass.update = nofunc

function Grass:change(elemnt, clock)
    changeBlock(self, Dirt)
end

Grass.getWall = Commons.getWall

function Grass:getFloor()
    local x1 = self.pos.x + 3
    local y1 = self.pos.y
    local x2 = self.pos.x + self.tam.width - 3
    local y2 = self.pos.y + 2
    return Collider:new(x1, y1, x2, y2)
end

--* Block Class
local Block = {
    sprite = {
        dirt = love.graphics.newImage("images/dirt.png"),
        grass = love.graphics.newImage("images/grass.png")
    }
}
Block.sprite.dirt:setFilter("nearest", "nearest")
Block.sprite.grass:setFilter("nearest", "nearest")

Block.tam = Dim:extract(Block.sprite.dirt)

Block.__index = Block

function Block:new(pos, value)
    local block = {
        pos = pos,
        clock = 0
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
