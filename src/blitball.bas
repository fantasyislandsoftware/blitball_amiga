Set Buffer 1000

BUILD_RESOURCES = 1

IMAGE_COUNT = 45
IMAGE_SIZE = 30

MAP_D = 10
MAP_H = 2
MAP_SCREEN_X = 140
MAP_SCREEN_Y = 0
Dim map(MAP_D, MAP_H, MAP_D, 2)

REM [i], [x, y, z, imageIndex]
dim actor(5, 7)

actor_count = 1

actor(0, 0) = 1
actor(0, 1) = 0
actor(0, 2) = 1
actor(0, 3) = 0
actor(0, 4) = 0
actor(0, 5) = 0
actor(0, 6) = 3

rem actor(1, 0) = 4
rem actor(1, 1) = 0
rem actor(1, 2) = 4
rem actor(1, 3) = 3

rem actor(2, 0) = 5
rem actor(2, 1) = 0
rem actor(2, 2) = 4
rem actor(2, 3) = 3

rem actor(3, 0) = 6
rem actor(3, 1) = 0
rem actor(3, 2) = 4
rem actor(3, 3) = 3

rem actor(4, 0) = 7
rem actor(4, 1) = 0
rem actor(4, 2) = 4
rem actor(4, 3) = 3

KEY_N = 17
KEY_S = 33
KEY_W = 32
KEY_E = 34

Dim image_mask(IMAGE_COUNT, 9, 2)

PATH_ROOT$ = "dh1:"
PATH_ASSETS$ = PATH_ROOT$ + "assets/"
PATH_GFX$ = PATH_ASSETS$ + "gfx/"
PATH_DATA$ = PATH_ASSETS$ + "data/"

Procedure _INIT_IMAGE_MASKS
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
    SHARED image_mask(), IMAGE_COUNT, PATH_DATA$
    open out 2, PATH_DATA$ + "masks.dat"
    for n = 0 to IMAGE_COUNT - 1
        for p = 0 to 7
            for c = 0 to 1
                print #2, image_mask(n, p, c)
            next c
        next p
    next n
    close 2
End Proc

Procedure _LOAD_IMAGE_MASKS
    SHARED image_mask(), IMAGE_COUNT, PATH_DATA$
    open in 2, PATH_DATA$ + "masks.dat"
    for n = 0 to IMAGE_COUNT - 1
        for p = 0 to 7
            for c = 0 to 1
                input #2, image_mask(n, p, c)
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

Procedure _BUILD_GFX
    SHARED PATH_GFX$, PATH_DATA$, IMAGE_COUNT, IMAGE_SIZE
    Load Iff PATH_GFX$ + "images.iff",0
    Screen Hide 0
    x = 1
    xx = 0
    y = 1
    i = 1
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
    save PATH_DATA$ + "images.abk", 1
End Proc

Procedure _BUILD_MASKS
    SHARED IMAGE_COUNT, IMAGE_SIZE, PATH_GFX$
    _INIT_IMAGE_MASKS
    Load Iff PATH_GFX$ + "masks.iff", 0
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

Procedure _LOAD_RESOURCES
    SHARED PATH_DATA$
    load PATH_DATA$ + "images.abk", 1
    _LOAD_IMAGE_MASKS
End Proc

Procedure _INIT_MAP
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

Procedure _INIT_SCREEN

    SHARED IMAGE_SIZE

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
    priority on
    hide

End Proc

Procedure _TEST_GFX
    SHARED IMAGE_COUNT, IMAGE_SIZE
    i = 1
    x = 0
    xx = 0
    y = 0
    For n = 0 to IMAGE_COUNT - 1
        Paste Bob x, y, i
        i = i + 1
        x = x + IMAGE_SIZE
        xx = xx + 1
        if (xx = 9)
            xx = 0
            x = 0
            y = y + IMAGE_SIZE
        EndIf
    Next n
End Proc

Procedure _ISO_TO_X [ gx, gy, gz, px, py, pz, ox ]
    grid = (gx * 14) - (gz * 14) + (px * 2) - (pz * 2)
    xx = grid + ox 
End Proc[xx]

Procedure _ISO_TO_Y [ gx, gy, gz, px, py, pz, oy ]
    grid = (gx * 7) - (gy * 17) + (gz * 7) + (px * 1) - (py * 1) + (pz * 1)
    yy = grid + oy
End Proc[yy]

Procedure _RENDER_MAP
    SHARED map(), MAP_D, MAP_H, MAP_SCREEN_X, MAP_SCREEN_Y
    For z = 0 To MAP_D - 1
        For y = 0 To MAP_H - 1
            For x = 0 To MAP_D - 1
                t = map(x, y, z, 0)
                If (t > 0)
                    _ISO_TO_X[x, y, z, 0, 0, 0, MAP_SCREEN_X]
                    xx = param
                    _ISO_TO_Y[x, y, z, 0, 0, 0, MAP_SCREEN_Y]
                    yy = param
                    Paste Bob xx, yy, t
                EndIf
            Next x
        Next y
    Next z
End Proc

Procedure _POLY [i, x, y]
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

Procedure _RENDER_ACTORS
    SHARED actor(), actor_count, MAP_SCREEN_X, MAP_SCREEN_Y, IMAGE_SIZE, IMAGE_COUNT

    For n = 0 To actor_count - 1

        gx = actor(n, 0)
        gy = actor(n, 1)
        gz = actor(n, 2)
        px = actor(n, 3)
        py = actor(n, 4)
        pz = actor(n, 5)
        i = actor(n, 6)

        _ISO_TO_X[gx, gy, gz, px, py, pz, MAP_SCREEN_X]
        xx = param
        _ISO_TO_Y[gx, gy, gz, px, py, pz, MAP_SCREEN_Y]
        yy = param

        _ISO_TO_X[gx, gy, gz, px, py, pz, MAP_SCREEN_X]
        xxx = param
        _ISO_TO_Y[gx, gy, gz, px, py, pz, MAP_SCREEN_Y]
        yyy = param

        Bob n + 1, xx, yy, i
        rem Bob n + 8, xxx, yyy, 11

    Next n

End Proc

Procedure _DETECT_WALL [x, y, z]
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

Procedure _CONTROL_PLAYER

    SHARED map(), actor(), KEY_N, KEY_S, KEY_E, KEY_W

    gx = actor(0, 0)
    gy = actor(0, 1)
    gz = actor(0, 2)
    px = actor(0, 3)
    py = actor(0, 4)
    pz = actor(0, 5)


    _DETECT_WALL[gx, gy, gz - 1]
    n = param
    _DETECT_WALL[gx, gy, gz + 1]
    s = param
    _DETECT_WALL[gx + 1, gy, gz]
    e = param
    _DETECT_WALL[gx - 1, gy, gz]
    w = param

    If (Key State(KEY_N) and n = 0) Then pz = pz - 1
    If (Key State(KEY_S) and s = 0) Then pz = pz + 1
    If (Key State(KEY_W) and w = 0) Then px = px - 1
    If (Key State(KEY_E) and e = 0) Then px = px + 1

    if (px > 6)
        gx = gx + 1
        px = 0
    end if

    if (pz > 6)
        gz = gz + 1
        pz = 0
    end if

    if (px < -6)
        gx = gx - 1
        px = 0
    end if

    if (pz < -6)
        gz = gz - 1
        pz = 0
    end if
    
    actor(0, 0) = gx
    actor(0, 1) = gy
    actor(0, 2) = gz
    actor(0, 3) = px
    actor(0, 4) = py
    actor(0, 5) = pz

End Proc

cls 0

If BUILD_RESOURCES = 1
    _BUILD_GFX
    _BUILD_MASKS
Else
    _LOAD_RESOURCES
End If

_INIT_MAP
_INIT_SCREEN
rem _TEST_GFX
_RENDER_MAP

While Key State(69) = false
    _CONTROL_PLAYER
    _RENDER_ACTORS
    Wait Vbl
Wend

wait key