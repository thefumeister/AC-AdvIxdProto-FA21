// instructions

// control the probe with mouse
// touch and left click an asteroid to mine minerals
// the probe can only carry one unit of minerals at a time
// return the probe to Earth and right click to offload the minerals
// press space to spawn more asteroids

import processing.serial.*;

Serial myConnection;
String serialValue = "";
float sVconverted;

color bkgColor;
float score;
ArrayList<Asteroid> asteroids;
Probe miner;



void setup(){
  size(800,800);
  
  myConnection = new Serial(this, Serial.list()[7], 9600);
  myConnection.bufferUntil('\n');
  
  bkgColor = color(10, 10, 10);
  
  miner = new Probe(100, 50);
  
  sVconverted = miner.position.x;
  asteroids = new ArrayList<Asteroid>();
  asteroids.add(new Asteroid());
  print("Asteroid Mining!  ");
  print("Press Space to scan for asteroids. It costs $750 to make a scan. ");
  print("Left click to mine an asteroid.  ");
  print("Right click to deposit minerals on Earth.  ");
  
}

void draw() {
  background(bkgColor);
  
  // display probe launch site
  fill(55, 86, 115);
  circle(100, 100, 150); 
  noStroke();
  
  fill(125, 162, 126);
  circle(120, 100, 80);
  circle(60, 80, 40);
  noStroke();
  
  for (Asteroid asteroid : asteroids) {
    asteroid.display();
  }
  
  miner.move(sVconverted);
  
  fill(255, 255, 255);
  textSize(30);
  text("Earnings: $" + score*1000, width/2 - 100, height/10);
}


void serialEvent(Serial conn) {
  serialValue = conn.readString();
  sVconverted = map(float(serialValue), 0, 4095, 0, width);
}


// Spend earnings to add more asteroids with spacebar, simulates probe finding and moving across the solar system to new asteroid fields
void keyReleased() {
  if (key == 'a') {
    if(score >= .75){
      asteroids.add(new Asteroid());
      score -= .75;
    }
  }
  
  if (key == 'd') {
    miner.pointer_mode = !miner.pointer_mode;
  }
}


// mine asteroids with left click, deposit on Earth 
void mousePressed() {
  if (mouseButton == LEFT) {
  miner.mine(asteroids); 
  }
  if (mouseButton == RIGHT) {
  miner.collect();
  }
}
