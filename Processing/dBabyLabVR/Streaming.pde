import java.net.InetAddress;
import java.net.UnknownHostException;

import java.util.Base64;

import java.io.*;
import java.net.*;

import javax.imageio.*;
import java.awt.image.*;  



// This is the port we are sending to
int    clientPort = 9200; 
int    clientPort_2 = 9100;
String ip_remote ="localhost";
// This is our object that sends UDP out
DatagramSocket ds; 

Boolean flag =true;

void streaming(PImage img) 
{
  
  
      long a =System.currentTimeMillis();
  
      // We need a buffered image to do the JPG encoding
      BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );
    
      // Transfer pixels from localFrame to the BufferedImage
      img.loadPixels();
      bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);
    
      // Need these output streams to get image as bytes for UDP communication
      ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
      BufferedOutputStream bos        = new BufferedOutputStream(baStream);
    
      // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
      // Requires try/catch
      try {
        ImageIO.write(bimg, "jpg", bos);
      } 
      catch (IOException e) {
        e.printStackTrace();
      }
    
      // Get the byte array, which we will send out via UDP!
      byte[] packet = baStream.toByteArray();
    
    
      //I AM TRYING THIS
      
      try {
        //if (hilo_wait.flag_on == true){
          ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(ip_remote),clientPort));
     //     hilo_wait.flag_on =false;    
     //}
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
    
      long b =System.currentTimeMillis();
    
      println("streaming time: "+(b-a));
    
      //THIS WAS WORKING
      //try {
      //        if(new String(hilo_recv.address_client).equals("0.0.0.0"))
      //        {
      //            println("waiting for a client...");
      //            flag=true;
      //            actual_address_client = hilo_recv.address_client;
      //        }
      //        else
      //        {                
      //           // Send JPEG data as a datagram
      //           println("Sending datagram with " + packet.length + " bytes");
      //           ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(ip_remote),clientPort));
                 
      //           if(!new String(hilo_recv.address_client).equals(actual_address_client)||(hilo_recv.flag_stream_on==true))
      //           {
      //               String  msg = "1234";
      //               byte[] pac = msg.getBytes();
      //               ds.send(new DatagramPacket(pac,pac.length, InetAddress.getByName(ip_remote),4001));
      //               //flag=false;
      //               println(msg);
      //               actual_address_client    = hilo_recv.address_client;
      //               hilo_recv.flag_stream_on = false;
      //           }
                 
      //        }
      //} 
      //catch (Exception e) {
      //  e.printStackTrace();
      //}
}


void streaming_2(BufferedImage bimg) 
{
  
  
      long a =System.currentTimeMillis();
  
      //// We need a buffered image to do the JPG encoding
      //BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );
    
      //// Transfer pixels from localFrame to the BufferedImage
      //img.loadPixels();
      //bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);
    
      // Need these output streams to get image as bytes for UDP communication
      ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
      BufferedOutputStream bos        = new BufferedOutputStream(baStream);
    
      // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
      // Requires try/catch
      try {
        ImageIO.write(bimg, "jpg", bos);
      } 
      catch (IOException e) {
        
        println("problem");
        //e.printStackTrace();
      }
    
      // Get the byte array, which we will send out via UDP!
      byte[] packet = baStream.toByteArray();
      
      println(packet.length);
    
      //I AM TRYING THIS
      
      try {
        //if (hilo_wait.flag_on == true){
          ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(ip_remote),clientPort));
     //     hilo_wait.flag_on =false;    
     //}
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
    
      long b =System.currentTimeMillis();
    
      println("streaming time: "+(b-a));
    
      //THIS WAS WORKING
      //try {
      //        if(new String(hilo_recv.address_client).equals("0.0.0.0"))
      //        {
      //            println("waiting for a client...");
      //            flag=true;
      //            actual_address_client = hilo_recv.address_client;
      //        }
      //        else
      //        {                
      //           // Send JPEG data as a datagram
      //           println("Sending datagram with " + packet.length + " bytes");
      //           ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(ip_remote),clientPort));
                 
      //           if(!new String(hilo_recv.address_client).equals(actual_address_client)||(hilo_recv.flag_stream_on==true))
      //           {
      //               String  msg = "1234";
      //               byte[] pac = msg.getBytes();
      //               ds.send(new DatagramPacket(pac,pac.length, InetAddress.getByName(ip_remote),4001));
      //               //flag=false;
      //               println(msg);
      //               actual_address_client    = hilo_recv.address_client;
      //               hilo_recv.flag_stream_on = false;
      //           }
                 
      //        }
      //} 
      //catch (Exception e) {
      //  e.printStackTrace();
      //}
}
