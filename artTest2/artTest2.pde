import processing.video.*;
import processing.pdf.*;


int angle, panelW, panelH, triangleW, triangleH, panelCountX, panelCountY, hue, x, y; 
boolean increment = true;

ArrayList<Panel> panels;

PGraphics pg; 

Capture cam;

void setup() {
  size(1920, 1080);
  
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

  pg = createGraphics(640,480); 
}

void draw() {
  
  if (cam.available() == true) {
    cam.read();
  }
  pg.beginDraw();
  pg.image(cam, 0, 0);
  pg.endDraw();
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}

void keyPressed() {
  //endRecord();  
  pg.save("SharePic/picture.jpg"); 
  println("hej");
}

/*
void setup() {
  size(800, 800, P3D);
  colorMode(HSB);
  lights();
  noStroke();

  panelW = 400;
  panelH = 400;
  triangleW = 30; 
  triangleH = 25;
  hue = 0;
  panelCountX = 9;
  panelCountY = 9;

  camera(1200, -800, 1200, 800, 400, 0, 0, 1, 0);

  frameRate(1);
  panels = new ArrayList<Panel>();
}

void draw() {
  hue = 0;
  fill(255);
  background(0);
  sphere(30);
  stroke(0, 0, 0);
  line(0, 0, 0, 100, 0, 0);
  stroke(125, 0, 0);
  line(0, 0, 0, 0, 100, 0);
  stroke(255, 0, 0);
  line(0, 0, 0, 0, 0, 100);
  noStroke();

  for (int j = 0; j < panelCountY; j++) { 
    x = panelW*j;
    y = panelH*j;

    pushMatrix();
    translate(x, y);
    for (int i = 0; i < panelCountX; i++) {

      pushMatrix();
     
      if (i%3 == 0) {
        translate(x, 0);
        //rotateY(HALF_PI);
      } else if (i%3 == 1) {
        translate(x, 0);
        rotateY(HALF_PI);
      } else if (i%3 == 2) {
        rotateX(HALF_PI);
      }
      panels.add(new Panel());
      Panel panel = panels.get(panels.size()-1);
      panel.display();
      popMatrix();
    }
    popMatrix();
  }
  
  
}
*/
