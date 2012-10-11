// Began with ModestMaps Processing Library + Examples : https://github.com/RandomEtc/modestmaps-processing
import com.modestmaps.*;
import com.modestmaps.core.*;
import com.modestmaps.geo.*;
import com.modestmaps.providers.*;

import processing.pdf.*;

Location[] locations;

void setup() {
  size(screen.width/2, screen.width/2);
  smooth();
//  if (!runTests(false)) {
//    println("one or more tests failed");
//    exit();
//  }
  
  loadXML();
  
  noLoop();
}

void draw() {

  //StaticMap m = new StaticMap(this, new Microsoft.AerialProvider(), new Point2f(width/2, height), new Location(51.5, -0.137), 12);
  StaticMap m = new StaticMap(this, new Microsoft.RoadProvider(), new Point2f(width, height), new Location(40.737893,-74.006653), 12);
  
  //Fetch and draw map tiles
  PImage img = m.draw(true);
  image(img,0,0);
  
  beginRecord(PDF, "output.pdf"); 
  
  stroke(0);
  
  noFill();
  beginShape();
  
  for (int i = 0; i < locations.length; i ++ ) {
    Location location = locations[i];
    Point2f p = m.locationPoint2f(location);
    vertex(p.x, p.y);
    // curveVertex(p.x, p.y); // Draws curves between points
    //println("Printed " + i + ": " + location.lat + ", " + location.lon + "  ->  " + p.x + ", " + p.y);
  }
  
  endShape();
  
  endRecord();
  println("Complete");  
}

void loadXML() {
  XMLElement xml = new XMLElement(this, "checkins.kml" ); 
  int totalLocations = xml.getChild(0).getChildCount();
  //println("totalLocations = " + totalLocations);
  
  locations = new Location[totalLocations-2];  // Minus two for name and description elements at top
  
  XMLElement[] children = xml.getChild(0).getChildren();
  
  for (int i = 0; i < children.length; i ++ ) {
    String elementName = children[i].getName();
    if (elementName.equals("Placemark") == true) {
      String locationName = children[i].getChild(0).getContent();
      String latLong = children[i].getChild(5).getChild(2).getContent();
      String[] latLongArray = split(latLong, ',');
      float latitude = Float.parseFloat(latLongArray[1]);
      float longitude = Float.parseFloat(latLongArray[0]);
      
      locations[i-2] = new Location(latitude,longitude);      
      //println(i + ": " + locationName + " @ " + latLongArray[0] + ", " + latLongArray[1]);
    }
  }

}
