int angle, planeW, planeH, triangleW, triangleH, hue, planeCount, x, y; 
boolean increment = true;

void setup() {
  size(800, 800, P3D);
  colorMode(HSB);
  noStroke();

  planeW = 400;
  planeH = 400;
  triangleW = 30; 
  triangleH = 25;
  hue = 0;
  planeCount = 4;
  
  camera(1200, -400, 1200, 0, 400, 0, 0, 1, 0);
  
  sphere(30);
}

void draw() {
  hue = 0;
  for (int j = 0) 
  for (int x = 0; x < planeCount; x++) {
    translate(x,0);
    rotateY(HALF_PI*i%2);
    for (y = 0; y <= planeW; y += triangleH) {
      for (x = 0; x <= planeH; x += triangleW) {
        
        fill(hue, 255, 255);
        triangle(x-triangleW/2, y, x+triangleW/2, y, x, y+triangleH);
        fill(255-hue, 255, 255); 
        triangle(x, y+triangleH, x+triangleW, y+triangleH, x+triangleW/2, y);

        if (increment) {
          hue += 5;
        } else {
          hue -= 5;
        }

        if (hue >= 255) {
          increment = false;
        }
        if (hue <= 0) {
          increment = true;
        }
      }
    }
   rotateY(HALF_PI*i%2); 
  }
}

