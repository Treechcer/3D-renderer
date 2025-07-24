love = require("love")

function love.load()
    love.mouse.setRelativeMode(true)
    prevMouseX, prevMouseY = love.mouse.getPosition()

    points = {
        {
            metadata = {
                posX = 0,
                posY = 0,
                posZ = 0,
            },
            {-1,-1,1},
            {1,-1,1},
            {1,1,1},
            {-1,1,1},
            {-1,-1,-1},
            {1,-1,-1},
            {1,1,-1},
            {-1,1,-1}
        },
        {
            metadata = {
                posX = 2,
                posY = 0,
                posZ = 0,
            },
            {-1,-1,1},
            {1,-1,1},
            {1,1,1},
            {-1,1,1},
            {-1,-1,-1},
            {1,-1,-1},
            {1,1,-1},
            {-1,1,-1}
        }
    }

    projectedMatrix = {
        {1,0,0},
        {0,1,0},
        {0,0,0}
    }

    scale = 100

    width, height = love.graphics.getDimensions()

    pos = {width / 2, height / 2}

    camera = {
        posX = 0,
        posY = 0,
        posZ = -5,
        angle = 0,

        speed = 10,

        yaw = 0, -- horizontal angle
        pitch = 0, -- vertical angle
        sensitivity = 0.002 -- sensitivity of mouse
    }
end

function love.draw()
    zRotationAngle = {
        {math.cos(camera.angle), -math.sin(camera.angle), 0},
        {math.sin(camera.angle), math.cos(camera.angle), 0},
        {0,0,1}
    }

    local yRotationAngle = {
        {math.cos(camera.yaw), 0, math.sin(camera.yaw)},
        {0, 1, 0},
        {-math.sin(camera.yaw), 0, math.cos(camera.yaw)},
    }

    local xRotationAngle = {
        {1, 0, 0},
        {0, math.cos(camera.pitch), -math.sin(camera.pitch)},
        {0, math.sin(camera.pitch), math.cos(camera.pitch)},
    }
    for key, value in pairs(points) do
        projectedPoints = {}

        for i = 1, #points[key] do

            local WorldPoint = {
                points[key][i][1] + points[key].metadata.posX,
                points[key][i][2] + points[key].metadata.posY,
                points[key][i][3] + points[key].metadata.posZ
            }

            local relativePos ={
                WorldPoint[1] - camera.posX,
                WorldPoint[2] - camera.posY,
                WorldPoint[3] - camera.posZ
            }

            local rotate = matrixMultiply(yRotationAngle, relativePos)
            rotate = matrixMultiply(xRotationAngle, rotate)

            local projected = matrixMultiply(projectedMatrix, rotate)

            projected[1] = projected[1] / rotate[3]
            projected[2] = projected[2] / rotate[3]

            local x = projected[1] * scale + pos[1]
            local y = projected[2] * scale + pos[2]

            if rotate[3] > 0 then
                love.graphics.circle("fill", x, y, math.min(2500 / calculateDistance(camera.posX, camera.posY, camera.posZ, x, y, rotate[3]), 5))

                projectedPoints[i] = {x = x, y = y}
            else
                projectedPoints[i] = nil
            end
        end

        for i = 1, 4 do
            connectPoint(i, (i % 4) + 1, projectedPoints)
            connectPoint(i + 4, (i % 4) + 5, projectedPoints)
            connectPoint(i, i + 4, projectedPoints)
        end
    end
end

function love.update(dt)
    local forward = 0
    local right = 0

    if love.keyboard.isDown("w") then
        forward = 1
    elseif love.keyboard.isDown("s") then
        forward = -1
    end

    if love.keyboard.isDown("a") then
        right = -1
    elseif love.keyboard.isDown("d") then
        right = 1
    end

    camera.posX = camera.posX + (math.sin(camera.yaw) * forward + math.sin(camera.yaw + math.pi/2) * right) * camera.speed * dt
    camera.posZ = camera.posZ + (math.cos(camera.yaw) * forward + math.cos(camera.yaw + math.pi/2) * right) * camera.speed * dt

    if love.keyboard.isDown("q") then
        love.event.quit()
    end
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
    if points[i] and points[j] then
        love.graphics.line(points[i].x, points[i].y, points[j].x, points[j].y)
    end
end

function calculateDistance(x1, y1, z1, x2, y2, z2)
    return (((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2)) ^ 0.5
end

function love.mousemoved(dx, dy, x, y, istouch)
    camera.yaw = camera.yaw + x * camera.sensitivity
    camera.pitch = camera.pitch - y * camera.sensitivity
end