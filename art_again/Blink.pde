class Blink {
  
  float x,y,z,size,noiseScale, vel;
  PVector location, speed, noise;
  color c;
  
  Blink(float xtemp, float ytemp, float ztemp, color c_) {
    c = c_; 
    vel = 100;
    
    location = new PVector(xtemp, ytemp, ztemp);
    speed = new PVector((noise(location.x)-0.5)*50,(noise(location.y)-0.5)*50, vel);
    noise = new PVector(0, 0, 0);
    
  }
  
  void display() {
    fill(c);
    noise.set((noise(-location.x)-0.5)*100,(noise(-location.y)-0.5)*100,0);
    println(noise);
    speed.add(noise);
    location.add(speed);
    pushMatrix();
      translate(location.x,location.y,location.z);
      sphere(20);
    popMatrix();
  }
  
  boolean finished() {
    if (location.z > width*16) {
    return true;
    }
    else {
    return false;
    }
  }
}
