Set Buffer 1000

IMAGE_COUNT = 45
IMAGE_SIZE = 30

MAP_D = 10
MAP_H = 2
MAP_SCREEN_X = 140
MAP_SCREEN_Y = 0
Dim map(MAP_D, MAP_H, MAP_D, 2)

px = 1
py = 0
pz = 1

Dim image_mask(IMAGE_COUNT, 9, 2)

Procedure INIT_IMAGE_MASKS
    SHARED image_mask(), IMAGE_COUNT
    for n = 0 to IMAGE_COUNT - 1
        for p = 0 to 7
            for c = 0 to 1
                image_mask(n, p, c) = -1
            next c
        next p
    next n
End Proc

Procedure _SAVE_IMAGE_MASKS
    SHARED image_mask(), IMAGE_COUNT
    open out 2, "dh1:assets/masks.dat"
    for n = 0 to IMAGE_COUNT - 1
        for p = 0 to 7
            for c = 0 to 1
                print #2, image_mask(n, p, c)
            next c
        next p
    next n
    close 2
End Proc

Procedure _GET_IMAGE_MASK [i, sx, sy]
    SHARED image_mask(), IMAGE_SIZE
    c = 1
    for y = sy to sy + IMAGE_SIZE - 1
        for x = sx to sx + IMAGE_SIZE - 1
            p = point(x, y)
            rem plot x, y, 1
            for n = 24 to 31
                if (p = n)
                    image_mask(i, 0, 0) = c
                    image_mask(i, n - 23, 0) = x - sx
                    image_mask(i, n - 23, 1) = y - sy
                    c = c + 1
                end if
            next n
        next x
    next y
End Proc

Procedure LD_GFX
    SHARED IMAGE_COUNT, IMAGE_SIZE
    Load Iff "dh1:assets/gfx/images.iff",0
    Screen Hide 0
    x = 1
    xx = 0
    y = 1
    i = 1
    s = 32
    o = 3
    For n = 0 to IMAGE_COUNT - 1
        Get Bob i, x, y To x + IMAGE_SIZE, y + IMAGE_SIZE
        i = i + 1
        xx = xx + 1
        x = x + IMAGE_SIZE + o
        If (xx = 9)
            xx = 0
            x = 1
            y = y + IMAGE_SIZE + o
        EndIf
    Next n
    Screen Close 0
End Proc

Procedure LD_MASKS
    SHARED IMAGE_COUNT, IMAGE_SIZE
    INIT_IMAGE_MASKS
    Load Iff "dh1:assets/gfx/masks.iff",0
    Screen Hide 0
    x = 1
    xx = 0
    y = 1
    i = 0
    o = 3
    For n = 0 to IMAGE_COUNT - 1
        _GET_IMAGE_MASK[i, x, y]
        i = i + 1
        xx = xx + 1
        x = x + IMAGE_SIZE + o
        If (xx = 9)
            xx = 0
            x = 1
            y = y + IMAGE_SIZE + o
        EndIf
    Next n
    Screen Close 0
    _SAVE_IMAGE_MASKS
End Proc

Procedure INIT_MAP
    SHARED map(), MAP_D
    For z = 0 To MAP_D - 1
        For x = 0 to MAP_D - 1
            map(x, 0, z, 0) = 1
            map(x, 0, z, 1) = 0
        Next x
    Next z
    for x = 0 to MAP_D - 1
        map(x, 0, 9, 0) = 2
        map(x, 0, 9, 1) = 1
    Next x
    For z = 0 To MAP_D - 1
        map(9, 0, z, 0) = 2
        map(9, 0, z, 1) = 1
    Next z
End Proc

Procedure INIT_SCREEN
    Screen Open 1, 32, 32, 32, Lowres
    Flash Off
    Get Bob Palette
    Cls 0

    Screen Open 0, 320, 256, 32, Lowres
    Flash Off
    Get Bob Palette
    Cls 0
    Double Buffer
    Autoback 1
End Proc

Procedure TEST_GFX
    SHARED IMAGE_COUNT
    i = 1
    x = 0
    xx = 0
    y = 0
    For n = 0 to IMAGE_COUNT - 1
        Paste Bob x, y, i
        i = i + 1
        x = x + 32
        xx = xx + 1
        if (xx = 9)
            xx = 0
            x = 0
            y = y + 32
        EndIf
    Next n
End Proc

Procedure IsoToX [ gx, gy, gz, ox ]
    grid = (gx * 14) - (gz * 14)
    xx = grid + ox 
End Proc[xx]

Procedure IsoToY [ gx, gy, gz, oy ]
    grid = (gx * 7) - (gy * 17) + (gz * 7)
    yy = grid + oy
End Proc[yy]

Procedure RENDER_MAP
    SHARED map(), MAP_D, MAP_H, MAP_SCREEN_X, MAP_SCREEN_Y
    For z = 0 To MAP_D - 1
        For y = 0 To MAP_H - 1
            For x = 0 To MAP_D - 1
                t = map(x, y, z, 0)
                If (t > 0)
                    IsoToX[x, y, z, MAP_SCREEN_X]
                    xx = param
                    IsoToY[x, y, z, MAP_SCREEN_Y]
                    yy = param
                    Paste Bob xx, yy, t
                EndIf
            Next x
        Next y
    Next z
End Proc

Procedure POLY [i, x, y]
    SHARED image_mask()
    c = image_mask(i, 0, 0)
    x1 = image_mask(i, 1, 0) + x
    y1 = image_mask(i, 1, 1) + y
    x2 = image_mask(i, 2, 0) + x
    y2 = image_mask(i, 2, 1) + y
    x3 = image_mask(i, 3, 0) + x
    y3 = image_mask(i, 3, 1) + y
    x4 = image_mask(i, 4, 0) + x
    y4 = image_mask(i, 4, 1) + y
    x5 = image_mask(i, 5, 0) + x
    y5 = image_mask(i, 5, 1) + y
    x6 = image_mask(i, 6, 0) + x
    y6 = image_mask(i, 6, 1) + y
    if c = 4 then polygon x1, y1 to x2, y2 to x3, y3 to x4, y4 to x1, y1
    if c = 6 then polygon x1, y1 to x2, y2 to x3, y3 to x4, y4 to x5, y5 to x6, y6 to x1, y1
End Proc

Procedure RENDER_PLAYER
    SHARED px, py, pz, MAP_SCREEN_X, MAP_SCREEN_Y, image_mask(), map()

    Screen 1
    Paste Bob 0, 0, 3

    Ink 0

    rem t = map(px + 1, py, pz)
    rem if (t = 2)
    rem     IsoToX[1, 0, 0, 0]
    rem     xx = param
    rem     IsoToY[1, 0, 0, 0]
    rem     yy = param
    rem     POLY [1, xx, yy]
    rem end if

    rem t = map(px + 1, py, pz + 1)
    rem if (t = 2)
    rem     IsoToX[1, 0, 1, 0]
    rem     xx = param
    rem     IsoToY[1, 0, 1, 0]
    rem     yy = param
    rem     POLY [1, xx, yy]
    rem end if

    rem t = map(px, py, pz + 1)
    rem if (t = 2)
    rem     IsoToX[0, 0, 1, 0]
    rem     xx = param
    rem     IsoToY[0, 0, 1, 0]
    rem     yy = param
    rem     POLY [1, xx, yy]
    rem end if

    POLY [0, 0, 0]

    Get Bob 10, 0, 0 To 32, 32
    Screen 0

    IsoToX[px, py, pz, MAP_SCREEN_X]
    xx = param
    IsoToY[px, py, pz, MAP_SCREEN_Y]
    yy = param

    Bob 1, xx, yy, 10
End Proc

Procedure DETECT_WALL [x, y, z]
    SHARED map()
    result = 0
    If (x < 0 or x > 9 or z < 0 or z > 9)
        result = 1
    EndIf
    If (result = 0)
        If (map(x, y, z, 1) = 1)
            result = 1
        EndIf
    End If
End Proc[result]

Procedure CONTROL_PLAYER
    SHARED px, py, pz, map()
    DETECT_WALL[px - 1, py, pz]
    nw = param
    DETECT_WALL[px + 1, py, pz]
    sw = param
    DETECT_WALL[px, py, pz - 1]
    ew = param
    DETECT_WALL[px, py, pz + 1]
    ww = param
    If (Key State(33) and sw = 0)
        px = px + 1
    EndIf
    If (Key State(17) and nw = 0)
        px = px - 1
    EndIf
    If (Key State(32) and ww = 0)
        pz = pz + 1
    EndIf
    If (Key State(34) and ew = 0)
        pz = pz - 1
    EndIf
End Proc

LD_GFX
LD_MASKS
INIT_MAP
INIT_SCREEN
rem TEST_GFX
RENDER_MAP


While Key State(69) = false
    CONTROL_PLAYER
    RENDER_PLAYER
    Wait Vbl
Wend

wait key