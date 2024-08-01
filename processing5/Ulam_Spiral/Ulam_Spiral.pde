int x, y;
int px, py;
int step = 1;
int stepSize = 1;
int numSteps = 1;
int state = 0;
int turnCounter = 1;
int totalSteps;

boolean isPrime(int n) {
  if (n < 2) {
    return false;
  }
  for (float i = 2; i <= sqrt(n); i++) {
    if (n % i == 0) {
      return false;
    }
  }
  return true;
}

void setup() {
  size(1920, 1920);

  int cols = width / stepSize;
  int rows = height / stepSize;
  totalSteps = cols * rows;
  x = width / 2;
  y = height / 2;
  px = x;
  py = y;
  background(0);
  
  while(step <= totalSteps){
    drawing();
  };
  save("primeSpiral.png");
}


void drawing() {
  fill(255);
  stroke(200);
  if (isPrime(step)){
    stroke(255);
    rect(x, y, stepSize, stepSize);
  }
  //line(x, y, px, py);
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
}
