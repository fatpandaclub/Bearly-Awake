
ArrayList<Blink> blinks;
int numBlinks;

float noiseX, noiseY, noiseZ, noiseScale;

void setup() {
  size(800, 800, P3D);
  noStroke();
  fill(255);
  background(0);

  smooth();
  camera(4000/2, 4000/2, width*8, 4000/2, 4000/2, 4000/2, 0, 1, 0);
  
  numBlinks = 1000;
  blinks = new ArrayList<Blink>();
}

void draw() {
  background(0);
  //filter(BLUR,1);
  lights();
  
  if (blinks.size() < numBlinks) {
    blinks.add(new Blink(random(4000), random(4000), 0, color(noise(millis())*255, 255, 255)));
  }

  for (int i = blinks.size()-1; i >= 0; i--) {
    Blink blink = blinks.get(i);
    blink.display();
    if (blink.finished()) {
      blinks.remove(i);
    }
  }
}

