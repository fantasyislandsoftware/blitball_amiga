procedure clearMapData
    for z = 0 to 7
        for y = 0 to 2
            for x = 0 to 7
                map(x, y, z) = 0
            next x
        next y
    next z
end proc

procedure basicFloor
    for z = 0 to 7
        for x = 0 to 7
        map(x, 0, z) = 1
        next x
    next z
end proc

procedure southWall
    for y = 0 to 2
        for x = 0 to 7
            map(x, y, 7) = 2
        next x
    next y
    map(4, 0, 7) = 1
    map(4, 1, 7) = 0
end proc

procedure westWall
    for y = 0 to 1
        for z = 0 to 7
            map(7, y, z) = 2
        next z
    next y
end proc

procedure initMapData
    clearMapData
    basicFloor
    southWall
    westWall
end proc

procedure iso2x[x,y,z,ox]
    xx = x * 18 - z * 18 + ox
end proc[xx]

procedure iso2y[x,y,z,oy]
    yy = x * 9 - y * 18 + z * 9 + oy
end proc[yy]

procedure drwMap    
    for z = 0 to 7
        for y = 0 to 3
            for x = 0 to 7
                t = map(x, y, z)
                if (t > 0)
                    iso2x[x,y,z,mx]
                    xx = param
                    iso2y[x,y,z,my]
                    yy = param
                    put block t, xx, yy
                end if
            next x
        next y
    next z
end proc

procedure tile[x,y,z]
    if (x < 0 or y < 0 or z < 0 or x > 7 or y > 2 or z > 7) then t = 0 else t = map(x,y,z)
end proc[t]

procedure drwClpMap[px,py,pz]
    for z = 0 to 4
        for y = 0 to 2
            for x = 0 to 4
                tile[x + px, y + py, z + pz]
                t = param
                if (t > 1)
                    iso2x[x, y, z, 0]
                    xx = param
                    iso2y[x, y, z, 0]
                    yy = param
                    put block t, xx, yy
                end if
            next x
        next y
    next z
end proc