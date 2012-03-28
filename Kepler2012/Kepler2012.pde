/*

 Kepler Visualization
 2011 - new data added in 2012
 blprnt@blprnt.com
 
 This sketch requires toxiclibs - http://toxiclibs.org
 
 You can toggle between view modes with the keys 4,3,2,1,`
 
 */

//Import libraries
import toxi.geom.*;
import processing.opengl.*;
PFont label;

//Here's the big list that will hold all of our planets
ArrayList<ExoPlanet> planets = new ArrayList();

//Conversion constants
float ER = 1;           //Earth Radius, in pixels
float AU = 1500;          //Astronomical Unit, in pixels
float YEAR = 50000;        //One year, in frames

//Max/Min numbers
float maxTemp = 3257;
float minTemp = 84;

float yMax = 10;
float yMin = 0;

float maxSize = 0;
float minSize = 1000000;

//Axis labels
String xLabel = "Semi-major Axis (Astronomical Units)";
String yLabel = "Temperature (Kelvin)";

//Rotation Vectors - control the main 3D space
PVector rot = new PVector();
PVector trot = new PVector();

//Master zoom
float zoom = 0;
float tzoom = 0.3;

//This is a zero-one weght that controls wether the planets are flat on the
//plane (0) or not (1)
float flatness = 0;
float tflatness = 0;

//These are the four 'marker' planets
ExoPlanet earth;
ExoPlanet jupiter;
ExoPlanet mercury;
ExoPlanet mars;

void setup() {
  size(screenWidth, screenHeight, OPENGL);
  background(0);
  smooth(4);  

  label = createFont("Helvetica", 96);

  //Because NASA released their data from 2011 and 2012 in somewhat
  //Different formats, there are two functions to load the data and populate
  //the 'galaxy'.
  getPlanets(sketchPath + "/data/KeplerData.csv", false);
  println(planets.size());
  getPlanets(sketchPath + "/data/planets2012_2.csv", true);
  println(planets.size());
  addMarkerPlanets();
}

void getPlanets(String url, boolean is2012) {
  //Heere, the data is loaded and a planet is made from each lime
  String[] pArray = loadStrings(url);
  for (int i = 0; i < pArray.length; i++) {
    ExoPlanet p;
    if (is2012) {
      p = new ExoPlanet().fromCSV2012(split(pArray[i], ",")).init();
    } 
    else {
      p = new ExoPlanet().fromCSV(split(pArray[i], ",")).init();
    }
    planets.add(p);
    maxSize = max(p.radius, maxSize);
    minSize = min(p.radius, minSize);
    maxTemp = max(p.temp, maxTemp);

    //These are two planetes from the 2011 data set that I wanted to feature.
    if (p.KOI.equals("326.01")) {
      p.feature = true;
      p.label = "326.01";
    } 
    else if (p.KOI.equals("314.02")) {
      p.feature = true;
      p.label = "314.02";
    }
  }
}


void addMarkerPlanets() {
  //Now, add the solar system planets

    mars = new ExoPlanet();
  mars.period = 686;
  mars.radius = 0.533;
  mars.axis = 1.523;
  mars.temp = 212;
  mars.feature = true;
  mars.label = "Mars";
  mars.init();
  planets.add(mars);


  earth = new ExoPlanet();
  earth.period = 365;
  earth.radius = 1;
  earth.axis = 1;
  earth.temp = 254;
  earth.feature = true;
  earth.label = "Earth";
  earth.init();
  planets.add(earth);

  jupiter = new ExoPlanet();
  jupiter.period = 4331;
  jupiter.radius = 11.209;
  jupiter.axis = 5.2;
  jupiter.temp = 124;
  jupiter.feature = true;
  jupiter.label = "Jupiter";
  jupiter.init();
  planets.add(jupiter);

  mercury = new ExoPlanet();
  mercury.period = 87.969;
  mercury.radius = 0.3829;
  mercury.axis = 0.387;
  mercury.temp = 434;
  mercury.feature = true;
  mercury.label = "Mercury";
  mercury.init();
  planets.add(mercury);
}

void draw() {

  //Ease rotation vectors, zoom

  zoom += (tzoom - zoom) * 0.01;
  rot.x += (trot.x - rot.x) * 0.1;
  rot.y += (trot.y - rot.y) * 0.1;
  rot.z += (trot.z - rot.z) * 0.1;

  //Ease the flatness weight
  flatness += (tflatness - flatness) * 0.1;

  //MousePress Rotation Adjustment
  if (mousePressed) {
    trot.x += (pmouseY - mouseY) * 0.01;
    trot.z += (pmouseX - mouseX) * 0.01;
  }

  background(10);
  //We want the center to be in the middle and slightly down when flat, and to the left and down when raised
  translate(width/2 - (width * flatness * 0.4), height/2 + (160 * rot.x));
  rotateX(rot.x);
  rotateZ(rot.z);
  scale(zoom);

  //Draw the sun
  fill(255 - (255 * flatness));
  noStroke();
  ellipse(0, 0, 10, 10);

  //Draw a 2 AU ring
  stroke(255, 100 - (90 * flatness));
  strokeWeight(2);
  noFill();
  ellipse(0, 0, AU * 2, AU * 2);

  //Draw a 1 AU ring
  stroke(255, 50 - (40 * flatness));
  noFill();
  ellipse(0, 0, AU, AU);

  //Draw a 10 AU ring
  ellipse(0, 0, AU * 10, AU * 10);

  //Draw the Y Axis
  stroke(255, 100);
  pushMatrix();
  rotateY(-PI/2);
  line(0, 0, 500 * flatness, 0);

  //Draw Y Axis max/min
  pushMatrix();
  fill(255, 100 * flatness);
  rotateZ(PI/2);
  textFont(label);
  textSize(12);
  text(round(yMin), -textWidth(str(yMin)), 0);
  text(round(yMax), -textWidth(str(yMax)), -500);
  popMatrix();

  //Draw Y Axis Label
  fill(255, flatness * 255);
  text(yLabel, 250 * flatness, -10);

  popMatrix();

  //Draw the X Axis if we are not flat
  pushMatrix();
  rotateZ(PI/2);
  line(0, 0, 1500 * flatness, 0);

  if (flatness > 0.5) {
    pushMatrix();
    rotateX(PI/2);
    line(AU * 1.06, -10, AU * 1.064, 10); 
    line(AU * 1.064, -10, AU * 1.068, 10);   
    popMatrix();
  }

  //Draw X Axis Label
  fill(255, flatness * 255);
  rotateX(-PI/2);
  text(xLabel, 50 * flatness, 17);

  //Draw X Axis min/max
  fill(255, 100 * flatness);
  text(1, AU, 17);
  text("0.5", AU/2, 17);

  popMatrix();

  //Render the planets
  for (int i = 0; i < planets.size(); i++) {
    ExoPlanet p = planets.get(i);
    if (p.vFlag < 4) {
      p.update();
      p.render();
    }
  }
}

void sortBySize() {
  //Raise the planets off of the plane according to their size
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).radius, 0, maxSize, 0, 500);
  }
}

void sortByTemp() {
  //Raise the planets off of the plane according to their temperature
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).temp, minTemp, maxTemp, 0, 500);
  }
}

void unSort() {
  //Put all of the planets back onto the plane
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = 0;
  }
}

void keyPressed() {
  String timeStamp = hour() + "_"  + minute() + "_" + second();
  if (key == 's') {
    save("out/Kepler" + timeStamp + ".png");
  } 

  if (keyCode == UP) {
    tzoom += 0.025;
  } 
  else if (keyCode == DOWN) {
    tzoom -= 0.025;
  }

  if (key == '1') {
    sortBySize(); 
    toggleFlatness(1);
    yLabel = "Planet Size (Earth Radii)";
    yMax = maxSize;
    yMin = 0;
  } 
  else if (key == '2') {
    sortByTemp(); 
    trot.x = PI/2;
    yLabel = "Temperature (Kelvin)";
    //toggleFlatness(1);
    yMax = maxTemp;
    yMin = minTemp;
  } 
  else if (key == '`') {
    unSort(); 
    toggleFlatness(0);
  }
  else if (key == '3') {
    trot.x = 1.5;
  }
  else if (key == '4') {
    tzoom = 1;
  }

  if (key == 'f') {
    tflatness = (tflatness == 1) ? (0):(1);
    toggleFlatness(tflatness);
  }
}

void toggleFlatness(float f) {
  tflatness = f;
  if (tflatness == 1) {
    trot.x = PI/2;
    trot.z = -PI/2;
  }
  else {
    trot.x = 0;
  }
}

