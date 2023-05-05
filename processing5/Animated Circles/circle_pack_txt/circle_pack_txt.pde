
ArrayList<Circle> circles;
ArrayList<PVector> spots;

PImage img;


void setup() {
  size(1500, 500);
  img = loadImage("Skshm.png");
  img.loadPixels();
  
  spots = new ArrayList<PVector>();
  
  for (int x =0; x < img.width; x++) {
    for (int y =0; y < img.height; y++) {
      int index = x+y * img.width;
      color cllr = img.pixels[index];
      float brt = brightness(cllr);
      if(brt>1){
        spots.add(new PVector(x,y));        
      }
    }
  }

  circles = new ArrayList<Circle>();
}

void draw() {
  background(0);

  int count = 0, total = 10;
  int attempts = 0;

  while (count < total) {
    Circle newCirc = newCircle();
    if (newCirc != null) {
      circles.add(newCirc);
      count++;
    }
    attempts++;
    if (attempts > 1000) {
      noLoop();
      println("End");
      break;
    }
  }


  for (Circle c : circles) {
    if (c.growing) {
      if (c.edges()) {
        c.growing = false;
      } else {
        for (Circle other : circles) {
          if (c != other) {
            float d = dist(c.x, c.y, other.x, other.y);
            if (d-2 < c.r+other.r) {
              c.growing = false;
              break;
            }
          }
        }
      }
    }
    c.show();
    c.grow();
  }
}
Circle newCircle() {
  int rand = int(random(0, spots.size()));
  PVector spot = spots.get(rand);
  float x = spot.x;
  float y = spot.y;

  boolean valid = true;
  for (Circle c : circles)
  {
    float d = dist(x, y, c.x, c.y);
    if (d < c.r+2) {
      valid = false;
      break;
    }
  }

  if (valid) {
    return new Circle(x, y);
  } else {
    return null;
  }
}
