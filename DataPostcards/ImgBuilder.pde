import http.requests.*;
import de.fhpotsdam.unfolding.*;


class ImgBuilder {


  StringList inventory;
  PImage[] imgArray;

  void ImgBuilder() {
  }

  PGraphics getImage(Location l) {
    int[] locationIDs = getLocationID(l.getLat()+"", l.getLon()+"");

    StringList imgURL = new StringList();
    for (int i=0; i<locationIDs.length; i++) {
      imgURL.append(getImgFromLocID(locationIDs[i]));
    }

    PImage[] imgArray = new PImage[imgURL.size()];
    for (int i=0; i<imgArray.length; i++) {
      imgArray[i] = loadImage(imgURL.get(i));
    }

    PImage img = imgArray[0];
    img.loadPixels();

    println(img.pixels.length);
    println(imgArray.length);

//build an blended image
    PGraphics imgBlend = createGraphics(img.width, img.height);
    imgBlend.beginDraw();
    imgBlend.fill(255,255,255);
    imgBlend.rect(0,0,img.width, img.height);
    imgBlend.tint(255, 10);
    for (int i=0; i<imgArray.length; i++) {
      imgBlend.image(imgArray[i], 0, 0);
    }
    
    imgBlend.endDraw();

    //    //how to create the avg img??
    //    for (int i=0; i<img.pixels.length; i+=2) {
    //
    //      //calc avg color for earch pixel
    //      color c = getAvgColor(i, imgArray);
    //
    //      img.pixels[i] = c;
    //      
    //      println("------------->   "+i);
    //    }

    return imgBlend;
  }
  private color getAvgColor(int index, PImage[] imgArray) {

    float red = 0;
    float green=0;
    float  blue = 0;
    for (PImage img : imgArray) {
      image(img, 300, 300, 200, 200);
      img.loadPixels();
      color tmpC = img.pixels[index];
      // println(tmpC);
      red = red + red(tmpC);
      green += green(tmpC);
      blue += blue(tmpC);
    }
    red =red / imgArray.length;
    green =green / imgArray.length;
    blue =blue / imgArray.length;

    color c = color(red, green, blue);
    println("red:"+red(c));
    println("green:"+green(c));
    println("blue:"+blue(c));
    println("------------------");

    return c;
  }



  ///////////////////////////////////////////////////////////////////////////

  StringList getImgFromLocID(int locID) {
    StringList imgURL = new StringList();
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
    return imgURL;
  }

  ////////////////////////////////////////////////////////////////////////////

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


/////////////////////////////////////////////////////////////////////////////

//color getPixel(String lat_, String lng_) { 
//  lat = lat_;
//  lng = lng_;
//
//  imgURL= new StringList();
//  //gather the data 
//
//  int[] locIDArray = getLocationID(lat, lng);
//  for (int locID : locIDArray) {
//    getImgFromLocID(locID);
//  }
//
//  //load the images
//  imgArray = new PImage[imgURL.size()];
//  for (int i=0; i<imgArray.length; i++) {
//    imgArray[i] = loadImage(imgURL.get(i));
//    println(imgURL.get(i));
//    // image(imgArray[i],0,0);
//  }
//  println(imgArray.length);
//  color c=color(255, 255, 255);
//  if (imgArray.length!=0) {
//    c=processImg();
//  }
//
//  return c;
//}

/////////////////////////////////////////////////////////////////////////  

//color processColor() {
//  color blueAvg=0;
//  color redAvg=0;
//  color greenAvg=0;
//  int counter=1;
//
//  tint(255, 10);
//
//  for (int i=1; i<imgArray.length; i++) {
//    PImage img = imgArray[i];
//    //   image(img, 0, 0, 600, 600);
//    //sample random pixels
//    for (int j=0; j<20; j++) {
//      color c = img.pixels[(int)random(0, img.pixels.length-1)];
//      blueAvg += blue(c);
//      redAvg +=red(c);
//      greenAvg += green(c);
//      counter++;
//    }
//  }
//  color c = color(redAvg/counter, greenAvg/counter, blueAvg/counter);
//  fill(c);
//
//  noStroke();
//  rect(0, 0, 10, 10);
//  return c;
//}

