import java.awt.Robot;
import java.awt.image.BufferedImage;
import java.awt.Rectangle;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Toolkit;


import java.awt.Color;
import java.awt.Dimension;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File; 
import javax.imageio.ImageIO;
import javax.swing.*;  
   
  
Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
Rectangle screenRectangle = new Rectangle(screenSize);
//Robot robot = new Robot();   
   
compression micompression = new compression();   
  
timeStamp tStamp = new timeStamp();   
   
PImage img,img1;   
  
PImage newImage;
 
 
threads hilo_screenShot,hilo_video,hilo_save, hilo_wait; 

void setup() 
{
     size(1440, 900); // simulator resolution
     //frameRate(120);
              
     video = new Capture(this, 640/2, 480/2);  
     video.start();  
     
     newImage = createImage(640/2, 480/2, RGB);
     
     
     ini_os();  
     
     
  smooth(SMOOTH);
  frameRate(FPS);
  imageMode(CORNER);
 
  screenshot = createImage(displayWidth, displayHeight, ARGB);
  thread("screenshotThread");
     
     hilo_video = new threads(400,"video");      
     hilo_video.start(); 
     
     
     hilo_screenShot = new threads(40,"ScreenShot");      
     hilo_screenShot.start(); 
     
     hilo_save = new threads(50,"ScreenShot");      
     hilo_save.start();
     
     
     //hilo_wait = new threads(400,"waitt");      
     //hilo_wait.start(); 
     
     
       // Setting up the DatagramSocket, requires try/catch
  try {
    ds = new DatagramSocket();
  } catch (SocketException e) {
    e.printStackTrace();
  }
     
     
     
     
}

float time_old=0;
float time_new=0;

void draw()
{
      frame.setTitle("FPS: " + round(frameRate));
     //  Date date= new Date();
     //  time = date.getTime();
  
     //  Timestamp ts = new Timestamp(time);
     //  println("Current Time Stamp: " + ts);
     
     time =millis();
     //println(time);
  
      if(flag_os == 2)
      { 
           try{ 
             //captureScreen("/Users/jgarcia/Documents/allmystuffatdccn/Processing/dCaptureScreen_test_1/data/jose_"+frameCount+".jpeg");
             captureScreen(dataPath("")+"/img/img_"+frameCount+"_"+time+".jpg");
            
           }catch(Exception e)
           {
             println(e);
           }
           
           //micompression.compressing(dataPath("")+"/img/img_"+frameCount+"_"+time+".jpg", dataPath("")+"/imgComp/imgC_"+frameCount+"_"+time+".jpg");
           
           //println(dataPath(""));
           
           //println(tStamp.getTime());
           
           //img =loadImage(dataPath("")+"/img/img_"+frameCount+"_"+time+".jpg");
       
       }
       if(flag_os == 1)
       { 
           try{ 
             //captureScreen("/Users/jgarcia/Documents/allmystuffatdccn/Processing/dCaptureScreen_test_1/data/jose_"+frameCount+".jpeg");
             //captureScreen(dataPath("")+"\\img\\img_"+frameCount+"_"+time+".jpg");
             //fullScreenFPSCheck_2();
           }catch(Exception e)
           {
             println(e);
           }
           
           //micompression.compressing(dataPath("")+"\\img\\img_"+frameCount+"_"+time+".jpg", dataPath("")+"\\imgComp\\imgC_"+frameCount+"_"+time+".jpg");
           
           //println(dataPath(""));
           
           //println(tStamp.getTime());
           
           //img =loadImage(dataPath("")+"\\img\\img_"+frameCount+"_"+time+".jpg");
       
        }
       
       
       //pushMatrix();
       //   scale(0.3);
       //   translate(10,10);
       //   image(img,0,10); 
       //   // can appears in the frame if you make bigger the screen 
          
       //   scale(6);
       //   translate(150,0);
          
       //   image(video, 300, 0);    
       //popMatrix();
       
       //here the camera doesnt need to appear in the frame
       //newImage = video.get();
       //newImage.save("outputImage.jpg");  
       
       
       time_new =millis();
       //println("One frame every "+ (time_new-time) +"ms");
       
}

public void captureScreen(String fileName) throws Exception 
{  
      // Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
      // Rectangle screenRectangle = new Rectangle(screenSize);
       Robot robot = new Robot();
       
       BufferedImage image = robot.createScreenCapture(screenRectangle);
       ImageIO.write(image, "jpeg", new File(fileName));
       
       println(frameCount);
       
       //clean memory usage
      // System.gc();        
}
