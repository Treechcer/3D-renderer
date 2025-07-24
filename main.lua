love = require("love")

function love.load()

    matrixMath = require("math.matrixMath")
    JEM = require("math.JustEnoughMath")
    player = require("game.properties.player")
    renderer = require("game.render.renderer")
    meshes = require("game.render.meshes")

    love.mouse.setRelativeMode(true)
    prevMouseX, prevMouseY = love.mouse.getPosition()

    points = {
        {
            metadata = {
                posX = 0,
                posY = 0,
                posZ = 0,
                color = {1,0,0,1},
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
                color = {0,1,1,1},
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

    faces = {
        {1, 2, 3, 4}, -- front
        {5, 6, 7, 8}, -- back
        {1, 5, 8, 4}, -- left
        {2, 6, 7, 3}, -- right
        {4, 3, 7, 8}, -- top
        {1, 2, 6, 5}  -- bottom
    }

    scale = 100

    width, height = love.graphics.getDimensions()

    pos = {width / 2, height / 2}
end

function love.draw()
    for key, value in pairs(points) do
        matrixMath.calculateProjections()
        local projectedPoints = {}

        for i = 1, 8 do
            local WorldPoint = JEM.WorldPoint(points, i, key)

            local relativePos = {
                WorldPoint[1] - player.camera.posX,
                WorldPoint[2] - player.camera.posY,
                WorldPoint[3] - player.camera.posZ
            }

            local rotate = matrixMath.matrixMultiply(matrixMath.yRotationAngle, relativePos)
            rotate = matrixMath.matrixMultiply(matrixMath.xRotationAngle, rotate)
            rotate = matrixMath.matrixMultiply(matrixMath.zRotationAngle, rotate)

            local projected = matrixMath.matrixMultiply(matrixMath.projectedMatrix, rotate)

            projected[1] = projected[1] / rotate[3]
            projected[2] = projected[2] / rotate[3]

            local x = projected[1] * scale + pos[1]
            local y = projected[2] * scale + pos[2]

            if rotate[3] > 0 then
                projectedPoints[i] = {x = x, y = y, z = rotate[3]}
            else
                projectedPoints[i] = nil
            end
        end

        local sortedTable = {}

        for index0, value0 in ipairs(projectedPoints) do
            table.insert(sortedTable, {distance = JEM.calculateDistance(player.camera.posX, player.camera.posY, player.camera.posZ, projectedPoints[index0].x, projectedPoints[index0].y, projectedPoints[index0].z),
                x = projectedPoints[index0].x,
                y = projectedPoints[index0].y,
                z = projectedPoints[index0].z
            })
        end

        table.sort(sortedTable, function(a, b) return a.distance > b.distance end)

        local col = points[key].metadata.color

        for _, face in ipairs(faces) do
            local verts = {}

            local faceIsVisible = true
            for _, i in ipairs(face) do
                if not sortedTable[i] then
                    faceIsVisible = false
                    break
                end

                local v = sortedTable[i]
                table.insert(verts, {v.x, v.y, v.z, 0, col[1], col[2], col[3], col[4]})
            end

            if faceIsVisible then
                meshes.block1:setVertices(verts)
                love.graphics.draw(meshes.block1)
            end
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

    player.camera.posX = player.camera.posX + (math.sin(player.camera.yaw) * forward + math.sin(player.camera.yaw + math.pi/2) * right) * player.camera.speed * dt
    player.camera.posZ = player.camera.posZ + (math.cos(player.camera.yaw) * forward + math.cos(player.camera.yaw + math.pi/2) * right) * player.camera.speed * dt

    if love.keyboard.isDown("space") then
        player.camera.posY = player.camera.posY - player.camera.speed * dt
    elseif love.keyboard.isDown("lshift") then
        player.camera.posY = player.camera.posY + player.camera.speed * dt
    end

    if love.keyboard.isDown("q") then
        love.event.quit()
    end
end

function connectPoint(i, j, points)
    if points[i] and points[j] then
        love.graphics.line(points[i].x, points[i].y, points[j].x, points[j].y)
    end
end

function love.mousemoved(dx, dy, x, y, istouch)
    player.camera.yaw = player.camera.yaw + x * player.camera.sensitivity
    player.camera.pitch = player.camera.pitch - y * player.camera.sensitivity
end