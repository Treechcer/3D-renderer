JEM = {}

function JEM.calculateDistance(x1, y1, z1, x2, y2, z2)
    return (((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2)) ^ 0.5
end

function JEM.dotProduct(a, b)
    return a.x * b.x + a.y * b.x + a.z * b.z
end

function JEM.WorldPoint(point, index, XYZ)
    return {
        XYZ.x + point.metadata.posX,
        XYZ.y + point.metadata.posY,
        XYZ.z + point.metadata.posZ,
    }
end

return JEM