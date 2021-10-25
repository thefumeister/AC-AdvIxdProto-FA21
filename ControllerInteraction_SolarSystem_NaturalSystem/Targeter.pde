class Targeter {
  PVector position;
  float speed;
  PVector target;
  
  int mode;
  
  float radius;
  color reticleColor;
  color busyColor;
  
  Targeter(float _x, float _y) {
    position = new PVector(_x, _y);
    // speed variable is used as a multiplier, which is why the value seems so low
    speed = 0.1;
    
    // mode 1 is free movement, mode 2 is launced probe, mode 3 is retrieve probe
    mode = 1;
    radius = 40;
    reticleColor = color(255, 255, 255);
    busyColor = color(200, 0, 0);
  }
  
  void move(PVector _velocity) {
    if(mode == 1) {
      position.add(_velocity);
    }
  }
  
  void setTarget() {
    if(mode == 1) {
      target = new PVector(position.x, position.y);
      mode = 2;
    }
  }
  
  void display() {
    if(mode == 1) {
      fill(reticleColor);
    } else {
      fill(busyColor);
    }
    circle(position.x, position.y, 10);
    rect(position.x - 2, position.y - 60, 5, 30);
    rect(position.x - 2, position.y + 30, 5, 30);
    rect(position.x - 60, position.y - 1, 30, 5);
    rect(position.x + 30, position.y - 1, 30, 5);
  }
  
  
  
}
