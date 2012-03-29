/*

ExoPlanet Class
blprnt@blprnt.com
Spring, 2011 - new data added Spring 2012

There are two separate formats for the data - both are listed below.

 //  2011 Batch
 
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
 V,             :[18] Vetting flag: 
                         1 Confirmed and published planet 
                         2 Strong probability candidate, cleanly passes tests that were applied 
                         3 Moderate probability candidate, not all tests cleanly passed but no definite test failures 
                         4 Insufficient follow-up to perform full suite of vetting tests 
 FOP,
 N,
 
 // 2012 Batch
 
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
  // Data from the imported files
  String KOI;

  float period;
  float radius;
  float temp;
  float axis;
  int vFlag = 1;
  
  // Real movement/render properties
  float theta = 0;
  float thetaSpeed = 0;
  float pixelRadius = 0;
  float pixelAxis;

  float z = 0;
  float tz = 0;

  color col;

  boolean feature = false;
  String label = "";

  // Constructor function
  ExoPlanet() {};
  
  // Load exoplanet data from a comma-delimited string (see key at top of class)
  ExoPlanet fromCSV2012(String[] sa) {
    KOI = sa[0];
    period = float(sa[1]);
    radius = float(sa[2]);
    axis = float(sa[3]);
    temp = float(sa[4]);
    return(this);
  }

  // Load exoplanet data from a comma-delimited string (see key at top of class)
  ExoPlanet fromCSV(String[] sa) {
    KOI = sa[0];
    period = float(sa[6]);
    radius = float(sa[14]);
    axis = float(sa[15]);
    temp = float(sa[16]);
    vFlag = int(sa[18]);
    return(this);
  }

  // Initialize pixel-based motion data, color, etc. from exoplanet data
  ExoPlanet init() {
    pixelRadius = radius * ER;
    pixelAxis = axis * AU;

    float periodInYears = period/365;
    float periodInFrames = periodInYears * YEAR;
    theta = random(2 * PI);
    thetaSpeed = (2 * PI) / periodInFrames;

    return(this);
  }

  // Update
  void update() {
    theta += thetaSpeed;
    z += (tz - z) * 0.1;
  }

  // Draw
  void render() {
    float apixelAxis = pixelAxis;
    if (axis > 1.06 && feature) {
      apixelAxis = ((1.06 + ((axis - 1.06) * ( 1 - flatness))) * AU) + axis * 10;
    }
    float x = sin(theta * (1 - flatness)) * apixelAxis;
    float y = cos(theta * (1 - flatness)) * apixelAxis;
    pushMatrix();
    translate(x, y, z);
    // Billboard
    rotateZ(-rot.z);
    rotateX(-rot.x);
    noStroke();
    if (feature) {
      translate(0, 0, 1);
      stroke(255, 255);
      strokeWeight(2);
      noFill();
      ellipse(0, 0, pixelRadius + 10, pixelRadius + 10); 
      strokeWeight(1);
      pushMatrix();
      if (label.equals("Earth")) {
        stroke(#01FFFD, 50);
        line(0, 0, -pixelAxis * flatness, 0);
      }
      rotate((1 - flatness) * PI/2);
      stroke(255, 100);
      float r = max(50, 100 + ((1 - axis) * 200));
      r *= sqrt(1/zoom);
      if (zoom > 0.5 || label.charAt(0) != '3') {
        line(0, 0, 0, -r);
        translate(0, -r - 5);
        rotate(-PI/2);
        scale(1/zoom);
        fill(255, 200);
        text(label, 0, 4);
      }
      popMatrix();
    }
    fill(col);
    noStroke();
    ellipse(0, 0, pixelRadius, pixelRadius);
    popMatrix();
  }
}

