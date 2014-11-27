import processing.pdf.*;
import java.io.InputStreamReader;
import processing.video.*;
import hypermedia.net.*;
import processing.serial.*;

String params[] = { 
  "C:\\Program Files (x86)\\Foxit Software\\Foxit Reader\\FoxitReader.exe", "/p", "C:\\Users\\Christian\\Dropbox\\Skole\\Mexi\\FinalProject\\FinalProjectCollected\\output.pdf"
};

// UDP
String message;
String messageReceived;
String ip;
int port;
UDP udp; 


// Weight calculations
float weight = 1;
float weight_before = 1;
String weight_temp_str = "0";
float weight_temp_fl = 0.0f;
float[] weight_arr;

// Counter for taking a picture
int countUp; 
int countdownTime = 5000;

boolean counting = false;
boolean hasBeenZero = true;


// Serial
Serial myPort; 
int lf = 10;

// Camera and image creation stuff
Capture cam;  
PGraphics pdf;
PGraphics img_creator;

// Glitch art
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

// Counter for the weight array
int counter = 0;

void setup() {
  size(640, 480, P2D);
  pdf = createGraphics(640, 480, PDF, "output.pdf");

  // Set standard color
  rec_color = color(0, 100, 200, 200);

  // Camera setup
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[29]);
  cam.start();


  weight_arr = new float[2];

  // UDP setup
  udp = new UDP( this, 6000 );
  //udp.log( true );
  ip = "192.168.1.122";
  port = 6000;
  udp.listen(true); 

  // Serial setup
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
      // Get weight as string
      weight_temp_str = myPort.readStringUntil(lf);
      if (weight_temp_str != null) {
        //Parse to float
        weight_temp_fl = Float.parseFloat(weight_temp_str);
        println(weight_temp_fl);
        
        // If it's not a button press
        if (weight_temp_fl != 9999) {

          //println("Weight received: " + weight_temp);
          weight = weight_temp_fl;
          weight_arr[counter] = weight;
          counter++;
        } else {
          // Print
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

  // If not already countdown and weight has been zero since last 
  if (counting == false && hasBeenZero == true) {
    println("jeg slap igennem de to booleans");
    
    // If last two weights has been more than 20kg
    if (weight_arr[0] > 20 && weight_arr[1] > 20) {
      println("Vægten er god fin!");
      
      // Start countdown
      countUp = millis();
      counting = true;
      hasBeenZero = false;
      println("Countdown started");
      
      //glitch();
      //counting = false;
      
      // Send new weight to Unity
//      message   = str(weight);
//      udp.send( message, ip, port);
    }
  }

  
  if (abs(weight_before - weight) > 20) {
    // Send weight via UDP
    message   = str(weight);
    udp.send( message, ip, port);
  }
  

  // Take picture when countdown ends
 if (millis() - countUp >= countdownTime && counting) {
    glitch();
    counting = false;
  }

  // If the last two weights has been below zero, set hasBeenZero to true
  if (weight_arr[0] < 20 && weight_arr[1] < 20 ) {
    println("Pyyh, nu gik hun endelig af!");
    hasBeenZero = true;
  } else {
    println("Hun er ikke gået af endnu");
    //hasBeenZero = false;
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

