--* Elements Enum

local Elements = {
    FIRE = 1,
    WATER = 2,
    PLANT = 3,
    DIRT = 4,
    GRASS = 5
}

function Elements.leftRotate(el)
    if el < 1 or 3 < el then
        return el
    end

    return el - 1 >= 1 and el - 1 or 3
end

function Elements.rightRotate(el)
    if el < 1 or 3 < el then
        return el
    end
    
    return el + 1 <= 3 and el + 1 or 1
end

return Elements
