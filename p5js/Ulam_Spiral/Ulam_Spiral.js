let x, y;
let px, py;
let step = 1;
let stepSize = 5;
let numSteps = 1;
let state = 0;
let turnCounter = 1;
let totalSteps;

function setup() {
  boxedAr = min(window.innerWidth, window.innerHeight);
  createCanvas(boxedAr, boxedAr);

  const cols = width / stepSize;
  const rows = height / stepSize;
  totalSteps = cols * rows;
  x = width / 2;
  y = height / 2;
  px = x;
  py = y;
  background(0);
}

function isPrime(n) {
  if (n < 2) {
    return false;
  }
  for (let i = 2; i <= sqrt(n); i++) {
    if (n % i == 0) {
      return false;
    }
  }
  return true;
}

function draw() {
  fill(255);
  stroke(200);
  if (isPrime(step)){
    stroke(255);
    circle(x, y, stepSize * 0.5);
  }
  line(x, y, px, py);
  px = x; py = y;

  switch (state) {
    case 0:
      x += stepSize;
      break;
    case 1:
      y -= stepSize;
      break;
    case 2:
      x -= stepSize;
      break;
    case 3:
      y += stepSize;
      break;
  }

  if (step % numSteps == 0) {
    state = (state + 1) % 4;
    turnCounter++;
    if (turnCounter % 2 == 0) {
      numSteps++;
    }
  }
  step++;
  if (step >= totalSteps) {
    noLoop();
  }
}
