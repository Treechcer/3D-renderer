love = require("love")

function love.load()
    points = {
        {-1,-1,1},
        {1,-1,1},
        {1,1,1},
        {-1,1,1},
        {-1,-1,-1},
        {1,-1,-1},
        {1,1,-1},
        {-1,1,-1}
    }

    projectedMatrix = {
        {1,0,0},
        {0,1,0},
        {0,0,0}
    }

    scale = 100

    width, height = love.graphics.getDimensions()

    pos = {width / 2, height / 2}

    angle = 0
end

function love.draw()
    zRotationAngle = {
        {math.cos(angle), -math.sin(angle), 0},
        {math.sin(angle), math.cos(angle), 0},
        {0,0,1}
    }

    yRotationAngle = {
        {math.cos(angle), 0, math.sin(angle)},
        {0,1,0},
        {-math.sin(angle),0 ,  math.cos(angle)},
    }

    xRotationAngle = {
        {1,0,0},
        {0, math.cos(angle), -math.sin(angle)},
        {0, math.sin(angle), math.cos(angle)},
    }

    projectedPoints = {}

    for i = 1, #points do
        rotate = matrixMultiply(zRotationAngle, points[i])

        rotate = matrixMultiply(xRotationAngle, rotate)

        projected = matrixMultiply(projectedMatrix, rotate)

        x = projected[1] * scale + pos[1]
        y = projected[2] * scale + pos[2]

        love.graphics.circle("fill", x, y, 5)

        table.insert(projectedPoints, {x = x, y = y})
    end

    for i = 1, 4 do
        connectPoint(i, (i % 4) + 1, projectedPoints)
        connectPoint(i + 4, (i % 4) + 5, projectedPoints)
        connectPoint(i, i + 4, projectedPoints)
    end
end

function love.update(dt)
    angle = angle + 1 * dt
end

function matrixMultiply(projectedMatrix, multiplyMatrix)
    res = {0,0,0}

    for i = 1, 3 do
        for j = 1, 3 do
            res[i] = (multiplyMatrix[j] * projectedMatrix[j][i]) + res[i]
        end
    end

    return res
end

function connectPoint(i, j, points)
    love.graphics.line(points[i].x, points[i].y, points[j].x, points[j].y)
end