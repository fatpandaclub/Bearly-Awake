import processing.pdf.*;
import java.io.InputStreamReader;
import processing.video.*;
import hypermedia.net.*;
import processing.serial.*;

String params[] = { 
  "C:\\Program Files (x86)\\Foxit Software\\Foxit Reader\\FoxitReader.exe", "/p", "C:\\Users\\Christian\\Dropbox\\Skole\\Mexi\\FinalProject\\FinalProjectCollected\\output.pdf"
};
String val;
String message;
String messageReceived;
String ip;
float weight = 1;
float weight_before = 1;
String weight_temp_str = "0";
float weight_temp_fl = 0.0f;
float[] weight_arr;
int countUp; 
int countdownTime = 5000;
int port;
boolean once = true;
boolean canTakePicture = false;
boolean counting = false;
Capture cam;  
UDP udp; 
PGraphics pdf;
PGraphics img_creator;
Serial myPort; 

/* glitch */
PImage img;
int pixStartX; 
int pixStartY;
int pixW;
int pixH;
int iterations = 200;
color rec_color;
PImage temp_img;
PImage overlay_img;
PImage mover_img;

int lf = 10;

int counter = 0;

void setup() {
  size(640, 480, P2D);
  pdf = createGraphics(640, 480, PDF, "output.pdf");

  rec_color = color(0, 100, 200, 200);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[5]);
  cam.start();

  weight_arr = new float[2];

  udp = new UDP( this, 6000 );
  //udp.log( true );
  ip = "192.168.1.122";
  port = 6000;
  udp.listen(true); 

  myPort = new Serial(this, Serial.list()[0], 38400);
  myPort.clear();
}

void draw() {

  if (counter > 1) {
    counter = 0;
  }

  //Listen to Arduino
  //println(myPort.available());
  if (myPort.available() > 0 ) {
    try {
      weight_temp_str = myPort.readStringUntil(lf);
      if (weight_temp_str != null) {
        weight_temp_fl = Float.parseFloat(weight_temp_str);
        println(weight_temp_fl);
        if (weight_temp_fl != 9999) {

          //println("Weight received: " + weight_temp);
          weight = weight_temp_fl;
          weight_arr[counter] = weight;
          counter++;
        } else {
          sendToPrint();
          println("Jeg printer!");
        }
      }
    } 
    catch (Exception e) {
      println("Exception: " + e.getMessage());
    }
  } 

  // Countdown start



  if (counting == false) {
    for (int i = 0; i < weight_arr.length; i++) {

      if (weight_arr[i] > 20 ) {
        canTakePicture = true;
        println("Pic ok!");
      }
    }
  }

  if (weight < 20) {
    counting = false;
  }

  if (canTakePicture) {
    countUp = millis();
    once = false;
    canTakePicture = false;
    counting = true;
    println("Countdown started");
  }

  if (abs(weight_before - weight) > 20) {
    // Send weight via UDP
    message   = str(weight);
    udp.send( message, ip, port);
  }

  // Take picture when countdown ends
  if (millis() - countUp >= countdownTime && once == false) {
    glitch();
    once = true;
  }

  //Save the old weight
  weight_before = weight;
}

// void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler

  messageReceived = new String( data );   

  // print the result
  //println( "receive: \""+messageReceived+"\" from "+ip+" on port "+port );
}


void glitch() {
  // Camera start
  if (cam.available() == true) {
    cam.read();
  }

  image(cam, 0, 0);
  img = cam;
  println("Picture taken!");

  // Get colors
  if ( messageReceived != null) {
    float red =  Float.parseFloat(messageReceived.substring(5, 10));
    float green =  Float.parseFloat(messageReceived.substring(12, 17));
    float blue =  Float.parseFloat(messageReceived.substring(19, 24));
    float alpha =  Float.parseFloat(messageReceived.substring(26, 31));

    red = map(red, 0, 1, 0, 255);
    green = map(green, 0, 1, 0, 255);
    blue = map(blue, 0, 1, 0, 255);
    alpha = map(alpha, 0, 1, 0, 255);
    rec_color = color(red, green, blue, alpha);
  }

  for (int i = 0; i < iterations; i++) {
    pixStartX = int(random(0, width));
    pixStartY = int(random(0, height));
    //println(pixStartX+" "+pixStartY);
    pixW = int(random(0, 100));
    pixH = int(random(0, 100));

    temp_img = get(pixStartX, pixStartY, pixW, pixH);
    //println(temp_img);

    pixStartX = int(random(0, width));
    pixStartY = int(random(0, height));
    //println(pixStartX+" "+pixStartY);
    blend(temp_img, 0, 0, pixW, pixH, pixStartX, pixStartY, pixW, pixH, DIFFERENCE);
  }
  tint(rec_color);
  image(img, 0, 0);
  blend(img, 0, 0, width, height, 0, 0, width, height, OVERLAY);
  println("hej!");


  mover_img = get(0, 0, width, height);

  pdf.beginDraw();
  pdf.image(mover_img, 0, 0); 
  pdf.dispose();
  pdf.endDraw();
}


// If a key is pressed, print the current PDF
void sendToPrint() {
  open(params);
  println("Picture printed");
} 

void keyPressed() {
  weight = random(20, 80);
}

