/*

Kepler Visualization
2011 - new data added in 2012
blprnt@blprnt.com

This sketch requires toxiclibs - http://toxiclibs.org

*/

//Import libraries
import toxi.geom.*;
import processing.opengl.*;
PFont label;

//Here's the big list that will hold all of our planets
ArrayList<ExoPlanet> planets = new ArrayList();


//Conversion constants
float ER = 1;           //Earth Radius, in pixels
float AU = 1000;          //Astronomical Unit, in pixels
float YEAR = 50000;        //One year, in frames

//Max/Min numbers
float maxTemp = 3257;
float minTemp = 84;

float yMax = 10;
float yMin = 0;

float maxSize = 0;
float minSize = 1000000;

String xLabel = "Semi-major Axis (Astronomical Units)";
String yLabel = "Temperature (Kelvin)";

//Rotation Vectors
PVector rot = new PVector();
PVector trot = new PVector();

float zoom = 0;
float tzoom = 0.3;

float flatness = 0;
float tflatness = 0;

ExoPlanet earth;
ExoPlanet jupiter;
ExoPlanet mercury;
ExoPlanet mars;

int saveCount = 0;

boolean PDFing = false;

void setup() {
  size(screenWidth,screenHeight,OPENGL);
  background(0);
  smooth();  

  label = createFont("Helvetica", 96);


  getPlanets(sketchPath + "/data/KeplerData.csv");
  getPlanets2012(sketchPath + "/data/planets2012_2.csv");
  addMarkerPlanets();
}

void getPlanets(String url) {
  //From each 
  String[] pArray = loadStrings(url);
  for (int i = 0; i < pArray.length; i++) {
    ExoPlanet p = new ExoPlanet().fromCSV(split(pArray[i], ",")).init();
    planets.add(p);
    maxSize = max(p.radius, maxSize);
    minSize = min(p.radius, minSize);
    maxTemp = max(p.temp, maxTemp);
    
    if (p.KOI.equals("326.01")) {
     p.feature = true;
     p.label = "326.01"; 
    } else if (p.KOI.equals("314.02")) {
      p.feature = true;
     p.label = "314.02"; 
    }
  } 
}

void getPlanets2012(String url) {
  
  //From each 
  String[] pArray = loadStrings(url);
  for (int i = 0; i < pArray.length; i++) {
    ExoPlanet p = new ExoPlanet().fromCSV2012(split(pArray[i], ",")).init();
    planets.add(p);
    maxSize = max(p.radius, maxSize);
    minSize = min(p.radius, minSize);
    maxTemp = max(p.temp, maxTemp);
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
  if (PDFing) beginRaw(PDF, "discover.pdf");
  
  
  
  
  //Ease rotation vectors, zoom

  zoom += (tzoom - zoom) * 0.01;
  rot.x += (trot.x - rot.x) * 0.1;
  rot.y += (trot.y - rot.y) * 0.1;
  rot.z += (trot.z - rot.z) * 0.1;

  flatness += (tflatness - flatness) * 0.1;
  

  //MousePress Rotation Adjustment
  if (mousePressed) {
    trot.x += (pmouseY - mouseY) * 0.01;
    trot.z += (pmouseX - mouseX) * 0.01;
  }

  background(10);
  translate(width/2 - (width * flatness * 0.4), height/2 + (160 * rot.x));
  rotateX(rot.x);
  rotateZ(rot.z);
  scale(zoom);

  //Draw the sun
  fill(255 - (255 * flatness));
  noStroke();
  ellipse(0,0,10,10);

  //Draw a 1 AU ring
  stroke(255,100 - (90 * flatness));
  strokeWeight(2);
  noFill();
  ellipse(0,0,AU * 2,AU * 2);
  

  stroke(255,50 - (40 * flatness));
  noFill();
  ellipse(0,0,AU,AU);
  ellipse(0,0,AU * 10,AU * 10);

  //Draw the Y Axis
  stroke(255,100);
  pushMatrix();
  rotateY(-PI/2);
  line(0,0,500 * flatness,0);

  //Draw Y Axis max/min
  pushMatrix();
  fill(255,100 * flatness);
  rotateZ(PI/2);
  textFont(label);
  textSize(12);
  text(round(yMin), -textWidth(str(yMin)), 0);
  text(round(yMax), -textWidth(str(yMax)), -500);
  popMatrix();

  //Draw Y Axis Label
  fill(255,flatness * 255);
  text(yLabel, 250 * flatness, -10);

  popMatrix();

  //Draw the X Axis
  pushMatrix();
  rotateZ(PI/2);
  line(0,0,1500 * flatness,0);
  
  if (flatness > 0.5) {
    pushMatrix();
    rotateX(PI/2);
     line(AU * 1.06, -10, AU * 1.064, 10); 
     line(AU * 1.064, -10, AU * 1.068, 10);   
    popMatrix();
  }

  //Draw X Axis Label
  fill(255,flatness * 255);
  rotateX(-PI/2);
  text(xLabel, 50 * flatness, 17);

  //Draw X Axis min/max
  fill(255,100 * flatness);
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
  

  //if (recording) mm.addFrame();
  
  if (PDFing) {
   endRaw();
   PDFing = false; 
  }
}

void sortBySize() {
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).radius, 0, maxSize, 0, 500);
  }
}

void sortByTemp() {
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).temp, minTemp, maxTemp, 0, 500);
  }
}

void unSort() {
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
  
  else if (key == 'p') {
   PDFing = true; 
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


/*

//*** 2011 Batch


KOI,
Dur,           : [1] Transit duration, first contact to last contact - HOURS
Depth,         : [2] Transit depth at center of transit - PULSE POSITION MODULATION
SNR,
t0,t0_unc,
Period,P_unc,  : [6,7] Average interval between transits based on a linear fit to all observed transits and uncertainty - DAYS 
a/R*,a/R*_unc,
r/R*,r/R*_unc, : [10,11] Ratio of planet radius to stellar radius and uncertainty 
b,b_unc,
Rp,            :[14] Radius of the planet - EARTH RADII
a,             :[15] Semi-major axis of orbit based - AU (?)
Teq,           :[16]Equilibrium temperature of the planet - KELVIN
EB prob,
V,             :[18] Vetting flag 
                   1 Confirmed and published planet 
                   2 Strong probability candidate, cleanly passes tests that were applied 
                   3 Moderate probability candidate, not all tests cleanly passed but no definite test failures 
                   4 Insufficient follow-up to perform full suite of vetting tests 

FOP,
N,

//*** 2012 Batch

--------------------------------------------------------------------------------
   1-  7 F7.2   ---   KOI    Kepler Object of Interest number
   9- 20 F12.7  d     Per    Average interval between transits (1)
  22- 27 F6.2   ---   Rad    Planetary radius in Earth radii=6378 km (2)
  29- 34 F6.3   AU    a      Semi-major axis of orbit (3)
  36- 40 I5     K     Teq    Equilibrium temperature of planet (4)
  42- 47 F6.2   ---   O/E_1  Ratio of odd to even numbered transit depths (5)
  49- 54 F6.2   ---   O/E_2  Ratio of odd to even numbered transit depths (6)
  56- 63 F8.2   ---   Occ    Relative flux level at phase=0.5 divided by noise
  65- 71 F7.2   as    dra    Source position in RA relative to target (7)
  73- 79 F7.2   as  e_dra    Uncertainty in source position
  81- 87 F7.2   as    ddec   Source position in DEC relative to target (7)
  89- 95 F7.2   as  e_ddec   Uncertainty in source position
  97-102 F6.1   ---   dist   Distance to source position divided by noise
 104-109 F6.1   ---   MES    Multiple Event Statistic (MES) (8)
--------------------------------------------------------------------------------

*/



class ExoPlanet {
  
  String KOI;
  
  float dur;
  float depth;
  float period;
  float radiusRatio;
  float radius;
  float temp;
  float axis;
  int vFlag = 1;
  
  float theta = 0;
  float thetaSpeed = 0;
  
  float pixelRadius = 0;
  float pixelAxis;
  
  float z = 0;
  float tz = 0;
  
  color col;
  
  boolean feature = false;
  String label = "Test";
  

 
  //Constructor function
  ExoPlanet() {};
  
   ExoPlanet fromCSV2012(String[] sa) {
     
     /*
     --------------------------------------------------------------------------------
   1-  7 F7.2   ---   KOI    Kepler Object of Interest number
   9- 20 F12.7  d     Per    Average interval between transits (1)
  22- 27 F6.2   ---   Rad    Planetary radius in Earth radii=6378 km (2)
  29- 34 F6.3   AU    a      Semi-major axis of orbit (3)
  36- 40 I5     K     Teq    Equilibrium temperature of planet (4)
  42- 47 F6.2   ---   O/E_1  Ratio of odd to even numbered transit depths (5)
  49- 54 F6.2   ---   O/E_2  Ratio of odd to even numbered transit depths (6)
  56- 63 F8.2   ---   Occ    Relative flux level at phase=0.5 divided by noise
  65- 71 F7.2   as    dra    Source position in RA relative to target (7)
  73- 79 F7.2   as  e_dra    Uncertainty in source position
  81- 87 F7.2   as    ddec   Source position in DEC relative to target (7)
  89- 95 F7.2   as  e_ddec   Uncertainty in source position
  97-102 F6.1   ---   dist   Distance to source position divided by noise
 104-109 F6.1   ---   MES    Multiple Event Statistic (MES) (8)
--------------------------------------------------------------------------------

*/
    KOI = sa[0];
    //dur = float(sa[1]);
    //depth = float(sa[2]);
    period = float(sa[1]);
    //radiusRatio = float(sa[10]);
    radius = float(sa[2]);
    axis = float(sa[3]);
    temp = float(sa[4]);
    //vFlag =int(sa[18]);
    return(this);
  }
  
  //Load exoplanet data from a comma-delimited string (see key at top of class)
  ExoPlanet fromCSV(String[] sa) {
    KOI = sa[0];
    dur = float(sa[1]);
    depth = float(sa[2]);
    period = float(sa[6]);
    radiusRatio = float(sa[10]);
    radius = float(sa[14]);
    axis = float(sa[15]);
    temp = float(sa[16]);
    vFlag =int(sa[18]);
    return(this);
  }
  
  //Intitialize pixel-based motion data, color, etc. from exoplanet data
  ExoPlanet init() {
    
    println(radius);
    
    pixelRadius = radius * ER;
    pixelAxis = axis * AU;
    float periodInYears = period/365;
    float periodInFrames = periodInYears * YEAR;
    
    theta = random(2 * PI);
    thetaSpeed = (2 * PI) / periodInFrames;
    
    colorMode(HSB);
    col = color(map(sqrt(temp), sqrt(minTemp), sqrt(maxTemp - 1800), 200,0), 255, 255);
    colorMode(RGB);
    
    return(this);
  }
  
  //Update
  void update() {
    theta += thetaSpeed;
    z += (tz - z) * 0.1;
  }
  
  //Draw
  void render() {
   float apixelAxis = pixelAxis;
   if (axis > 1.06 && feature) {
     apixelAxis = ((1.06 + ((axis - 1.06) * ( 1- flatness))) * AU) + axis * 10;
   };
   float x = sin(theta * (1 - flatness)) * apixelAxis;
   float y = cos(theta * (1 - flatness)) * apixelAxis;
   pushMatrix();
     translate(x,y,z);
     //Billboard
     rotateZ(-rot.z);
     rotateX(-rot.x);
     noStroke();
     if (feature) {
       translate(0,0,1);
      stroke(255,255);
      strokeWeight(2);
      noFill();
      ellipse(0,0,pixelRadius + 10, pixelRadius + 10); 
      strokeWeight(1);
      pushMatrix();
      if (label.equals("Earth")) {
        stroke(#01FFFD,50);
        line(0,0,-pixelAxis * flatness,0);
      }
      rotate((1 - flatness) * PI/2);
      stroke(255,100);
      float r = max(50, 100 + ((1 - axis) * 200));
      r *= sqrt(1/zoom);
      if (zoom > 0.5 || label.charAt(0) != '3') {
        line(0,0,0,-r);
        translate(0,-r - 5);
        rotate(-PI/2);
        scale(1/zoom);
        fill(255,200);
        text(label, 0, 4);
      }
      popMatrix();
      
     }
     fill(col);
     noStroke();
     ellipse(0,0,pixelRadius,pixelRadius);
   popMatrix();
   
  }
  
}

