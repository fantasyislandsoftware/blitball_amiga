Rem ** Blitball [AMIGA Version] **

Set Buffer 1000

Rem Dev
BUILD_RESOURCES = 1

Rem Image
IMAGE_SIZE = 30
IMAGE_COUNT = 64
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
dim actor(actor_max, 12)

ACTOR_PLAYER = 0

ACTOR_C_GX = 0
ACTOR_C_GY = 1
ACTOR_C_GZ = 2
ACTOR_D_GX = 3
ACTOR_D_GY = 4
ACTOR_D_GZ = 5

ACTOR_PX = 6
ACTOR_PY = 7
ACTOR_PZ = 8

ACTOR_DIR = 9
ACTOR_MOVING = 10
ACTOR_I = 11

global actor_count, actor()
global ACTOR_PLAYER
global ACTOR_C_GX, ACTOR_C_GY, ACTOR_C_GZ
global ACTOR_D_GX, ACTOR_D_GY, ACTOR_D_GZ
global ACTOR_PX, ACTOR_PY, ACTOR_PZ
global ACTOR_DIR, ACTOR_MOVING, ACTOR_I

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

_ADD_ACTOR [4, 0, 4, 0, 0, 0, 33]

While Key State(69) = false
    _CONTROL_PLAYER
    _UPDATE_ACTORS
    wait vbl
    rem wait 5
Wend

Rem ** File I/O **

Procedure _IMPORT_IMAGES
    
    Rem ** 30x30 Images **
    Load Iff PATH_GFX$ + "30x30.iff",0
    rem screen Hide 0
    
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

    rem Screen Close 0
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

    actor(actor_count, ACTOR_C_GX) = gx
    actor(actor_count, ACTOR_C_GY) = gy
    actor(actor_count, ACTOR_C_GZ) = gz

    actor(actor_count, ACTOR_D_GX) = gx
    actor(actor_count, ACTOR_D_GY) = gy
    actor(actor_count, ACTOR_D_GZ) = gz

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

            c_gx = actor(n, ACTOR_C_GX)
            c_gy = actor(n, ACTOR_C_GY)
            c_gz = actor(n, ACTOR_C_GZ)

            d_gx = actor(n, ACTOR_D_GX)
            d_gy = actor(n, ACTOR_D_GY)
            d_gz = actor(n, ACTOR_D_GZ)

            px = actor(n, ACTOR_PX)
            py = actor(n, ACTOR_PY)
            pz = actor(n, ACTOR_PZ)

            d = actor(n, ACTOR_DIR)
            m = actor(n, ACTOR_MOVING)
            i = actor(n, ACTOR_I)

            Rem ** NORTH **
            if (d_gz < c_gz)
                pz = pz - 1
                if (pz < -6)
                    c_gz = c_gz - 1
                    pz = 0
                    m = 0
                end if
            end if

            Rem ** SOUTH **
            if (d_gz > c_gz)
                pz = pz + 1
                if (pz > 6)
                    c_gz = c_gz + 1
                    pz = 0
                    m = 0
                end if
            end if

            Rem ** WEST **
            if (d_gx < c_gx)
                px = px - 1
                if (px < -6)
                    c_gx = c_gx - 1
                    px = 0
                    m = 0
                end if
            end if

            Rem ** EAST **
            if (d_gx > c_gx)
                px = px + 1
                if (px > 6)
                    c_gx = c_gx + 1
                    px = 0
                    m = 0
                end if
            end if

             _ISO_TO_X[c_gx, c_gy, c_gz, px, py, pz, MAP_SCREEN_X]
            xx = param
            _ISO_TO_Y[c_gx, c_gy, c_gz, px, py, pz, MAP_SCREEN_Y]
            yy = param

            _pi = i

            if (d = EAST)
                _pi = i + px
            end if

            if (d = WEST)
                _pi = i + -px + 24
            end if

            if (d = NORTH)
                _pi = i + -pz + 16
            end if

            if (d = SOUTH)
                _pi = i + pz + 8
            end if

            bob n, xx, yy, _pi

            actor(n, ACTOR_C_GX) = c_gx
            actor(n, ACTOR_C_GY) = c_gy
            actor(n, ACTOR_C_GZ) = c_gz
            actor(n, ACTOR_D_GX) = d_gx
            actor(n, ACTOR_D_GY) = d_gy
            actor(n, ACTOR_D_GZ) = d_gz
            actor(n, ACTOR_PX) = px
            actor(n, ACTOR_PY) = py
            actor(n, ACTOR_PZ) = pz
            actor(n, ACTOR_DIR) = d
            actor(n, ACTOR_MOVING) = m
            actor(n, ACTOR_I) = i

        Next n
    End If
End Proc

Procedure _IS_STATIC [n]
    result = 0
    if (actor(n, ACTOR_C_GX) = actor(n, ACTOR_D_GX) and actor(n, ACTOR_C_GZ) = actor(n, ACTOR_D_GZ))
        result = 1
    end if
End Proc[result]

Procedure _CONTROL_PLAYER

    _IS_STATIC[ACTOR_PLAYER]
    static = param

    if (static = 1)

        if (Key State(KEY_N) and actor(ACTOR_PLAYER, ACTOR_MOVING) = 0)
            actor(ACTOR_PLAYER, ACTOR_D_GZ) = actor(ACTOR_PLAYER, ACTOR_C_GZ) - 1
            actor(ACTOR_PLAYER, ACTOR_MOVING) = 1
            actor(ACTOR_PLAYER, ACTOR_DIR) = NORTH
        end if

        if (Key State(KEY_S) and actor(ACTOR_PLAYER, ACTOR_MOVING) = 0)
            actor(ACTOR_PLAYER, ACTOR_D_GZ) = actor(ACTOR_PLAYER, ACTOR_C_GZ) + 1
            actor(ACTOR_PLAYER, ACTOR_MOVING) = 1
            actor(ACTOR_PLAYER, ACTOR_DIR) = SOUTH
        end if

        if (Key State(KEY_E) and actor(ACTOR_PLAYER, ACTOR_MOVING) = 0)
            actor(ACTOR_PLAYER, ACTOR_D_GX) = actor(ACTOR_PLAYER, ACTOR_C_GX) + 1
            actor(ACTOR_PLAYER, ACTOR_MOVING) = 1
            actor(ACTOR_PLAYER, ACTOR_DIR) = EAST
        end if

        if (Key State(KEY_W) and actor(ACTOR_PLAYER, ACTOR_MOVING) = 0)
            actor(ACTOR_PLAYER, ACTOR_D_GX) = actor(ACTOR_PLAYER, ACTOR_C_GX) - 1
            actor(ACTOR_PLAYER, ACTOR_MOVING) = 1
            actor(ACTOR_PLAYER, ACTOR_DIR) = WEST
        end if

    end if

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