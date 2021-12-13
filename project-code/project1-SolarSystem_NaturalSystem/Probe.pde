class Probe {
  PVector position;
  float speed;
  
  Asteroid targetAsteroid;
  boolean full;
  
  float radius;
  color bodyColor;
  color panelColor;
  color fullColor;
  
  // probe setup
  Probe(float _x, float _y) {
    position = new PVector(_x, _y);
    // speed variable is used as a multiplier, which is why the value seems so low
    speed = 0.1;
    
    full = false;
    radius = 40;
    bodyColor = color(192, 192, 192);
    panelColor = color(20, 50, 200);
    fullColor = color(255, 215, 0);
  }
  
  // controls, probe will follow user mouse
  void move() {
    
    // horizontal movement, speed is calculated by multiplying a fraction of the distance between the mouse position and probe position
    float targetX = mouseX;
    float distanceX = targetX - position.x;
    position.x += distanceX * speed;
    
    // vertical movement, speed is calculated by multiplying a fraction of the distance between the mouse position and probe position
    float targetY = mouseY;
    float distanceY = targetY - position.y;
    position.y += distanceY * speed;
    
    // solar panels on probe
    fill(panelColor);
    rect(position.x, position.y - 10, radius + 10, radius - 20);
    rect(position.x - (radius + 10), position.y - 10, radius + 10, radius - 20);
    stroke(192, 192, 192);
    
    // color of main body changes when it has collected minerals
    if (full == false) {
      fill(bodyColor);
      rect(position.x - 15, position.y - 20, radius - 10, radius + 20);
      rect(position.x - (25), position.y + 15, radius + 10, radius - 25);
      noStroke();  
    } else {
      fill(fullColor);
      rect(position.x - 15, position.y - 20, radius - 10, radius + 20);
      rect(position.x - (25), position.y + 15, radius + 10, radius - 25);
      noStroke();  
    }
    
    // the probe will passively scan the ArrayList, check which object is the closest and will "lock on" to it so that other functions affect the correct item on the ArrayList in relation to the display
    try {
      Asteroid nearestAsteroid = asteroids.get(0);
         float distance = width + height;
         for (Asteroid asteroid : asteroids) {
           float currdistance = dist(position.x, position.y, asteroid.position.x, asteroid.position.y);
           if (currdistance <= distance) {
              nearestAsteroid = asteroid;
              distance = currdistance;
           }
         }
      targetAsteroid = nearestAsteroid;
    } catch (Exception e) {} // prevent errors when ArrayList is empty
  }
  
  
  // collect mineral from asteroid and add to probe inventory
  void mine(ArrayList<Asteroid> asteroids) {
    // probe will mine the asteroid so long as it is intersecting it
     try {
        if (abs(targetAsteroid.position.x - position.x) <= 100 && abs(targetAsteroid.position.y - position.y) <= 100) {
          if (asteroids.size() >= 1 && (full == false)) { 
            targetAsteroid.removeMineral();
            full = true;
          
            if (targetAsteroid.minerals <= 0) {
              asteroids.remove(targetAsteroid );
            }
           }
        }
      } catch (Exception e) {} // prevent errors when mouse is clicked without any items in ArrayList
  }
  
  // deposit mineral on earth and increase score
  void collect() {
    if (full == true && abs(100 - position.x) <= 100 && abs(100 - position.y) <= 100) {
      score += 1;
      print("Score: " + score + "  ");
      full = false;
    }
  }
  
}
