import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.AWTException;
 
PImage screenshot;

PImage[] imageV = new PImage[1000];
 
//static final String RENDERER = JAVA2D;
static final String RENDERER = FX2D;
 
static final int FPS = 60, DELAY = 1000/FPS/4, SMOOTH = 3;
 
void setup() {
  size(800, 600, RENDERER);
 
  smooth(SMOOTH);
  frameRate(FPS);
  imageMode(CORNER);
 
  screenshot = createImage(displayWidth, displayHeight, ARGB);
  thread("screenshotThread");
}
 
 int cnt =0;
void draw() {
  image(screenshot, 0, 0, width, height);
  imageV[cnt] = screenshot; 
  frame.setTitle("FPS: " + round(frameRate));
  
  cnt++;
  if(cnt<1000){cnt=0;}
  
  //saveFrame("output.jpg");
}
 
void screenshotThread() {
  final PImage shot = screenshot;
  final Rectangle dimension = new Rectangle(displayWidth, displayHeight);
  final Robot robot;
 
  try {
    robot = new Robot();
  }
  catch (AWTException cause) {
    exit();
    throw new RuntimeException(cause);
  }
 
  for (;; delay(DELAY))  grabScreenshot(shot, dimension, robot);
}
 
static final PImage grabScreenshot(PImage img, Rectangle dim, Robot bot) {
  bot.createScreenCapture(dim).getRGB(
    0, 0, 
    dim.width, dim.height, 
    img.pixels, 0, dim.width);
 
  img.updatePixels();
  return img;
}




/**
 * Forum.Processing.org/two/discussion/15674/speed-of-screenshots#Item_5
 * Forum.Processing.org/two/discussion/8025/take-a-screen-shot-of-the-screen
 */
