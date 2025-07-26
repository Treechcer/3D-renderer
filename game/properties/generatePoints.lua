local map = require("game.properties.points")

generatePoints = {}

function generatePoints.class(metadata, typeS)
    --[[
    
    EXAMPLE:

    {
    metadata = {
        posX = 0,
        posY = 0,
        posZ = 0,
        color = {246/255, 83/255, 20/255,1},

        rotX = 0,
        rotY = 0,
        rotZ = 0,
    },
    type = "block"
    },
    
    ]]

    return {
        metadata = metadata,
        type = typeS
    }
end

function generatePoints.mapGen(X, Y, Z)
    for z = 1, Z do
        for y = 1, Y do
            for x = 1, X do
                local temp = generatePoints.class({posX = (x - 1) * 2, posY = (y - 1) * 2, posZ = (z - 1) * 2, color = {math.random(255) / 255, math.random(255) / 255, math.random(255) / 255}, rotX = 0, rotY = 0, rotZ = 0}, "block")
                map.addPoint(temp)
            end
        end
    end
end

return generatePoints