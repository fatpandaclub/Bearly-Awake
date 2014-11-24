class Panel {

  int hue; 
  ArrayList<Triangle> triangles;

  Panel() {
    triangles = new ArrayList<Triangle>();
  }

  void display() {
    for (y = 0; y <= panelW; y += triangleH) {
      for (x = 0; x <= panelH; x += triangleW) {

        fill(hue, 255, 255);
        triangle(x, y, x+triangleW, y, x, y+triangleH);
        fill(255-hue, 255, 255); 
        triangle(x, y+triangleW, x+triangleW, y+triangleW, x+triangleW, y);

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
  }
}

