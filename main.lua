love = require("love")

function love.load()

    matrixMath = require("math.matrixMath")
    JEM = require("math.JustEnoughMath")
    player = require("game.properties.player")
    renderer = require("game.render.renderer")
    meshes = require("game.render.meshes")
    points = require("game.properties.points")

    generatePoints = require("game.properties.generatePoints")
    generatePoints.mapGen(10, 10, 10)

    points = points.points

    love.mouse.setRelativeMode(true)
    prevMouseX, prevMouseY = love.mouse.getPosition()

    _G.types = {
        block = {
            {-1,-1,1},
            {1,-1,1},
            {1,1,1},
            {-1,1,1},
            {-1,-1,-1},
            {1,-1,-1},
            {1,1,-1},
            {-1,1,-1}
        },
        halfTop = {
            {-1,-1,1},
            {1,-1,1},
            {1,0,1},
            {-1,0,1},
            {-1,-1,-1},
            {1,-1,-1},
            {1,0,-1},
            {-1,0,-1}
        },
        halfBot = {
            {-1,0,1},
            {1,0,1},
            {1,1,1},
            {-1,1,1},
            {-1,0,-1},
            {1,0,-1},
            {1,1,-1},
            {-1,1,-1}
        },
        slope = {
            {-1,-1,1},
            {1,1,1},
            --{1,1,1},
            {-1,1,1},
            {-1,-1,-1},
            --{1,1,-1},
            {1,1,-1},
            {-1,1,-1}
        }
    }

    faces = {
        block = {
            {1, 2, 3, 4}, -- front
            {5, 6, 7, 8}, -- back
            {1, 5, 8, 4}, -- left
            {2, 6, 7, 3}, -- right
            {4, 3, 7, 8}, -- top
            {1, 2, 6, 5}, -- bottom
        },
        halfTop = {
            {1, 2, 3, 4}, -- front
            {5, 6, 7, 8}, -- back
            {1, 5, 8, 4}, -- left
            {2, 6, 7, 3}, -- right
            {4, 3, 7, 8}, -- top
            {1, 2, 6, 5}, -- bottom
        },
        halfBot = {
            {1, 2, 3, 4}, -- front
            {5, 6, 7, 8}, -- back
            {1, 5, 8, 4}, -- left
            {2, 6, 7, 3}, -- right
            {4, 3, 7, 8}, -- top
            {1, 2, 6, 5}, -- bottom
        },
        slope = {
            {1, 3, 2},        -- přední trojúhelník
            {4, 6, 5},        -- zadní trojúhelník
            {1, 4, 6, 3},     -- levá strana
            {2, 5, 4, 1},     -- pravá strana
            {3, 6, 5, 2},     -- šikmá horní plocha
            {1, 2, 5, 4},     -- spodní plocha
        }
    }

    scale = 100

    width, height = love.graphics.getDimensions()

    pos = {width / 2, height / 2}
end

function love.draw()
    local facesToDraw = {}
    matrixMath.calculateProjections()

    for key, value in pairs(points) do
        local projectedPoints = {}
        if value.type == "block" or value.type == "halfTop" or value.type == "halfBot" or value.type == "slope" then
            for i = 1, #_G.types[value.type] do
                local rotMatrixX = matrixMath.getXRotationMatrix(value.metadata.rotX)
                local rotMatrixY = matrixMath.getYRotationMatrix(value.metadata.rotY)
                local rotMatrixZ = matrixMath.getZRotationMatrix(value.metadata.rotZ)

                local localPoint = _G.types[value.type][i]

                local rotate = matrixMath.matrixMultiply(rotMatrixX, localPoint)
                rotate = matrixMath.matrixMultiply(rotMatrixY, rotate)
                rotate = matrixMath.matrixMultiply(rotMatrixZ, rotate)

                local WorldPoint = JEM.WorldPoint(value, i, {x = rotate[1], y = rotate[2], z = rotate[3]})
                local relativePos = {
                    WorldPoint[1] - player.camera.posX,
                    WorldPoint[2] - player.camera.posY,
                    WorldPoint[3] - player.camera.posZ
                }

                local cameraRot = matrixMath.matrixMultiply(matrixMath.yRotationAngle, relativePos)
                cameraRot = matrixMath.matrixMultiply(matrixMath.xRotationAngle, cameraRot)
                cameraRot = matrixMath.matrixMultiply(matrixMath.zRotationAngle, cameraRot)

                local projected = matrixMath.matrixMultiply(matrixMath.projectedMatrix, cameraRot)
                projected[1] = projected[1] / cameraRot[3]
                projected[2] = projected[2] / cameraRot[3]

                if cameraRot[3] > 0 then
                    local x = projected[1] * scale + pos[1]
                    local y = projected[2] * scale + pos[2]
                    projectedPoints[i] = {x = x, y = y, z = cameraRot[3]}
                else
                    projectedPoints[i] = nil
                end

            end

            local col = value.metadata.color

            for _, face in ipairs(_G.faces[value.type]) do
                local verts = {}
                local sumZ = 0
                local count = 0
                local faceIsVisible = true

                for _, i in ipairs(face) do
                    local v = projectedPoints[i]
                    if not v then
                        faceIsVisible = false
                        break
                    end

                    table.insert(verts, {v.x, v.y, 0, 0, col[1], col[2], col[3], col[4]})
                    sumZ = sumZ + v.z
                    count = count + 1
                end

                if faceIsVisible and count > 0 then
                    local avgZ = sumZ / count
                    table.insert(facesToDraw, {verts = verts, avgZ = avgZ})
                end
            end
        end
    end

    table.sort(facesToDraw, function(a, b)
        return a.avgZ > b.avgZ
    end)

    for _, faceData in ipairs(facesToDraw) do
        local mesh = love.graphics.newMesh({{"VertexPosition", "float", 2}, {"VertexTexCoord", "float", 2}, {"VertexColor", "byte", 4}}, faceData.verts, "fan", "static")
        love.graphics.draw(mesh)
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