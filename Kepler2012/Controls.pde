/*

 Kepler Visualization - Controls
 
 GUI controls added by Lon Riesberg, Laboratory for Atmospheric and Space Physics, University of Colorado, Boulder
 
 wwww.lonriesberg.com
 lon@ieee.org
 
 April, 2012
 
 Current release consists of:
    1) Vertical slider for zoom control.  
    2) Checkbox selections for sort by size, temp, or unsorted.
    3) ~Checkbox selections for reseting flatness, rotation, and zoom.
    
All controls can be toggled on/off by pressing the 'c' key. 

When the controls are toggled on, checkbox selections are accessed by clicking the triangle at the top, center of the screen.
Clicking the triangle at the top, center a second time, hides the checkbox selections.
 
*/

class Controls {
   
   // zoom 
   int zoomBarWidth;   
   int zoomBarX;                             // x-coordinate of zoom control
   int minZoomY, maxZoomY;                   // y-coordinate range of zoom control
   float minZoomValue, maxZoomValue;         // values that map onto zoom control
   float zoomValuePerY;                      // zoom value of each y-pixel 
   int zoomSliderY;                          // y-coordinate of current slider position
   float zoomSliderValue;                    // value that corresponds to y-coordinate of slider
   int zoomSliderWidth, zoomSliderHeight;
   int zoomSliderX;                          // x-coordinate of left-side slider edge   

   // options
   int optionsToggleX, optionsToggleY;
   int optionsToggleSize;
   int showOptions;
   int optionsX, optionsY;   // top-left corner of options frame
   int optionsWidth, optionsHeight;
   
   int sortOptionValue;
   int sortOptionsY;
   int checkboxSize;
   int sortHeadingX, sortSizeX, sortTempX, sortNoneX;
   int sortSizeCheckboxX, sortTempCheckboxX, sortNoneCheckboxX;
   
   int resetOptionsY;
   int resetHeadingX, resetFlatnessX, resetRotationX, resetZoomX;
   int resetFlatnessCheckboxX, resetRotationCheckboxX, resetZoomCheckboxX; 
   int flashFlatness, flashRotation, flashZoom;   
      
   
   Controls () {
      
      textFont(label, 16);
             
      // 
      // zoom
      //
      zoomBarX = 40;
      zoomBarWidth = 15;
 
      minZoomY = 40;
      maxZoomY = minZoomY + height/3 - zoomSliderHeight/2;
           
      minZoomValue = 0.0;
      maxZoomValue = 3.0;   // 300 percent
      zoomValuePerY = (maxZoomValue - minZoomValue) / (maxZoomY - minZoomY);
      
      zoomSliderWidth = 25;
      zoomSliderHeight = 10;
      zoomSliderX = (zoomBarX + (zoomBarWidth/2)) - (zoomSliderWidth/2);      
      zoomSliderValue = minZoomValue; 
      zoomSliderY = minZoomY;   


      // 
      // options
      //
      showOptions = -1;
      
      // options toggle
      optionsToggleX = width/2;
      optionsToggleY = 10;
      optionsToggleSize = 15;            
      
      // options frame
      optionsWidth = 400;
      optionsHeight = 80;
      optionsX = optionsToggleX - optionsWidth/2;
      optionsY = optionsToggleY + optionsToggleSize + 15;
      
      // sort options
      sortOptionValue = 0;    //  0 == unsorted; 1 == sort by size; 2 == sort by temperature
      sortOptionsY = optionsY + optionsHeight/3;
      checkboxSize = 13;
      sortHeadingX = optionsX + 10;                  // x-value for beginning of "SORT:" text
      sortNoneX = optionsWidth/4 + optionsX;         // x-value for beginning of "none" text 
      sortNoneCheckboxX = sortNoneX + 42;            // x-value of "none" checkbox
      sortSizeX = optionsWidth/2 + optionsX;         // x-value for beginning of "by size" text
      sortSizeCheckboxX = sortSizeX + 35;            // x-value of size checkbox
      sortTempX = 3 * optionsWidth/4 + optionsX;     // x-value for beginning of "by temp" text      
      sortTempCheckboxX = sortTempX + 41;            // x-value of temp checkbox
      
      // reset options
      flashFlatness = -1;
      flashRotation = -1;
      flashZoom = -1;  
      resetOptionsY = optionsY + 5 * optionsHeight/6;
      resetHeadingX = optionsX + 10;                 // x-value for beginning of "RESET:" text
      resetFlatnessX = optionsWidth/4 + optionsX;    // x-value for beginning of "flatness" text 
      resetFlatnessCheckboxX = resetFlatnessX + 62;    // x-value of reset flatness checkbox
      resetRotationX = optionsWidth/2 + optionsX;    // x-value for beginning of "rotation" text
      resetRotationCheckboxX = resetRotationX + 60;    // x-value of reset rotation checkbox
      resetZoomX = 3 * optionsWidth/4 + optionsX;    // x-value for beginning of "zoom" text      
      resetZoomCheckboxX = resetZoomX + 46;            // x-value of reset zoom checkbox      
      

   }
   
   
   void render() {

      strokeWeight(0.5);     
      stroke(105, 105, 105); 
      
      // zoom control bar
      fill(0, 0, 0, 0);
      rect(zoomBarX, minZoomY, zoomBarWidth, maxZoomY-minZoomY);
      
      // slider
      fill(105, 105, 105);
      rect(zoomSliderX, zoomSliderY, zoomSliderWidth, zoomSliderHeight);
      
      // options display controller
      noFill();
      triangle(optionsToggleX-optionsToggleSize, optionsToggleY, optionsToggleX+optionsToggleSize, optionsToggleY, optionsToggleX, optionsToggleY+optionsToggleSize);
      
      // show options
      if (showOptions > 0) {     
         strokeWeight(0.5);    
         stroke(155, 155, 155);
         rect(optionsX, optionsY, optionsWidth, optionsHeight);  // frame for all options

         // labels
         fill(155, 155, 155);
         textSize(16);
         text("SORT: " , sortHeadingX, sortOptionsY); 
         text("size " , sortSizeX, sortOptionsY);
         text("temp " , sortTempX, sortOptionsY);
         text("none " , sortNoneX, sortOptionsY);   
         text("RESET: ", resetHeadingX, resetOptionsY);
         text("flatness ", resetFlatnessX, resetOptionsY);
         text("rotation ", resetRotationX, resetOptionsY);
         text("zoom ", resetZoomX, resetOptionsY);
  
         // sort by size                
         if (sortOptionValue == 1) { 
            fill(155, 155, 155);
         } else {
            noFill();
         }
         rect(sortSizeCheckboxX, sortOptionsY-checkboxSize, checkboxSize, checkboxSize);
         
         // sort by temperature        
         if (sortOptionValue == 2) { 
            fill(155, 155, 155);
         } else {
            noFill();
         }
         rect(sortTempCheckboxX, sortOptionsY-checkboxSize, checkboxSize, checkboxSize);
         
         // unsorted         
         if (sortOptionValue == 0) { 
            fill(155, 155, 155);
         } else {
            noFill();
         }
         rect(sortNoneCheckboxX, sortOptionsY-checkboxSize, checkboxSize, checkboxSize);    
     
         // center divider
         stroke(105, 105, 105);
         line(optionsX + 20, optionsY + optionsHeight/2, optionsX + optionsWidth - 20, optionsY + optionsHeight/2);
         
         // reset flatness
         if (flashFlatness > 0) {
            fill(155, 155, 155);
            flashFlatness--;
         } else {
            noFill();
         }
         rect(resetFlatnessCheckboxX, resetOptionsY-checkboxSize, checkboxSize, checkboxSize);
         
         // reset rotation 
         if (flashRotation > 0) {
            fill(155, 155, 155);
            flashRotation--;
         } else {
            noFill();
         }
         rect(resetRotationCheckboxX, resetOptionsY-checkboxSize, checkboxSize, checkboxSize);         
         
         // reset zoom
         if (flashZoom > 0) {
            fill(155, 155, 155);
            flashZoom--;
         } else {
            noFill();
         }
         rect(resetZoomCheckboxX, resetOptionsY-checkboxSize, checkboxSize, checkboxSize);
      }
   }
   
   
   float getZoomValue(int y) {
      if ((y >= minZoomY) && (y <= (maxZoomY - zoomSliderHeight/2))) {
         zoomSliderY = (int) (y - (zoomSliderHeight/2));     
         if (zoomSliderY < minZoomY) { 
            zoomSliderY = minZoomY; 
         } 
         zoomSliderValue = (y - minZoomY) * zoomValuePerY + minZoomValue;
      }     
      return zoomSliderValue;
   }
   
   
   void updateZoomSlider(float value) {
      int tempY = (int) (value / zoomValuePerY) + minZoomY;
      if ((tempY >= minZoomY) && (tempY <= (maxZoomY-zoomSliderHeight))) {
         zoomSliderValue = value;
         zoomSliderY = tempY;
      }
   }


   boolean isZoomSliderEvent(int x, int y, boolean draggingZoomSlider) {
      int slop;  // number of pixels above or below slider that's acceptable. 
      if (draggingZoomSlider) {
         slop = 35; 
      } else {
         slop = 0;  // allow less slop when user initially grabs zoom control
      }
      int sliderTop = (int) (zoomSliderY - (zoomSliderHeight/2)) - slop;
      int sliderBottom = zoomSliderY + zoomSliderHeight + slop;
      return ((x >= (zoomSliderX-slop)) && (x <= (zoomSliderX+zoomSliderWidth+slop)) && (y >= sliderTop)  && (y <= sliderBottom));
   } 
   
   
   boolean isOptionsEvent(int x, int y) {
      
      if (isShowOptionsEvent(x, y)) {
         showOptions = -1 * showOptions; 
      }
            
      else if (showOptions > 0) {
         int slop = 10;  // number of pixels above or below toggle frame that's acceptable. 
         int optionsTop = optionsY - slop;
         int optionsBottom = optionsY + optionsHeight + slop;
         if ((x >= (optionsX-slop)) && (x <= (optionsX+optionsWidth+slop)) && (y >= optionsTop)  && (y <= optionsBottom)) {             
            return true;            
         }         
      }
      
      return false;
   }
   
   
   boolean isShowOptionsEvent(int x, int y) {
      
      int slop = 15;  // number of pixels around showToggle control that's acceptable.  
      int showOptionsTop = optionsToggleY - slop;
      int showOptionsBottom = optionsToggleY + slop;      
      return ((x >= (optionsToggleX-slop)) && (x <= (optionsToggleX+optionsToggleSize+slop)) && (y >= showOptionsTop)  && (y <= showOptionsBottom));       
   }
   
   
   String getSelectedOption(int x, int y) {

      if (showOptions > 0) {
         
         int slop = 5;  // number of pixels above or below checkbox that's acceptable. 
         
         // unsorted?        
         int sortTop = sortOptionsY-checkboxSize - slop;
         int sortBottom = sortOptionsY + slop;
         if ((x >= (sortNoneCheckboxX-slop)) && (x <= (sortNoneCheckboxX+checkboxSize+slop)) && (y >= sortTop)  && (y <= sortBottom)) { 
            sortOptionValue = 0;           
            return "`";            
         }   
   
         // sort by size?        
         if ((x >= (sortSizeCheckboxX-slop)) && (x <= (sortSizeCheckboxX+checkboxSize+slop)) && (y >= sortTop)  && (y <= sortBottom)) {     
            sortOptionValue = 1;       
            return "1";            
         }  
         
         // sort by temp?        
         if ((x >= (sortTempCheckboxX-slop)) && (x <= (sortTempCheckboxX+checkboxSize+slop)) && (y >= sortTop)  && (y <= sortBottom)) {    
            sortOptionValue = 2;        
            return "2";            
         }  
         
         // reset flatness?
         int resetTop = resetOptionsY-checkboxSize - slop;
         int resetBottom = resetOptionsY + slop;
         if ((x >= (resetFlatnessCheckboxX-slop)) && (x <= (resetFlatnessCheckboxX+checkboxSize+slop)) && (y >= resetTop)  && (y <= resetBottom)) {    
            flashFlatness = 50;      
            return "f";            
         }  
         
         // reset rotation?
         if ((x >= (resetRotationCheckboxX-slop)) && (x <= (resetRotationCheckboxX+checkboxSize+slop)) && (y >= resetTop)  && (y <= resetBottom)) {    
            flashRotation = 50;      
            return "3";            
         }           
         
         // reset zoom?
         if ((x >= (resetZoomCheckboxX-slop)) && (x <= (resetZoomCheckboxX+checkboxSize+slop)) && (y >= resetTop)  && (y <= resetBottom)) {    
            flashZoom = 50;      
            return "4";            
         }            
      }
            
      return " ";
   }
   
   
   private void setOption(String value) {
      if (value.equals("`")) {
         sortOptionValue = 0;
      } else if (value.equals("1")) {
         sortOptionValue = 1;
      } else if (value.equals("2")) {
         sortOptionValue = 2;
      } else if (value.equals("f")) {
         flashFlatness = 50;
      } else if (value.equals("3")) {
         flashRotation = 50;
      } else if (value.equals("4")) {
         flashZoom = 50;
      }
   }

   
}



