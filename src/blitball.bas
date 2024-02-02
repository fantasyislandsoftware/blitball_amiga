dim map(8, 3, 8)
global map()
global tw,th
global mx,my
global blkCounter
global blkEntPtr

blkCounter = 0
blkEntPtr = 0

mx = 140
my = 0

tw = 38
th = 37

rem define actors
actorCount = 2
dim actorType(actorCount)
dim actor3Dx(actorCount)
dim actor3Dy(actorCount)
dim actor3Dz(actorCount)
dim actor2Dx(actorCount)
dim actor2Dy(actorCount)

rem Player
actorType(0) = 0
actor3Dx(0) = 1
actor3Dy(0) = 0
actor3Dz(0) = 1

rem Test enemy
actorType(1) = 1
actor3Dx(1) = 4
actor3Dy(1) = 0
actor3Dz(1) = 4

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

        iso2x[actor3Dx(i),actor3Dy(i),actor3Dz(i),mx]
        xx = param
        iso2y[actor3Dx(i),actor3Dy(i),actor3Dz(i),my]
        yy = param

        screen 1
        cls 0
        put block blkEntPtr,0,0

        drwClpMap[actor3Dx(i),actor3Dy(i),actor3Dz(i)]

        get bob 1,0,0 to tw,th
        screen 0
        bob i,xx,yy,actorType(i)+1

    next i

    if key state(6) = true then actor3Dx(0) = actor3Dx(0) - 1
    if key state(7) = true then actor3Dx(0) = actor3Dx(0) + 1
    if key state(8) = true then actor3Dz(0) = actor3Dz(0) + 1
    if key state(9) = true then actor3Dz(0) = actor3Dz(0) - 1
    if (actor3Dx(0) < 0) then actor3Dx(0) = 0
    if (actor3Dx(0) > 7) then actor3Dx(0) = 7
    if (actor3Dz(0) < 0) then actor3Dz(0) = 0
    if (actor3Dz(0) > 7) then actor3Dz(0) = 7

    idle[200000]
    wait vbl

loop