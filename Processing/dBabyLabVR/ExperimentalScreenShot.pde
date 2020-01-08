/**
 * Robot Screenshots (v3.15)
 * GoToLoop (2016-Mar-24)
 *
 * Forum.Processing.org/two/discussion/15674/speed-of-screenshots#Item_5
 * Forum.Processing.org/two/discussion/8025/take-a-screen-shot-of-the-screen
 */
 
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.AWTException;
 
PImage screenshot;
 
//static final String RENDERER = JAVA2D;
static final String RENDERER = FX2D;
 
static final int FPS = 60, DELAY = 1000/FPS/4, SMOOTH = 3;


void ini_screenshot()
{


  smooth(SMOOTH);
  frameRate(FPS);
  imageMode(CORNER);
 
  screenshot = createImage(displayWidth, displayHeight, ARGB);
  thread("screenshotThread");

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
