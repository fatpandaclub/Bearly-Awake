PImage img;

void setup() {
  
  size(640, 480);
  img = loadImage("picture.jpg");
  
  
  noStroke();
  ellipseMode(CENTER);
  smooth();
  
  fill(255, 0, 0);
  ellipse(320, 240, 200, 200);
  
  fill(0);
  textSize(32);
  text("Share your experience", 150, 400); 

}

void draw() {
 
  
}

void mouseClicked() {
  
  if(mouseX > 220 && mouseX < 420 && mouseY > 140 && mouseY < 340) {
    
    image(img, 0, 0);
  }
}
