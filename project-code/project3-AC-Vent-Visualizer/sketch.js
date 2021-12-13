let temp1data, hum1data;
let temp2data, hum2data;
let t1h = 0;
let t2h = 0;
let t1l = 4095;
let t2l = 4095;

let t1hmap = 0;
let t2hmap = 0;
let t1lmap = 4095;
let t2lmap = 4095;

let interval;
let t1Reading, h1Reading;
let t2Reading, h2Reading;

function setup(){
  createCanvas(400, 400);

  fetchData();
  //interval = setInterval(fetchData, 5000);
}

function draw() {
  background(200);
  stroke(255);
  strokeWeight(10);
  
  line(width / 4, t1hmap, width / 4, t1lmap);
  line(width * 0.75, t2hmap, width * 0.75, t2lmap);
  strokeWeight(0);
  fill(0, 0, 0);
  text('Master Room 1 Vent', width / 4 - 30, height - 20);
  text('Master Room 2 Vent', width * 0.75 - 30, height - 20);
  fill(0, 102, 153);
  text('Low: ' + t1l + ' °C', width / 4, t1lmap + 30);
  text('Low: ' + t2l + ' °C', width * 0.75, t2lmap + 30);
  fill(255, 122, 0);
  text('High: ' + t1h + ' °C', width / 4, t1hmap - 20);
  text('High: ' + t2h + ' °C', width * 0.75, t2hmap - 20);
 
}

function fetchData() {
  temp1data = loadJSON(
    "https://io.adafruit.com/api/v2/Farcenter/feeds/master-room-1-ac-temperature/data?limit=1000",
    data1Handler,
    errorHandler
  );
  temp2data = loadJSON(
    "https://io.adafruit.com/api/v2/Farcenter/feeds/master-room-2-ac-temperature/data?limit=1000&end_time=2021-11-05T15:42PST",
    data2Handler,
    errorHandler
  );
}

function data1Handler(jsonData) {
  // console.log(jsonData);
  for (let i = 0; i < jsonData.length; i++) {
    console.log(jsonData[i].value);
    if (jsonData[i].value > t1h) {
      t1h = jsonData[i].value;
    }
    if (jsonData[i].value < t1l) {
      t1l = jsonData[i].value;
    }
  }
  console.log("t1h: " + t1h);
  console.log("t1l: " + t1l);
  t1hmap = map(t1h, 0, 100, height - 50, 0);
  t1lmap = map(t1l, 0, 100, height - 50, 0);
}

function data2Handler(jsonData) {
  //console.log(jsonData);
  for (let i = 0; i < jsonData.length; i++) {
    if (jsonData[i].value > t2h) {
      t2h = jsonData[i].value;
    }
    if (jsonData[i].value < t2l) {
      t2l = jsonData[i].value;
    }
  }
  console.log("t2h: " + t2h);
  console.log("t2l: " + t2l);
  t2hmap = map(t2h, 0, 100, height - 50, 0);
  t2lmap = map(t2l, 0, 100, height - 50, 0);
}

function errorHandler(error) {
  console.log("There has been an error: " + error);
}
