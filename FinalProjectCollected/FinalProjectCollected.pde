import processing.pdf.*;
import java.io.InputStreamReader;
import processing.video.*;
import hypermedia.net.*;
import processing.serial.*;

String params[] = { "C:\\Program Files (x86)\\Foxit Software\\Foxit Reader\\FoxitReader.exe", "/p", "C:\\Users\\Christian\\Documents\\Processing\\sketches\\Printtest\\output.pdf" };
String val;
String message;
String messageReceived;
String ip;
float weight;
float weight_before = 0;
String weight_ard;
int countUp; 
int countdownTime = 5000;
int port;
boolean once = true;
Capture cam;  
UDP udp; 
PGraphics pdf;
Serial myPort; 

void setup() {
  pdf = createGraphics(640, 480, PDF, "output.pdf");
  
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[29]);
  cam.start();
  
  udp = new UDP( this, 6000 );
  
  ip = "192.168.43.129";
  port = 6000;
  udp.listen(true); 
  
  /*myPort = new Serial(this, Serial.list()[0], 38400);*/
}

void draw() {
  
  //Listen to Arduino
 /* if (myPort.available () > 0) {
  weight_ard = myPort.readString();
  println(weight_ard);
  } */
  
  //weight = weight_ard;
 
  // Camera start
  if (cam.available() == true) {
    cam.read();
  }
  
  // Countdown start
  if (abs(weight_before - weight) > 30) {
    countUp = millis();
    once = false;
    println("Countdown started");
  }
  
  // Take picture when countdown ends
  if (millis() - countUp >= countdownTime && once == false) {
    pdf.beginDraw();
    pdf.image(cam, 0, 0);
    pdf.dispose();
    pdf.endDraw();
    once = true;
    println("Picture taken");
  }
  
  // Send weight via UDP
  //message   = weight_ard;
  //udp.send( message, ip, port);
  
  //Save the old weight
  weight_before = weight;
}

// void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  
  
  // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  messageReceived = new String( data );   
  
  // print the result
  println( "receive: \""+messageReceived+"\" from "+ip+" on port "+port );
}


// If a key is pressed, print the current PDF
void keyPressed() {
  open(params);
  println("Picture printed");
} 
