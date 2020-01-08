import processing.video.*;  
Capture video;


//this goes in the setup function
//this work on MAC 
//video = new Capture(this, 320, 240);  
//video.start();

//this goes in the draw
//image(video, 0, 0);


void captureEvent(Capture video) {
  video.read();
}