
// Not over 200 each, else out of screen experience
float r1 = 200;
float r2 = 90;

// In KG
float m1 = 20;
float m2 = 23;

float ang1=PI/2;
float ang2=PI/2+2;
float ang1_vel = 0;
float ang2_vel = 0;

float G=1; // Actual constant 6.673 * 10^-11 Or 9.8/(60*60)

float px2 = -1, py2 = -1;

float centerx, centery;

PGraphics canvas;

void setup(){
  size(800,800);
  centerx = width/2; centery = height/3;
  canvas = createGraphics(width,height);
  canvas.beginDraw();
  canvas.background(0);
  canvas.endDraw();
}

void draw(){
  float num1,num2,num3,num4, den;
  
  // Formula 1
  num1 = -G * (2 * m1 + m2) * sin(ang1);
  num2 = -m2 * G * sin(ang1 - 2*ang2);
  num3 = -2 * sin(ang1 - ang2)* m2;
  num4 = ang2_vel * ang2_vel * r2 + ang1_vel * ang1_vel * r1 * cos(ang1-ang2);
  den = r1*(2*m1+m2-m2*cos(2*ang1-2*ang2));
  float Angle1_acc = (num1+num2+num3*num4) / den;
  
  // Formula 2
  num1 = 2 * sin(ang1 - ang2);
  num2 = (ang1_vel*ang1_vel*r1*(m1+m2));
  num3 = G * (m1+m2) * cos(ang1);
  num4 = ang2_vel*ang2_vel*r2*m2*cos(ang1-ang2);
  den = r2*(2*m1+m2-m2*cos(2*ang1-2*ang2));
  
  float Angle2_acc = (num1*(num2+num3+num4))/den;

  //background(255);
  image(canvas,0,0);
  stroke(255);
  strokeWeight(2);
  
  translate(centerx,centery);
 
  float x1= r1 * sin(ang1);
  float y1= r1 * cos(ang1);
  
  float x2= x1 + r2 * sin(ang2);
  float y2= y1 + r2 * cos(ang2);
  
  // Top Pendulum
  line(0,0,x1,y1);
  fill(255);
  ellipse(x1,y1,m1,m1);
  // Bottom Pendulum
  line(x1,y1,x2,y2);
  fill(255);
  ellipse(x2,y2,m2,m2);

  ang1_vel += Angle1_acc;
  ang2_vel += Angle2_acc;
  ang1+=ang1_vel;
  ang2+=ang2_vel;
  
  // Beware of the circling
  ang1_vel *= 0.9989;
  ang2_vel *= 0.9989;

  
  canvas.beginDraw();
  canvas.translate(centerx,centery);
  canvas.strokeWeight(1);
  canvas.stroke(255);
  if (frameCount > 1){
  canvas.line(px2,py2,x2,y2);
  }
  canvas.endDraw();
  
  // Line state save
  px2=x2;
  py2=y2;
}
