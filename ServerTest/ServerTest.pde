import processing.net.*;

int port = 5204; 
boolean myServerRunning = true;

Server myServer;

void setup() {
  size(200, 200);
  myServer = new Server(this, port);
}

void draw() {
  background(0);
  myServer.write(int(random(255)));
}

void serverEvent(Server server, Client client) {
  println(" A new client has connected: "+ client.ip());
}
