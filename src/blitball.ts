import { amos } from "dreamfactory";

let map: any = undefined;
amos.dim({ var: map, values: [8, 4, 8] });
interface Global {
  map: Array<any>;
}

function ldTiles() {
  amos.loadIff("assets/tiles.iff", 0);
  let width = 40;
  let height = 40;
  let _tileCount = 14;
  let x = 1;
  let y = 1;
  let o = 3;
  let gridWidth = 7;
  let gridX = 0;

  for (let i = 0; i < _tileCount; i++) {
    if (gridX > 6) {
      gridX = 0;
      x = 1;
      y = y + height + o;
    }
    amos.getBob(0, i + 1, x, y, "to", x + width, y + height);
    x = x + width + o;

    gridX = gridX + 1;
  }
}

function drwMap() {
  amos.cls(0);

  let px = 140;
  let py = 50;

  for (let z = 0; z < 8; z++) {
    for (let y = 0; y < 3; y++) {
      for (let x = 0; x < 8; x++) {
        amos.pasteBob(x * 18 - z * 18 + px, x * 9 - y * 18 + z * 9 + py, 9);
      }
    }
  }
}

function initMapData() {
  for (let z = 0; z < 8; z++) {
    for (let y = 0; y < 3; y++) {
      for (let x = 0; x < 8; x++) {
        amos.set(map([1, 1, 1]), 0);
      }
    }
  }
}

ldTiles();
initMapData();
drwMap();

amos.do();
amos.loop();