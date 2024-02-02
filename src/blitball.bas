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

procedure tile[x,y,z]
    if (x < 0 or y < 0 or z < 0 or x > 7 or y > 2 or z > 7) then t = 0 else t = map(x,y,z)
end proc[t]

procedure idle[p]
    for i = 0 to p
    next i
end proc

do

    for i = 0 to actorCount - 2

        iso2x[actor3Dx(i),actor3Dy(i),actor3Dz(i)]
        xx = param
        iso2y[actor3Dx(i),actor3Dy(i),actor3Dz(i)]
        yy = param

        screen 1
        cls 0
        put block blkEntPtr,0,0

        tile[actor3Dx(i),actor3Dy(i),actor3Dz(i)+1]
        t = param
        if t > 1 then put block t,-18,9
        tile[actor3Dx(i)+1,actor3Dy(i),actor3Dz(i)+1]
        t = param
        if t > 1 then put block t,0,18
        tile[actor3Dx(i)+2,actor3Dy(i),actor3Dz(i)+1]
        t = param
        if t > 1 then put block t,18,27

        rem tile[actor3Dx(i),actor3Dy(i)+1,actor3Dz(i)+1]
        rem t = param
        rem if t > 1 then put block t,-18,-9
        rem tile[actor3Dx(i)+1,actor3Dy(i)+1,actor3Dz(i)+1]
        rem t = param
        rem if t > 1 then put block t,0,0
        rem tile[actor3Dx(i)+2,actor3Dy(i)+1,actor3Dz(i)+1]
        rem t = param
        rem if t > 1 then put block t,18,9
        rem tile[actor3Dx(i)+3,actor3Dy(i)+1,actor3Dz(i)+1]
        rem t = param
        rem if t > 1 then put block t,36,18

        dx = -18
        dy = 9
        for iy = 0 to 2
            for ix = 0 to 3
                tile[actor3Dx(i)+ix,actor3Dy(i)+iy,actor3Dz(i)+1]
                t = param
                if t > 1 then put block t,dx,dy
                dx = dx + 18
                dy = dy + 9
            next ix
            dx = -18
            dy = -9
        next iy

        get bob 1,0,0 to tw,th
        screen 0
        bob i,xx,yy,actorType(i)+1

        rem locate 0,0
        rem print t

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