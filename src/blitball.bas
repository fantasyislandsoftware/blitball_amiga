Rem ** Blitball [AMIGA Version] **

Set Buffer 1000

Rem Dev
BUILD_RESOURCES = 1

Rem Image
IMAGE_SIZE = 30
IMAGE_COUNT = 45
global IMAGE_SIZE, IMAGE_COUNT

Rem Map
MAP_D = 10
MAP_H = 2
MAP_SCREEN_X = 140
MAP_SCREEN_Y = 0
Dim map(MAP_D, MAP_H, MAP_D, 2)
global MAP_D, MAP_H, MAP_SCREEN_X, MAP_SCREEN_Y, map()

REM [i], [gx, gy, gz, px, py, pz, d, imageIndex]
actor_max = 100
actor_count = 0
dim actor(actor_max, 9)
ACTOR_GX = 0
ACTOR_GY = 1
ACTOR_GZ = 2
ACTOR_PX = 3
ACTOR_PY = 4
ACTOR_PZ = 5
ACTOR_DIR = 6
ACTOR_MOVING = 7
ACTOR_I = 8
global actor_count, actor(), ACTOR_GX, ACTOR_GY, ACTOR_GZ, ACTOR_PX, ACTOR_PY, ACTOR_PZ, ACTOR_DIR, ACTOR_MOVING, ACTOR_I

Rem Direction
STATIC = 0
NORTH = 1
SOUTH = 2
EAST = 3
WEST = 4
global STATIC, NORTH, SOUTH, EAST, WEST

Rem Key definitions
KEY_N = 17
KEY_S = 33
KEY_W = 32
KEY_E = 34
global KEY_N, KEY_S, KEY_W, KEY_E

Rem Paths
PATH_ROOT$ = "dh1:"
PATH_ASSETS$ = PATH_ROOT$ + "assets/"
PATH_GFX$ = PATH_ASSETS$ + "gfx/"
PATH_DATA$ = PATH_ASSETS$ + "data/"
global PATH_ROOT$, PATH_ASSETS$, PATH_GFX$, PATH_DATA$

Rem ** Main **

If BUILD_RESOURCES = 1
    _IMPORT_IMAGES
Else
    load PATH_DATA$ + "images.abk", 1
End If

_INIT_MAP
_INIT_SCREEN
_RENDER_MAP

_ADD_ACTOR [4, 0, 4, 0, 0, 0, 2]

While Key State(69) = false
    _CONTROL_PLAYER
    _UPDATE_ACTORS
    wait vbl
Wend

Rem ** File I/O **

Procedure _IMPORT_IMAGES
    
    Rem ** 30x30 Images **
    Load Iff PATH_GFX$ + "30x30.iff",0
    screen Hide 0
    x = 1
    xx = 0
    y = 1
    i = 1
    o = 3
    For n = 0 to IMAGE_COUNT- 1
        Get Bob i, x, y To x + IMAGE_SIZE, y + IMAGE_SIZE
        i = i + 1
        xx = xx + 1
        x = x + IMAGE_SIZE + o
        If (xx = 8)
            xx = 0
            x = 1
            y = y + IMAGE_SIZE + o
        EndIf
    Next n

    Screen Close 0
    save PATH_DATA$ + "images.abk", 1

End Proc

Rem ** Set up **

Procedure _INIT_SCREEN
    Screen Open 0, 320, 256, 16, Lowres
    curs off
    flash Off
    hide
    Cls 0
    double buffer
    autoback 1
    priority on
    get bob palette
End Proc

Rem ** Map **

Procedure _INIT_MAP
    For z = 0 To MAP_D - 1
        For x = 0 to MAP_D - 1
            map(x, 0, z, 0) = 1
            map(x, 0, z, 1) = 0
        Next x
    Next z
End Proc

Procedure _RENDER_MAP
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

Procedure _ISO_TO_X [ gx, gy, gz, px, py, pz, ox ]
    grid = (gx * 14) - (gz * 14) + (px * 2) - (pz * 2)
    xx = grid + ox 
End Proc[xx]

Procedure _ISO_TO_Y [ gx, gy, gz, px, py, pz, oy ]
    grid = (gx * 7) - (gy * 17) + (gz * 7) + (px * 1) - (py * 1) + (pz * 1)
    yy = grid + oy
End Proc[yy]

Procedure _DETECT_WALL [x, y, z]
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

Rem ** Actors **

Procedure _ADD_ACTOR [gx, gy, gz, px, py, pz, i]

    actor(actor_count, ACTOR_GX) = gx
    actor(actor_count, ACTOR_GY) = gy
    actor(actor_count, ACTOR_GZ) = gz
    actor(actor_count, ACTOR_PX) = px
    actor(actor_count, ACTOR_PY) = py
    actor(actor_count, ACTOR_PZ) = pz
    actor(actor_count, ACTOR_DIR) = 0
    actor(actor_count, ACTOR_MOVING) = 0
    actor(actor_count, ACTOR_I) = i
    actor_count = actor_count + 1

    _ISO_TO_X[gx, gy, gz, px, py, pz, MAP_SCREEN_X]
    xx = param
    _ISO_TO_Y[gx, gy, gz, px, py, pz, MAP_SCREEN_Y]
    yy = param

    bob actor_count - 1, xx, yy, i

End Proc

Procedure _UPDATE_ACTORS
    
    if (actor_count > 0)
        For n = 0 To actor_count - 1
            gx = actor(n, ACTOR_GX)
            gy = actor(n, ACTOR_GY)
            gz = actor(n, ACTOR_GZ)
            px = actor(n, ACTOR_PX)
            py = actor(n, ACTOR_PY)
            pz = actor(n, ACTOR_PZ)
            d = actor(n, ACTOR_DIR)
            m = actor(n, ACTOR_MOVING)
            i = actor(n, ACTOR_I)

            if d = NORTH
                actor(n, ACTOR_PZ) = actor(n, ACTOR_PZ) - 1
                if actor(n, ACTOR_PZ) < -6
                    actor(n, ACTOR_PZ) = 0
                    actor(n, ACTOR_GZ) = actor(n, ACTOR_GZ) - 1
                    actor(n, ACTOR_DIR) = STATIC
                    actor(n, ACTOR_MOVING) = 0
                end if
            end if

            if d = SOUTH
                actor(n, ACTOR_PZ) = actor(n, ACTOR_PZ) + 1
                if actor(n, ACTOR_PZ) > 6
                    actor(n, ACTOR_PZ) = 0
                    actor(n, ACTOR_GZ) = actor(n, ACTOR_GZ) + 1
                    actor(n, ACTOR_DIR) = STATIC
                    actor(n, ACTOR_MOVING) = 0
                end if
            end if

            if d = EAST
                actor(n, ACTOR_PX) = actor(n, ACTOR_PX) + 1
                if actor(n, ACTOR_PX) > 6
                    actor(n, ACTOR_PX) = 0
                    actor(n, ACTOR_GX) = actor(n, ACTOR_GX) + 1
                    actor(n, ACTOR_DIR) = STATIC
                    actor(n, ACTOR_MOVING) = 0
                end if
            end if

            if d = WEST
                actor(n, ACTOR_PX) = actor(n, ACTOR_PX) - 1
                if actor(n, ACTOR_PX) < -6
                    actor(n, ACTOR_PX) = 0
                    actor(n, ACTOR_GX) = actor(n, ACTOR_GX) - 1
                    actor(n, ACTOR_DIR) = STATIC
                    actor(n, ACTOR_MOVING) = 0
                end if
            end if

            _ISO_TO_X[gx, gy, gz, px, py, pz, MAP_SCREEN_X]
            xx = param
            _ISO_TO_Y[gx, gy, gz, px, py, pz, MAP_SCREEN_Y]
            yy = param
            bob n, xx, yy, i

        Next n
    End If
End Proc

Procedure _CONTROL_PLAYER

    if (actor(0, ACTOR_MOVING) = 0)

        if (Key State(KEY_N))
            actor(0, ACTOR_DIR) = NORTH
            actor(0, ACTOR_MOVING) = 1
        end if

        if (Key State(KEY_S))
            actor(0, ACTOR_DIR) = SOUTH
            actor(0, ACTOR_MOVING) = 1
        end if

        if (Key State(KEY_E))
            actor(0, ACTOR_DIR) = EAST
            actor(0, ACTOR_MOVING) = 1
        end if

        if (Key State(KEY_W))
            actor(0, ACTOR_DIR) = WEST
            actor(0, ACTOR_MOVING) = 1
        end if

    end if

End Proc

Procedure _CONTROL_PLAYER2

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

    _ISO_TO_X[gx, gy, gz, px, py, pz, MAP_SCREEN_X]
    xx = param
    _ISO_TO_Y[gx, gy, gz, px, py, pz, MAP_SCREEN_Y]
    yy = param

    bob 0, xx, yy, 2

End Proc

Procedure _RENDER_ACTORS

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

        bob n, xx, yy, i

    Next n

End Proc

Rem ** Test **

Procedure _TEST_GFX
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