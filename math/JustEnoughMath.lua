JEM = {}

function JEM.calculateDistance(x1, y1, z1, x2, y2, z2)
    return (((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2)) ^ 0.5
end

function JEM.indexCheck(a)
    a.x = a.x or a[1]
    a.y = a.y or a[2]
    a.z = a.z or a[3]

    return a
end

function JEM.dotProduct(a, b)
    a = JEM.indexCheck(a)
    b = JEM.indexCheck(b)

    return a.x * b.x + a.y * b.y + a.z * b.z
end

function JEM.crossProduct(a,b)
    a = JEM.indexCheck(a)
    b = JEM.indexCheck(b)

    return {
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    }
end

function JEM.sub(a,b)
    a = JEM.indexCheck(a)
    b = JEM.indexCheck(b)

    return {
        a.x - b.x,
        a.y - b.y,
        a.z - b.z
    }
end

function JEM.WorldPoint(point, index, XYZ)
    return {
        XYZ.x + point.metadata.posX,
        XYZ.y + point.metadata.posY,
        XYZ.z + point.metadata.posZ,
    }
end

return JEM