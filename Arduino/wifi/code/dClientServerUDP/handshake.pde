import java.net.InetAddress;
import java.net.UnknownHostException;

import java.util.Base64;

import java.io.*;
import java.net.*;


class udp_Threads extends Thread
{
  
  String LOCAL_IP = findLanIp();
  
  // This is our object that sends/recev UDP out
  DatagramSocket sendDS; 
  DatagramSocket receiveDS;   
  
  boolean  running;
  float    wait;
  String   id;
  int      count;
  int      port = 5001; 
  String   ip;
  
  //////////////////////////////////////////////////////////////////
  udp_Threads (float w, String s)
  {
       wait    = w;
       running = false;
       id      = s;
       count   = 0;
  }
  //////////////////////////////////////////////////////////////////

  int getcount()
  {
      
      return count;
  }
  
  //////////////////////////////////////////////////////////////////
  
  void start()
  {
     running = true; 
     println("Starting the Thread with ID: "+id+" (it executes every " +wait+ " ms."); 
     
     super.start();
  }
  
  //////////////////////////////////////////////////////////////////
  void run()
  {
     while (running)
     {
        if(id=="send"){send();}
        if(id=="recv"){receive();}
        
        try
        {
           sleep((long)wait);
        }
        catch (Exception e){}
        
     }
     
     println("Id: " + id + " --> The thread has dead");
  }
  
  //////////////////////////////////////////////////////////////////
  public synchronized void send()
  {
        try
        {

          int a=192,b=168,c=1;
                         
          String salutation = "Hi there, I am "+LOCAL_IP+" and I need your data.";
          println(salutation); 
  
          byte[] packet = salutation.getBytes();
  
          // We create a socket
          // Setting up the DatagramSocket, requires try/catch
          try {
            sendDS= new DatagramSocket();
          } catch (SocketException e) {
            e.printStackTrace();
          }
           
          
          // We send the packet
          try {                     
            sendDS.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(ip),port));
          } 
          catch (Exception e) {
            e.printStackTrace();
          } 
         
           println("Sending....");  
           
           sendDS.close();
        }
        catch (Exception ex){}
      
  
  }
  
  //////////////////////////////////////////////////////////////////
  public synchronized void receive()
  {
        try
        {
  
          byte[] buffer = new byte[65536];
  
          // We create a socket
          // Setting up the DatagramSocket, requires try/catch
          try {
            receiveDS= new DatagramSocket(port);
          } catch (SocketException e) {
            e.printStackTrace();
          }
          
          
          DatagramPacket packet = new DatagramPacket(buffer,buffer.length);
           
          
          // We get the packet
          try {                     
            receiveDS.receive(packet);
          } 
          catch (Exception e) {
            e.printStackTrace();
          } 
          
          
          String strRecv = new String(packet.getData(), 0, packet.getLength()) + "  [from " + packet.getAddress().getHostAddress() + ":" + packet.getPort()+ "]"; 
      
          println(strRecv);
         
          receiveDS.close();
          
        }
        catch (Exception ex){}
  

  }
  
  
  //////////////////////////////////////////////////////////////////
  public synchronized String findLanIp()
  {
          try
          {
             return InetAddress.getLocalHost().getHostAddress();
          } 
          catch(final UnknownHostException notfound)
          {
             System.err.println("No LAN IP found");
             return "";
          }
    
  }
  
  //////////////////////////////////////////////////////////////////
  public synchronized void quit()
  {
        try
        {
           
           println("The is going to die....");
           running = false;
           
        }
        catch (Exception ex){}
  
  
  }


}
