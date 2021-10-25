// instructions

// control the crosshair with the joystick
// press the button to launch the probe, launching takes resources
// if the probe makes contact with a rich asteroid, it will collect it
// the probe will automatically deposit the minerals on earth

// maybe add obstacles
// add a nice starry background
// rng for challenge

import processing.serial.*;

Serial myConnection;
String serialValue = "";
float xConverted;
float yConverted;

color bkgColor;
float funding;
ArrayList<Asteroid> asteroids;
Probe miner;
Targeter crosshair;
int lastAsteroidSpawn;
boolean launch;

void setup() {
  size(800, 800);
  bkgColor = color(10, 10, 10);

  printArray(Serial.list());
  myConnection = new Serial(this, "/dev/cu.usbserial-021FEF34", 9600);
  myConnection.bufferUntil('\n');

  miner = new Probe(100, 50);
  crosshair = new Targeter(width/2, height/2);
  xConverted = 0;
  yConverted = 0;
  
  asteroids = new ArrayList<Asteroid>();
  asteroids.add(new Asteroid());
  lastAsteroidSpawn = 0;
  
  launch = false;
  funding = 2000;
  
  print("Asteroid Mining!  ");
  print("Use the joystick to aim.  Press the button to launch the probe.");

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
  
  // spawn Asteroids at five second intervals
  if (millis() - lastAsteroidSpawn > 5000) {
    asteroids.add(new Asteroid());
    lastAsteroidSpawn = millis();
  }

  // Delete asteroid from ArrayList when it leaves the screen
  for (int i = asteroids.size()-1; i >= 0; i--) {
    Asteroid a = asteroids.get(i);
    if (a.position.x + a.radiusW <= 0) {
      asteroids.remove(i);
    } else {
      a.move();
      a.display();
    }
  }
  
  //println("x: " + xConverted + " y: " + yConverted);
  miner.scan();
  
  crosshair.move(new PVector(xConverted, yConverted));
  crosshair.display();
  miner.display();
  
  // probe launch
  if(crosshair.mode == 2) { 
    miner.movetoTarget(crosshair.position.x, crosshair.position.y);
    miner.mine(asteroids);
    if(abs(crosshair.position.x - miner.position.x) <= 10 && abs(crosshair.position.y - miner.position.y) <= 10) {
      crosshair.mode = 3;
    }
  }
  
  // once probe reaches crosshair or mines a asteroid, it returns home
  if (crosshair.mode == 3 || miner.full == true) {
    crosshair.mode = 3;
    miner.returnHome();
    // failsafe to prevent softlock if probe goes back to earth without minerals
    if (abs(100 - miner.position.x) <= 50 && abs(100 - miner.position.y) <= 50) {
      crosshair.mode = 1;
    }
    // increase score and resources if the probe returns home full of minerals
    if(miner.full == true) {
      miner.collect();
    }
    
  }
  
  if (launch == true && crosshair.mode == 1) {
    if (funding >= 500) {
      crosshair.mode = 2;
      funding -= 500;
    }
    launch = false;
  }

  fill(255, 255, 255);
  textSize(30);
  text("Funding: $" + funding, width/2 - 100, height/10);
  if(funding < 500 && miner.full == false && crosshair.mode == 3) {
    text("Bankrupt. You Lose.", width/2 - 100, height/2);
  }
}

void serialEvent(Serial conn) {

  float[] values = float(split(trim(conn.readString()), ','));
  if (values.length == 3 && !Float.isNaN(values[0]) && !Float.isNaN(values[1])) {
    //xConverted = map(values[0], 0, 4095, 0, width);
    //yConverted = map(values[1], 0, 4095, height, 0);
    
    float xTemp = map(values[0], 0, 4095, -5, 5);
    if (abs(xConverted - xTemp) >= 0.5) {
      xConverted = xTemp;
    } else {
      xConverted = 0;
    }
    
    float yTemp = map(values[1], 0, 4095, 5, -5);
    if (abs(yConverted - yTemp) >= 0.5) {
      yConverted = yTemp;
    } else {
      yConverted = 0;
    }
    if (values[2] < 1.0) {
      launch = true;
    } else {
      launch = false;
    }

    printArray(values);
  }
  

}
