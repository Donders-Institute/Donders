/*
JPEG COMPRESSION
 Jeff Thompson | 2016 | www.jeffreythompson.org

 For web-based images, controlling the compression of a JPG
 can optimize dimensions and file size. The built-in save()
 command for Processing doesn't give us this control, but we
 can use Java's ImageIO to add this functionality.
 */

import java.awt.image.BufferedImage;
import javax.imageio.plugins.jpeg.*;
import javax.imageio.*;
import javax.imageio.stream.*;

class compression
{
  // set the amount of compression
  // 1.0 = no compression, largest image file
  // 0.5 = 50% compression
  // 0.0 = 100% compression, smallest image file
  float compressionLevel = 0.1;
  
  // image to compress and image to output
  //String imageFile = sketchPath("") + "Jose.jpg";              
  //String outputFilename = sketchPath("") + "Josecompressed.jpg";
  
  // image to compress and image to output
  String imageFile = "";              
  String outputFilename = ""; 
  
  
   compression(){}

   
   void compressing(String image, String compressed_Image)
   {
     
      imageFile = image;              
      outputFilename = compressed_Image; 
       
      try {
            // setup JPG output
            JPEGImageWriteParam jpegParams = new JPEGImageWriteParam(null);
            jpegParams.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
            jpegParams.setCompressionQuality(compressionLevel);
            final ImageWriter writer = ImageIO.getImageWritersByFormatName("jpg").next();
            writer.setOutput(new FileImageOutputStream(new File(outputFilename)));
        
            // load image to compress
            // alternatively, you could access the sketch's pixel array and save it
            PImage img = loadImage(imageFile);
            img.loadPixels();
        
            // output to BufferedImage object
            // create the object, then write the pixel data to it
            BufferedImage out = new BufferedImage(img.width, img.height, BufferedImage.TYPE_INT_RGB);
            for (int i=0; i<img.pixels.length; i++) {
              out.setRGB(i%img.width, i/img.width, img.pixels[i]);
            }
        
            // save it!
            writer.write(null, new IIOImage(out, null, null), jpegParams);
            println("Saved!");
       }
       catch (Exception e) 
       {
            println("Problem saving... :(");
            println(e);
       }
             
     
   
   }
   
}