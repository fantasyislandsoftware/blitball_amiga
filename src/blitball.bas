dim map(8, 3, 8)
global map()
global tw,th
global mx,my
global blkCounter
global blkEntPtr

blkCounter = 0
blkEntPtr = 0

mx = 140
my = 50

tw = 38
th = 37

rem define actors
actorCount = 2
dim actorType(actorCount)
dim actor3Dgx(actorCount)
dim actor3Dgy(actorCount)
dim actor3Dgz(actorCount)
dim actor3Dpx(actorCount)
dim actor3Dpy(actorCount)
dim actor3Dpz(actorCount)

rem Player
actorType(0) = 0
actor3Dgx(0) = 1
actor3Dgy(0) = 0
actor3Dgz(0) = 6
actor3Dpx(0) = 0
actor3Dpy(0) = 0
actor3Dpz(0) = 0

rem Test enemy
actorType(1) = 1
actor3Dgx(1) = 4
actor3Dgy(1) = 0
actor3Dgz(1) = 4
actor3Dpx(1) = 4
actor3Dpy(1) = 0
actor3Dpz(1) = 4

${includes}

screen open 1,64,64,32,lowres
cls 0
screen hide 1

screen hide 0

initMapData

ldTiles
ldEntities
ldEnts

cls 0


drwMap

double buffer
priority on

screen show 0

procedure idle[p]
    for i = 0 to p
    next i
end proc

do

    for i = 0 to actorCount - 2

        iso2x[actor3Dgx(i), actor3Dgy(i), actor3Dgz(i), actor3Dpx(i), actor3Dpy(i), actor3Dpz(i), mx]
        xx = param
        iso2y[actor3Dgx(i), actor3Dgy(i), actor3Dgz(i), actor3Dpx(i), actor3Dpy(i), actor3Dpz(i), my]
        yy = param

        screen 1
        cls 0
        put block blkEntPtr,0,0

        drwClpMap[actor3Dgx(i), actor3Dgy(i), actor3Dgz(i), actor3Dpx(i), actor3Dpy(i), actor3Dpz(i)]

        get bob 1,0,0 to tw,th
        screen 0
        bob i,xx,yy,actorType(i)+1

    next i

    rem ** Keyboard input **
    if key state(6) = true then actor3Dpx(0) = actor3Dpx(0) - 2
    if key state(7) = true then actor3Dpx(0) = actor3Dpx(0) + 2
    if key state(8) = true then actor3Dpz(0) = actor3Dpz(0) + 2
    if key state(9) = true then actor3Dpz(0) = actor3Dpz(0) - 2

    rem **
    if (actor3Dpx(0) < -8)
        actor3Dpx(0) = 8
        actor3Dgx(0) = actor3Dgx(0) - 1
    end if
    if (actor3Dpx(0) > 8)
        actor3Dpx(0) = -8
        actor3Dgx(0) = actor3Dgx(0) + 1
    end if
    if (actor3Dpz(0) < -8)
        actor3Dpz(0) = 8
        actor3Dgz(0) = actor3Dgz(0) - 1
    end if
    if (actor3Dpz(0) > 8)
        actor3Dpz(0) = -8
        actor3Dgz(0) = actor3Dgz(0) + 1
    end if

    rem **
    if (actor3Dgx(0) = 0 and actor3Dpx(0) < 0)
        actor3Dpx(0) = 0
        actor3Dgx(0) = 0
    end if
    if (actor3Dgx(0) = 7 and actor3Dpx(0) > 0)
        actor3Dpx(0) = 0
        actor3Dgx(0) = 7
    end if
    if (actor3Dgz(0) = 0 and actor3Dpz(0) < 0)
        actor3Dpz(0) = 0
        actor3Dgz(0) = 0
    end if
    if (actor3Dgz(0) = 7 and actor3Dpz(0) > 0)
        actor3Dpz(0) = 7
        actor3Dpz(0) = 0
    end if
    

    rem locate 0,0
    rem print actor3Dgx(0)
    rem print actor3Dpx(0)

    rem idle[100000]
    wait vbl

loop