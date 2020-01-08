//no error handling for non image files!
 
int MIN_WINDOW_WIDTH = 128;
int MIN_WINDOW_HEIGHT = 128;
 
 
PImage img;
int newCanvasWidth  = MIN_WINDOW_WIDTH;  // made global to  use in draw
int newCanvasHeight = MIN_WINDOW_HEIGHT;
String path ="";
 
java.awt.Insets insets;  //"An Insets object is a representation of the borders of a container"
//from: docs.oracle.com/javase/1.4.2/docs/api/java/awt/Insets.html
 
void setup() {
  size(400, 200);
  frame.pack();     //frame.pack() ... plus insets
  insets = frame.getInsets();
  surface.setResizable(true);
 
  /// for debuging, system dependent, at least screen is...
  print("MIN_WINDOW_WIDTH = " + MIN_WINDOW_WIDTH);
  print("   MIN_WINDOW_HEIGHT = " + MIN_WINDOW_HEIGHT);
  print("   screenWidth = " + displayWidth);
  println("    screenHeight = " + displayHeight);
 
  text("click window to load an image", 10, 100);
}
 
void draw() {
  if (img != null) {
    image(img, 0, 0, newCanvasWidth, newCanvasHeight);
  }
}
 
void getImageAndResize() { 
  selectInput("select an image", "handleImage");
}
 
void handleImage(File selection) {
  if (selection== null) {
    println ("nono");
  } 
  else {
    path = selection.getAbsolutePath();
    img = loadImage(path);
 
    // a temp variable for readability 
    int widthInsets =insets.left + insets.right;
    int heightInsets =insets.top + insets.bottom;
 
    // constrain values between screen size and minimum window size
    int newFrameWidth  = constrain(img.width + widthInsets, MIN_WINDOW_WIDTH, displayWidth);
    int newFrameHeight = constrain(img.height + heightInsets, MIN_WINDOW_HEIGHT, displayHeight);
 
    // Canvas should consider insets for constraining? I think so...
    newCanvasWidth  = constrain(img.width, MIN_WINDOW_WIDTH - widthInsets, displayWidth - widthInsets);
    newCanvasHeight = constrain(img.height, MIN_WINDOW_HEIGHT - heightInsets, displayHeight - heightInsets);
 
    // set canvas size to img size WITHOUT INSETS
    // set frame size to image + Insets size
    setSizes(newCanvasWidth, newCanvasHeight, newFrameWidth, newFrameHeight);
 
    //// for debuging
    println(path);
    println(" ");
    print("imgW      = " + img.width);
    println("   imgH       = " + img.height);
    print("width+ins = " + widthInsets);
    println("      height+ins = " + heightInsets);
    print("nFrameW   = " + newFrameWidth);
    println("   nFrameH    = " + newFrameHeight);
    print("nCanvasw  = " + newCanvasWidth);
    println("   nCanvsH    = " + newCanvasHeight);
    println(" ------  ");
  }
  println(width + "  "+ height);
}
 
void setSizes (int canvasX, int canvasY, int frameX, int frameY) {
  // set canvas size to img size WITHOUT INSETS
  setSize(canvasX, canvasY);
 
  // set frame size to image + Insets size
  surface.setSize(frameX, frameY);
  println(width + "  "+ height);
}
 
void mouseClicked() {
  img = null;
  getImageAndResize();
}