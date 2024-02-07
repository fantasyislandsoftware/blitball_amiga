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
    for y = 0 to 1
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

procedure iso2x[gx,gy,gz,px,py,pz,ox]
    grid = (gx * 18) - (gz * 18)
    xx = grid + px - pz + ox
end proc[xx]

procedure iso2y[gx,gy,gz,px,py,pz,oy]
    grid = (gx * 9) - (gy * 18) + (gz * 9)
    yy = grid + (px / 2) + (pz / 2) + oy
end proc[yy]

procedure drwMap    
    for z = 0 to 7
        for y = 0 to 3
            for x = 0 to 7
                t = map(x, y, z)
                if (t > 0)
                    iso2x[x,y,z,0,0,0,mx]
                    xx = param
                    iso2y[x,y,z,0,0,0,my]
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

procedure drwClpMap[gx,gy,gz,px,py,pz]
    ox = 0
    if (px < 0) then ox = -1
    oz = 0
    if (pz < 0) then oz = -1
    for z = oz to 4
        for y = 0 to 2
            for x = ox to 4
                tile[x + gx, y + gy, z + gz]
                t = param
                if (t > 1)
                    iso2x[x, y, z, -px, -py, -pz, 0]
                    xx = param
                    iso2y[x, y, z, -px, -py, -pz, 0]
                    yy = param
                    put block t, xx, yy
                end if
            next x
        next y
    next z
end proc