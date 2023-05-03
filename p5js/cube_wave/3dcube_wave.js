let angle = 0;
let wdth = 40;
let yRotationAngle;

let rate = 0.9;
let speedy = 0.06;
let frames = 60;

function setup() {
  //  createCanvas(400, 400, WEBGL);
  createCanvas(windowWidth / 1.01, windowHeight / 1.01, WEBGL);
  yRotationAngle = atan(1 / sqrt(2));
}

function draw() {
  background(0);
  //ortho(-600, 600, -1000, 1000, 0, 10000);
  ortho(
    -(width / rate),
    width / rate,
    -(height / rate),
    height / rate,
    0,
    10000
  );

  //  ortho(left, right, bottom, top, near, far)

  //? Set the view
  rotateY(yRotationAngle);
  rotateX(-QUARTER_PI);

  let locX = mouseX - width / 2;
  let locY = mouseY - height / 2;
  pointLight(255, 255, 255, locX, locY, 50);

  //  rotateX(angle * 0.25);

  //  normalMaterial();
  ambientLight(240);
  ambientMaterial(186, 194, 222);
  //  specularMaterial(186, 194, 222);
  for (let z = 0; z < height; z += wdth) {
    for (let x = 0; x < width; x += wdth) {
      push();
      let diss = dist(x, z, width / 2, height / 2);
      let offset = map(diss, 0, width / 2, -PI, PI);
      let ang = angle + offset;
      let h = floor(map(sin(ang), -1, 1, 50, 500));
      translate(x - width / 2, 0, z - height / 2);
      box(wdth, h, wdth);
      pop();
    }
  }

  angle -= TWO_PI / frames;
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
  ortho(
    -(width / rate),
    width / rate,
    -(height / rate),
    height / rate,
    0,
    10000
  );
}

function keyPressed() {
  if (key == " ") {
    const options = {
      units: "frames",
      delay: 0
    }
    saveGif("beesandbombs.gif", frames, options);
  }
}
