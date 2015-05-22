import http.requests.*;
class Insta{
StringList imgURL;
StringList inventory;
PImage[] imgArray;

//52.516396, 13.377892 brandenburger tor
//52.521616, 13.445317 party?
//52.520436, 13.409975 alex
String lat;
String lng;

//void setup() {
//  size(600, 600);
//  imgURL= new StringList();
//}

Insta(){
  
}


color getPixel(String lat_, String lng_) { 
  lat = lat_;
  lng = lng_;
  
  imgURL= new StringList();
  //gather the data 

  int[] locIDArray = getLocationID(lat, lng);
  for (int locID : locIDArray) {
    getImgFromLocID(locID);
  }

  //load the images
  imgArray = new PImage[imgURL.size()];
  for (int i=0; i<imgArray.length; i++) {
    imgArray[i] = loadImage(imgURL.get(i));
    println(imgURL.get(i));
    // image(imgArray[i],0,0);
  }
  println(imgArray.length);
  color c=color(255,255,255);
  if(imgArray.length!=0){
    c=processImg();
  }
  
  return c;
}

void getImgFromLocID(int locID) {
  JSONObject o = loadJSONObject("https://api.instagram.com/v1/locations/"+locID+"/media/recent?access_token=3598843.15d6adc.36a98ee4564c45d3ae3c2121b96fe0dc");
  JSONArray data = o.getJSONArray("data");
  for (int i=0; i<data.size (); i++) {
    JSONObject jo = data.getJSONObject(i);
    //check if jo is an image
    if (jo.getString("type").equals("image")) {
      JSONObject images = jo.getJSONObject("images");
      JSONObject sr = images.getJSONObject("standard_resolution");  
      String s = sr.getString("url");
      imgURL.append(s);
    }
  }
}

color processImg() {
  color blueAvg=0;
  color redAvg=0;
  color greenAvg=0;
  int counter=1;

  tint(255, 10);

  for (int i=1; i<imgArray.length; i++) {
    PImage img = imgArray[i];
 //   image(img, 0, 0, 600, 600);
    //sample random pixels
    for (int j=0; j<20; j++) {
      color c = img.pixels[(int)random(0, img.pixels.length-1)];
      blueAvg += blue(c);
      redAvg +=red(c);
      greenAvg += green(c);
      counter++;
      
    }


  }
      color c = color(redAvg/counter, greenAvg/counter, blueAvg/counter);
    fill(c);
    
    noStroke();
    rect(0, 0, 10, 10);
    return c;
}

int[] getLocationID(String lat, String lng) {

  JSONObject o = loadJSONObject("https://api.instagram.com/v1/locations/search?lat="+lat+"&lng="+lng+"&access_token=3598843.15d6adc.36a98ee4564c45d3ae3c2121b96fe0dc&distance=500");
  JSONArray a = o.getJSONArray("data");
  int[] locIDArray = new int[a.size()];
  
  println(a);

  for (int i=0; i<a.size (); i++) {
    JSONObject o2 = a.getJSONObject(i);
    int id = o2.getInt("id");
    locIDArray[i] = id;
  }
  return locIDArray;
}
}
//void mouseClicked(){
//  saveFrame();
//}

