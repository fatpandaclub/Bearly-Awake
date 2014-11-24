/**
 * Geometry 
 * by Marius Watz. 
 * 
 * Using sin/cos lookup tables, blends colors, and draws a series of 
 * rotating arcs on the screen.
 */

import processing.video.*;
import processing.pdf.*;

// Trig lookup tables borrowed from Toxi; cryptic but effective.
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION=1.0;
int SINCOS_LENGTH= int((360.0/SINCOS_PRECISION));

// System data
boolean dosave=false;
int num;
float pt[];
int style[];

PGraphics pg; 
Capture cam;
boolean once = false;

void setup() {
  size(1920, 1080, P3D);
  background(255);

  // Fill the tables
  sinLUT=new float[SINCOS_LENGTH];
  cosLUT=new float[SINCOS_LENGTH];
  for (int i = 0; i < SINCOS_LENGTH; i++) {
    sinLUT[i]= (float)Math.sin(i*DEG_TO_RAD*SINCOS_PRECISION);
    cosLUT[i]= (float)Math.cos(i*DEG_TO_RAD*SINCOS_PRECISION);
  }

  num = 150;
  pt = new float[6*num]; // rotx, roty, deg, rad, w, speed
  style = new int[2*num]; // color, render style

  // Set up arc shapes
  int index=0;
  float prob;
  for (int i=0; i<num; i++) {
    pt[index++] = random(PI*2); // Random X axis rotation
    pt[index++] = random(PI*2); // Random Y axis rotation

    pt[index++] = random(60, 80); // Short to quarter-circle arcs
    if (random(100)>90) pt[index]=(int)random(8, 27)*10;

    pt[index++] = int(random(2, 50)*5); // Radius. Space them out nicely

    pt[index++] = random(4, 32); // Width of band
    if (random(100)>90) pt[index]=random(40, 60); // Width of band

    pt[index++] = radians(random(5, 30))/5; // Speed of rotation

    // get colors
    prob = random(100);
    if (prob<30) style[i*2]=colorBlended(random(1), random(255), 0, random(100), random(255), 0, 0, random(210));
    else if (prob<70) style[i*2]=colorBlended(random(1), 0, random(153), random(255), random(170), random(225), random(255), random(210));
    else if (prob<90) style[i*2]=colorBlended(random(1), random(200), random(255), 0, random(150), random(255), 0, random(210));
    else style[i*2]=color(255, 255, 255, 220);

    if (prob<50) style[i*2]=colorBlended(random(1), random(200), random(255), 0, random(50), random(120), 0, random(210));
    else if (prob<90) style[i*2]=colorBlended(random(1), random(255), random(100), 0, random(255), random(255), 0, random(210));
    else style[i*2]=color(255, 255, 255, 220);

    style[i*2+1]=(int)(random(100))%3;
  }

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[1]);
    //beginRecord(PDF, "line.pdf"); 
    cam.start();
  }

  pg = createGraphics(640, 480, P3D);
}

void draw() {

  background(0);

  int index=0;
  translate(width/2, height/2, 0);
  rotateX(PI/6);
  rotateY(PI/6);

  for (int i = 0; i < num; i++) {
    pushMatrix();

    rotateX(pt[index++]);
    rotateY(pt[index++]);

    if (style[i*2+1]==0) {
      stroke(style[i*2]);
      noFill();
      strokeWeight(1);
      arcLine(0, 0, pt[index++], pt[index++], pt[index++]);
    } else if (style[i*2+1]==1) {
      fill(style[i*2]);
      noStroke();
      arcLineBars(0, 0, pt[index++], pt[index++], pt[index++]);
    } else {
      fill(style[i*2]);
      noStroke();
      arc(0, 0, pt[index++], pt[index++], pt[index++]);
    }

    // increase rotation
    pt[index-5]+=pt[index]/10;
    pt[index-4]+=pt[index++]/20;

    popMatrix();
  }

  if (cam.available() == true) {
    cam.read();
  }
  pg.beginDraw();
  pg.image(cam, 0, 0);
  pg.endDraw();
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);

  if ( once == false && millis() > 20000) {
    pg.save("ProtoPic/button/picture.jpg"); 
    println("Picture Taken");
    once = true;
  }
}


// Get blend of two colors
int colorBlended(float fract, 
float r, float g, float b, 
float r2, float g2, float b2, float a) {

  r2 = (r2 - r);
  g2 = (g2 - g);
  b2 = (b2 - b);
  return color(r + r2 * fract, g + g2 * fract, b + b2 * fract, a);
}


// Draw arc line
void arcLine(float x, float y, float deg, float rad, float w) {
  int a=(int)(min (deg/SINCOS_PRECISION, SINCOS_LENGTH-1));
  int numlines=(int)(w/2);

  for (int j=0; j<numlines; j++) {
    beginShape();
    for (int i=0; i<a; i++) { 
      vertex(cosLUT[i]*rad+x, sinLUT[i]*rad+y);
    }
    endShape();
    rad += 2;
  }
}

// Draw arc line with bars
void arcLineBars(float x, float y, float deg, float rad, float w) {
  int a = int((min (deg/SINCOS_PRECISION, SINCOS_LENGTH-1)));
  a /= 4;

  beginShape(QUADS);
  for (int i=0; i<a; i+=4) {
    vertex(cosLUT[i]*(rad)+x, sinLUT[i]*(rad)+y);
    vertex(cosLUT[i]*(rad+w)+x, sinLUT[i]*(rad+w)+y);
    vertex(cosLUT[i+2]*(rad+w)+x, sinLUT[i+2]*(rad+w)+y);
    vertex(cosLUT[i+2]*(rad)+x, sinLUT[i+2]*(rad)+y);
  }
  endShape();
}

// Draw solid arc
void arc(float x, float y, float deg, float rad, float w) {
  int a = int(min (deg/SINCOS_PRECISION, SINCOS_LENGTH-1));
  beginShape(QUAD_STRIP);
  for (int i = 0; i < a; i++) {
    vertex(cosLUT[i]*(rad)+x, sinLUT[i]*(rad)+y);
    vertex(cosLUT[i]*(rad+w)+x, sinLUT[i]*(rad+w)+y);
  }
  endShape();
}

