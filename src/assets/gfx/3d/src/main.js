import { ViewportManager } from "./viewport";
import { World } from "./world";
import {
  BoxGeometry,
  MeshPhongMaterial,
  Mesh,
  DoubleSide,
  FlatShading,
  TextureLoader,
  SphereGeometry,
  MeshBasicMaterial,
  Vector3,
  Math,
} from "three";

let vpm = new ViewportManager(document.body, window, {
  width: 30,
  height: 30,
});

let world = new World(vpm);

vpm.setCameraPosition({ x: -100, y: 100, z: 100 });

const loader = new TextureLoader();
const tex = loader.load("./src/tex/blitball_face.png");

var material = new MeshBasicMaterial({ map: tex });

const sphere = new Mesh(new SphereGeometry(5, 32, 32), material);
sphere.position.set(0, 0, 0);
//sphere.rotation.set(Math.degToRad(0), Math.degToRad(0), Math.degToRad(0));
world.addToScene(sphere);

/*const cube = new Mesh(new BoxGeometry(10, 10, 10), material);
cube.position.set(0, 0, 0);
cube.rotation.set(0, 0, 0);
world.addToScene(cube);*/

let v = 45 / 2;
let r = -150;
let f = 0;

const getFrame = () => {
  const gl = vpm.renderer.getContext();
  const pixels = new Uint8Array(
    gl.drawingBufferWidth * gl.drawingBufferHeight * 4
  );
  gl.readPixels(
    0,
    0,
    gl.drawingBufferWidth,
    gl.drawingBufferHeight,
    gl.RGBA,
    gl.UNSIGNED_BYTE,
    pixels
  );
  //console.log(pixels);
  for (let i = 0; i < pixels.length; i += 4) {
    if (pixels[i] > 0) {
      console.log("hit");
    }
  }
};

let x = setInterval(() => {
  sphere.rotation.set(Math.degToRad(r), Math.degToRad(0), Math.degToRad(0));
  if (r > 90) {
    clearInterval(x);
  }
  getFrame();
  //console.log(pixels);
  r = r + 4;
  f = v + v;
}, 1000 / 10);

vpm.registerRenderCallback(() => {});
