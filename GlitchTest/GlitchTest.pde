PImage img; 
int leng;
int startPix;
color[] pixArray;

void setup() {
  size(800, 1000);
  img = loadImage("slothl.jpg");





}

void draw() {
  
  image(img,0,0);
  
  for (int i = 0; i < height; i++) {
    leng = int(random(10, 250));
    startPix = int(random(0, img.width-50));

    for (int j = 0; j < width; j++) {
      if (j == startPix) {
        pixArray = new color[leng];
        println(pixArray);
        for (int k = 0; k <= leng; k++) {
          pixArray[k] = pixels[j];          
        }
      }
    }
  }
  
  
  updatePixels();
}

