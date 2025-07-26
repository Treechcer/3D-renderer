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
    matrixMath.zRotationAngle = matrixMath.getZRotationMatrix(player.camera.angle)

    matrixMath.yRotationAngle = matrixMath.getYRotationMatrix(player.camera.yaw)

    matrixMath.xRotationAngle = matrixMath.getXRotationMatrix(player.camera.pitch)
end


function matrixMath.getXRotationMatrix(angle)
    return {
        {1, 0, 0},
        {0, math.cos(angle), -math.sin(angle)},
        {0, math.sin(angle), math.cos(angle)},
    }
end

function matrixMath.getYRotationMatrix(angle)
    return {
        {math.cos(angle), 0, math.sin(angle)},
        {0, 1, 0},
        {-math.sin(angle), 0, math.cos(angle)},
    }
end

function matrixMath.getZRotationMatrix(angle)
        return {
            {math.cos(angle), -math.sin(angle), 0},
            {math.sin(angle), math.cos(angle), 0},
            {0,0,1}
        }
end

return matrixMath