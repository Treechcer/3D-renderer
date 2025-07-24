JEM = {}

function JEM.calculateDistance(x1, y1, z1, x2, y2, z2)
    return (((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2)) ^ 0.5
end

function JEM.dotProduct(a, b)
    return a.x * b.x + a.y * b.x + a.z * b.z
end

function JEM.WorldPoint(points, index, key)
    return {
        points[key][index][1] + points[key].metadata.posX,
        points[key][index][2] + points[key].metadata.posY,
        points[key][index][3] + points[key].metadata.posZ,
    }
end

return JEM