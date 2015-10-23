/*

 Kepler Visualization - Controls
 
 GUI controls added by Lon Riesberg, Laboratory for Atmospheric and Space Physics
 lon@ieee.org
 
 April, 2012
 
 Current release consists of a vertical slider for zoom control.  The slider can be toggled
 on/off by pressing the 'c' key.
 
 Slide out controls that map to the other key bindings is currently being implemented and
 will be released soon.
 
*/

class Controls {
   
   int barWidth;   
   int barX;                          // x-coordinate of zoom control
   int minY, maxY;                    // y-coordinate range of zoom control
   float minZoomValue, maxZoomValue;  // values that map onto zoom control
   float valuePerY;                   // zoom value of each y-pixel 
   int sliderY;                       // y-coordinate of current slider position
   float sliderValue;                 // value that corresponds to y-coordinate of slider
   int sliderWidth, sliderHeight;
   int sliderX;                       // x-coordinate of left-side slider edge                     
   
   Controls () {
      
      barX = 40;
      barWidth = 15;
 
      minY = 40;
      maxY = minY + height/3 - sliderHeight/2;
           
      minZoomValue = 0.0;
      maxZoomValue = 3.0;   // 300 percent
      valuePerY = (maxZoomValue - minZoomValue) / (maxY - minY);
      
      sliderWidth = 25;
      sliderHeight = 10;
      sliderX = (barX + (barWidth/2)) - (sliderWidth/2);      
      sliderValue = minZoomValue; 
      sliderY = minY;     
   }
   
   
   void render() {

      strokeWeight(0.5);     
      stroke(105, 105, 105); 
      
      // zoom control bar
      fill(0, 0, 0, 0);
      rect(barX, minY, barWidth, maxY-minY);
      
      // slider
      fill(105, 105, 105);
      rect(sliderX, sliderY, sliderWidth, sliderHeight);
   }
   
   
   float getZoomValue(int y) {
      if ((y >= minY) && (y <= (maxY - sliderHeight/2))) {
         sliderY = (int) (y - (sliderHeight/2));     
         if (sliderY < minY) { 
            sliderY = minY; 
         } 
         sliderValue = (y - minY) * valuePerY + minZoomValue;
      }     
      return sliderValue;
   }
   
   
   void updateZoomSlider(float value) {
      int tempY = (int) (value / valuePerY) + minY;
      if ((tempY >= minY) && (tempY <= (maxY-sliderHeight))) {
         sliderValue = value;
         sliderY = tempY;
      }
   }
   
   
   boolean isZoomSliderEvent(int x, int y) {
      int slop = 50;  // number of pixels above or below slider that's acceptable.  provided for ease of use.
      int sliderTop = (int) (sliderY - (sliderHeight/2)) - slop;
      int sliderBottom = sliderY + sliderHeight + slop;
      return ((x >= sliderX) && (x <= (sliderX    + sliderWidth)) && (y >= sliderTop)  && (y <= sliderBottom) || draggingZoomSlider );
   } 
}



