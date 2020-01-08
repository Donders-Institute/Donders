import java.io.*;
import java.net.*;

import javax.imageio.*;
import java.awt.image.*;  

import gohai.glvideo.*;

GLCapture video;


// This is the port we are sending to
int    clientPort = 9100; 
String ip_remote ="192.168.1.101";

String actual_address_client ="";
String old_address_client    ="";

// This is our object that sends UDP out
DatagramSocket ds; 

Boolean flag =false;

// threads
udp_Threads hilo_send,hilo_recv;

void setup() 
{
      size(320, 240, P2D);
    
      hilo_recv = new udp_Threads(500,"recv");
      hilo_recv.port = 5001;
      hilo_recv.lab  = "9100";
      hilo_recv.start();
  
      // Setting up the DatagramSocket, requires try/catch
      try {
        ds = new DatagramSocket();
      } catch (SocketException e) {
        e.printStackTrace();
      }
   
      String[] devices = GLCapture.list();
      println("Devices:");
      printArray(devices);
      if (0 < devices.length) {
        String[] configs = GLCapture.configs(devices[0]);
        println("Configs:");
        printArray(configs);
      }
  
      // this will use the first recognized camera by default
      // video = new GLCapture(this);
  
      // you could be more specific also, e.g.
      // video = new GLCapture(this, devices[0]);
      video = new GLCapture(this, devices[0], 320, 240, 25);
      //video = new GLCapture(this, devices[0], configs[0]);
  
      video.start();
    
      
      int count = video.width * video.height;  
}

void draw() 
{
      background(0);
      
      if (video.available()) 
      {
          video.read();
          broadcast(video);
      }
      image(video, 0, 0, width, height);
  

      pushMatrix();
          int index = 0;
          video.loadPixels();
  
      popMatrix();
}


void captureEvent(GLCapture c) 
{
      println("Sending image...");
      c.read();
      // Whenever we get a new image, send it!
      broadcast(c);
}


void broadcast(PImage img) 
{
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
        if (hilo_recv.flag_stream_on == true){
          ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(hilo_recv.address_client),clientPort));
        }
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
    
    
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