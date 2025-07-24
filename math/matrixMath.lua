matrixMath = {}

local player = require("game.properties.player")

matrixMath.projectedMatrix = {
    {1,0,0},
    {0,1,0},
    {0,0,0}
}

function matrixMath.matrixMultiply(projectedMatrix, multiplyMatrix)
    res = {0,0,0}

    for i = 1, 3 do
        for j = 1, 3 do
            res[i] = (multiplyMatrix[j] * projectedMatrix[j][i]) + res[i]
        end
    end

    return res
end

function matrixMath.calculateProjections()
    matrixMath.zRotationAngle = {
        {math.cos(player.camera.angle), -math.sin(player.camera.angle), 0},
        {math.sin(player.camera.angle), math.cos(player.camera.angle), 0},
        {0,0,1}
    }

    matrixMath.yRotationAngle = {
        {math.cos(player.camera.yaw), 0, math.sin(player.camera.yaw)},
        {0, 1, 0},
        {-math.sin(player.camera.yaw), 0, math.cos(player.camera.yaw)},
    }

    matrixMath.xRotationAngle = {
        {1, 0, 0},
        {0, math.cos(player.camera.pitch), -math.sin(player.camera.pitch)},
        {0, math.sin(player.camera.pitch), math.cos(player.camera.pitch)},
    }
end

return matrixMath