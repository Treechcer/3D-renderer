map = {
    points = {}
    --[[{
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
    {
        metadata = {
            posX = 2,
            posY = 0,
            posZ = 0,
            color = {124/255, 187/255, 0/255,1},

            rotX = 0,
            rotY = 0,
            rotZ = 0,
        },
        type = "block"
    },
    {
        metadata = {
            posX = 2,
            posY = 2,
            posZ = 0,
            color = {255/255, 187/255, 0/255,1},

            rotX = 0,
            rotY = 0,
            rotZ = 0,
        },
        type = "block"
    },
    {
        metadata = {
            posX = 0,
            posY = 2,
            posZ = 0,
            color = {0/255, 164/255, 239/255,1},

            rotX = 0,
            rotY = 0,
            rotZ = 0,
        },
        type = "block"
    },
    {
        metadata = {
            posX = 4,
            posY = 4,
            posZ = 0,
            color = {0/255, 164/255, 239/255,1},

            rotX = 0,
            rotY = 0,
            rotZ = 0,
        },
        type = "slope"
    }]]
}

function map.addPoint(point)
    table.insert(map.points, point)
end

return map