let angle = 0;
let wdth = 24;

function setup() {
  createCanvas(windowWidth / 1.01, windowHeight / 1.01, "noRescale");
}

function draw() {
  background(0);
  translate(width / 2, height / 2);
  rectMode(CENTER);

  let offset = 0;
  for (let x = 0; x < width; x += wdth) {
    let ang = angle + offset;
    let h = map(sin(ang), -1, 1, 0, 100);
    fill(255);
    rect(x - width / 2 + wdth / 2, 0, wdth - 2, h);
    offset += 0.1;
  }

  angle += 0.1;
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}