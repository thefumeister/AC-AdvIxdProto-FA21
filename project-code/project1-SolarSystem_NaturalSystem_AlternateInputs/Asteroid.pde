class Asteroid {
  PVector position;
  PVector velocity;
  
  float radiusW;
  float radiusL;
  int minerals;
  
  color richColor;
  color midColor;
  color poorColor;
  color depColor;
  
  //Asteroid setup
  Asteroid() {
    this.radiusW = int(random(100, 150));
    this.radiusL = int(random(125, 150));
   
    this.richColor = color(255, 215, 0);
    this.midColor = color(200, 160, 0);
    this.poorColor = color(145, 115, 0);
    this.depColor = color(90, 77, 65);
    
    this.minerals = int(random(1,4));
    
    this.position = new PVector(random(100, 700), random(200,700));
  }
  
  // Draw asteroid, color dependent on mineral count
  void display() {
    
    fill(depColor);
    if (minerals == 1) {
      fill(poorColor);
    }
    if (minerals == 2) {
      fill(midColor);
    }
    if (minerals == 3) {
      fill(richColor);
    }

    noStroke();
    ellipse(position.x, position.y, radiusL, radiusW);
    

    }
}
