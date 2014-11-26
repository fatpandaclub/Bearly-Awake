import processing.video.*;
import processing.pdf.*;

Capture cam;

void setup() {
  size(641, 481);
  
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i+": "+cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[10]);
    //beginRecord(PDF, "line.pdf"); 
    cam.start();     
  }      
}

void draw() {
  
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}

void keyPressed() {
  //endRecord();  
  saveFrame("img_#####.jpg"); 
  println("hej");
}
