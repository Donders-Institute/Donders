import java.awt.Robot;
import java.awt.image.BufferedImage;
import java.awt.Rectangle;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Toolkit;

Robot robot;
Point mouse;
Rectangle r;
BufferedImage img1;
PImage img2;

void setup() {

     size(displayWidth, displayHeight); // simulator resolution
     //fullScreen();

     try { robot = new Robot(); }
     catch (Exception e) { println(e.getMessage()); }
     r = new Rectangle(Toolkit.getDefaultToolkit().getScreenSize());
     img1 = new BufferedImage(displayWidth, displayHeight, BufferedImage.TYPE_INT_RGB);

     stroke(255, 0, 0, 75);
     strokeWeight(6);
     fill(255, 255, 255, 100);
     frameRate(30);

}//setup

void draw() {

     //background(0);
     long startTime = System.nanoTime();

     img1 = robot.createScreenCapture(r);
     img2 = new PImage(img1);
     image(img2, 0, 0);

     //mouse = MouseInfo.getPointerInfo().getLocation();
    // ellipse(mouse.x, mouse.y, 50, 50);

     saveFrame("data/screen-######.jpeg");
     

     long endTime = System.nanoTime();

     println((endTime - startTime)/1000000);  //divide by 1000000 to get milliseconds.
     
     
     //saveFrame("#######.jpeg");

}//draw
