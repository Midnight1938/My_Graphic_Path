let img;
let screen;
let glitchShader;

function preload() {
  img = loadImage('data/Skshm.png');
  glitchShader = loadShader('shader.vert', 'shader.frag');
}

function setup() {
  createCanvas(windowWidth, windowHeight, WEBGL);
  screen = createGraphics(width, height);

  screen.background(20);
  screen.stroke(255);
  screen.strokeWeight(4);

  shader(glitchShader);
  glitchShader.setUniform('texture', img);
}

function draw() {
  image(screen, -width/2, -height/2, width, height);

  if(mouseIsPressed){
    screen.line(mouseX, mouseY, pmouseX, pmouseY);
  }

  drawScreen();
}

function drawScreen() {
  glitchShader.setUniform('noise', getNoiseValue());

  rect(-width/2, -height/2, width, height);
}

function getNoiseValue() {
  let v = noise(millis()/100);
  const cutoff = 0.5;
  if (v<cutoff) {
    return 0;
  }
  v = pow((v-cutoff)/(1-cutoff), 2);

  return v;
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}
