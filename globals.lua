ASTEROID_SIZE = 100 -- here since we will use it in multiple files, but can also be an asteroid attribute
IsDebug = false
DestroyAst = false

function CalculateDistance(x1, y1, x2, y2)
    return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
end