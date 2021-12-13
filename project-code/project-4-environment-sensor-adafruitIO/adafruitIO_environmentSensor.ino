#include "config.h"
#include "Adafruit_Sensor.h"
#include "Adafruit_AM2320.h"

Adafruit_AM2320 am2320 = Adafruit_AM2320();

// Controls which feed on Adafruit IO to connect to
AdafruitIO_Feed *temperature = io.feed("room-2-temperature");
AdafruitIO_Feed *humidity = io.feed("room-2-humidity");
AdafruitIO_Feed *light = io.feed("room-2-light");
AdafruitIO_Feed *noise = io.feed("room-2-noise");

#define IO_LOOP_DELAY 10000
unsigned long lastUpdate = 0;

int current_temperature = 20;
int current_humidity = 60;

int photocellPin = A2;     // the cell and 10K pulldown are connected to a2, as a0, a1, a5 are unusable with wifi
int photocellReading;     // the analog reading from the analog resistor divider

int micPin = A3;
int micReading;
int addedMicReadings;
int micReadingsCount;
int averageNoise;

void setup() {
  // Start serial connection
  Serial.begin(115200);
  
  // Wait for the serial monitor to open
  while(! Serial);

  // connect to io.adafruit.com
  Serial.print("Connecting to Adafruit IO");
  io.connect();

  // wait for a connection
  while(io.status() < AIO_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  // we are connected
  Serial.println();
  Serial.println(io.statusText());

  Serial.println("Adafruit AM2320 Running");
  am2320.begin();

}


void loop() {
  io.run();

  // Take photocell reading and upload to Adafruit.io
  photocellReading = analogRead(photocellPin);
  Serial.print("Photocell reading: "); Serial.print(photocellReading);
  
  // We'll have a few threshholds for the photocell reading, qualitatively determined
  if (photocellReading < 10) {
    Serial.println(" - Dark");
  } else if (photocellReading < 200) {
    Serial.println(" - Dim");
  } else if (photocellReading < 700) {
    Serial.println(" - Light");
  } else if (photocellReading < 1500) {
    Serial.println(" - Bright");
  } else {
    Serial.println(" - Very bright");
  }

  // Take sound reading and upload to Adafruit.io 
  micReading = analogRead(micPin);
  addedMicReadings += micReading;
  micReadingsCount += 1;
  averageNoise = (addedMicReadings / micReadingsCount);
  
  Serial.print("Noise: "); Serial.println(micReading);
  Serial.print("Average Noise: "); Serial.println(averageNoise);
  
  // Take temperature reading
  Serial.print("Temp: "); Serial.println(am2320.readTemperature());
  current_temperature = am2320.readTemperature();
  

  // Take humidity reading
  Serial.print("Hum: "); Serial.println(am2320.readHumidity());
  current_humidity = am2320.readHumidity();
  

  if (millis() > (lastUpdate + IO_LOOP_DELAY)) {
    // save count to the 'counter' feed on Adafruit IO
    temperature->save(current_temperature);
    humidity->save(current_humidity);
    light->save(photocellReading);
    noise->save(averageNoise);

    // after publishing, store the current time
    lastUpdate = millis();
    addedMicReadings = 0;
    micReadingsCount = 0;
    averageNoise = 0;
  }
  delay(10);
}
