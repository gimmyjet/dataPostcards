import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.providers.*;

/*
* By Clicking on the map a DataPostcard is created for that position
 *
 *
 */

UnfoldingMap map;
Location berlin;
MarkerManager mManager;
Marker m;

ImgBuilder ib;
PImage img;

void setup() {
  size(800, 800);

  map = new UnfoldingMap(this);
  MapUtils.createDefaultEventDispatcher(this, map);
  mManager = new MarkerManager();
  map.addMarkerManager(mManager);
  berlin = new Location(52.5f, 13.4f);
  map.zoomAndPanTo(berlin, 12);
  float maxPanningDistance = 20; // in km
  map.setPanningRestriction(berlin, maxPanningDistance);
  
  ib = new ImgBuilder();
  img = new PImage();
}



void draw() {
  map.draw();
  image(img,0,0,100,100);
}

void mouseClicked(){
  mManager.removeMarker(m);
  println("test");
  Location l = map.getLocation(mouseX, mouseY);
  m = new SimplePointMarker(l);
  mManager.addMarker(m);
  img = ib.getImage(l);
}

