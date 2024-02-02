procedure ldTiles
  load iff "assets/gfx/tiles.iff",0
  screen hide 0
   x = 1
   y = 1
   o = 3
   gridWidth = 7
   gridX = 0
   _tileCount = 14
  for i = 0 to _tileCount
    if (gridX > 6) 
      gridX = 0
      x = 1
      y = y + th + o
    end if
    get block i+1, x, y, tw, th, 1
    x = x + tw + o
    gridX = gridX + 1
    blkCounter = i
  next i
end proc

procedure ldEntities
    load iff "assets/gfx/ent.iff",0
    screen hide 0
    ew = 38
    eh = 37
    x = 1
    y = 1
    o = 3
    gridWidth = 7
    gridX = 0
    _entCount = 14
  for i = 0 to _entCount
    if (gridX > 6) 
      gridX = 0
      x = 1
      y = y + eh + o
    end if
    get bob i+1, x, y to x+ew, y+eh
    x = x + ew + o
    gridX = gridX + 1
  next i
end proc

procedure ldEnts
  blkEntPtr = blkCounter
  load iff "assets/gfx/ent.iff",0
  screen hide 0
  ew = 38
  eh = 37
  x = 1
  y = 1
  o = 3
  gridWidth = 7
  gridX = 0
  _entCount = 14
  for i = 0 to _entCount
    if (gridX > 6) 
      gridX = 0
      x = 1
      y = y + eh + o
    end if
    get block blkEntPtr+i, x, y, tw, th, 1
    rem get bob i+1, x, y to x+ew, y+eh
    x = x + ew + o
    gridX = gridX + 1
  next i
end proc