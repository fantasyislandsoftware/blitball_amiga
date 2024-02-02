procedure initMapData 
    for z = 0 to 7
        for y = 0 to 2
        for x = 0 to 7
            map(x, y, z) = 0
        next x
        next y
    next z
    for z = 0 to 7
        for x = 0 to 7
        map(x, 0, z) = 1
        next x
    next z
    for x = 0 to 7
        map(x, 0, 0) = 2
        map(x, 1, 0) = 2

        map(x, 0, 7) = 2
        map(x, 1, 7) = 2
    next x
end proc

procedure iso2x[x,y,z]
    xx = x * 18 - z * 18 + mx
end proc[xx]

procedure iso2y[x,y,z]
    yy = x * 9 - y * 18 + z * 9 + my
end proc[yy]

procedure drwMap    
    for z = 0 to 7
        for y = 0 to 3
            for x = 0 to 7
                t = map(x, y, z)
                if (t > 0)
                    iso2x[x,y,z]
                    xx = param
                    iso2y[x,y,z]
                    yy = param
                    put block t, xx, yy
                end if
            next x
        next y
    next z
end proc