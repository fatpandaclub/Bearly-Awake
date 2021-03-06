int angle, panelW, panelH, triangleW, triangleH, panelCountX, panelCountY, hue, x, y; 
boolean increment = true;

ArrayList<Panel> panels;


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

