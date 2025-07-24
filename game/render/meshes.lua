meshes = {
    block1 = love.graphics.newMesh({
            {0, 0, 0, 0,  1, 0, 0, 1},
            {50, 0, 1, 0,  0, 1, 0, 1},
            {50, 50, 1, 1,  0.5, 0.5, 0.5, 1},
            {0, 50, 0, 1,  0, 0, 1, 1}
        },
        "fan",
        "static"
    )
}

return meshes