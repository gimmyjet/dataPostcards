//Bounds: 12.9749,52.2917,13.8895,52.7197

PImage map;
MercatorMap mercatorMap;
Insta insta;

int radius=5;

PFont f;


//test stuff
String lat = "52.520436";
String lng = "13.409975";
color c;
PVector place;

void setup() {
  size(1000, 769);
  smooth();
  rectMode(RADIUS);
  fill(255);


  // Loading exported image
  map = loadImage("BerlinInsta.png");
  // Map with dimension and bounding box
  mercatorMap = new MercatorMap(width, height, 52.7197, 52.2917, 12.9749, 13.8895);
  insta = new Insta();

  PVector start = new PVector (300, 300);
  PVector pos = new PVector(start.x, start.y);
  place = mercatorMap.getScreenLocation(new PVector(52.520436, 13.409975));



  PVector geo = mercatorMap.getLatLngFromPixel(place);
  println(geo);
}

void draw() {
  image(map, 0, 0, width, height);
  rect(place.x, place.y, radius, radius);
  text("x:"+mouseX+";y:"+mouseY, 10, 10);

  float lat=52.564892;
  float latStart=52.564892;

  float lng = 13.272621;
  PVector v;
  for (int i=0; i<25; i++) {
    //do stuff
    //get geolocation from pixels
    lat-=0.022;
    if (i%5==0) {

      lng+=0.037;
      lat=latStart;
    }
    v = mercatorMap.getScreenLocation(new PVector(lat, lng));
    c = insta.getPixel(lat+"", lng+"");
    fill(c);
    println(v);
    rect(v.x, v.y, 20, 20);
  }

  noLoop();
}

