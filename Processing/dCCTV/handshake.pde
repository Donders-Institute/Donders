import java.net.InetAddress;
import java.net.UnknownHostException;

import java.util.Base64;

static final String LOCAL_IP = findLanIp();

// This is our object that sends/recev UDP out
DatagramSocket sendDS; 
DatagramSocket receiveDS; 

void handshake() 
{                       
          int a=192,b=168,c=2;
          int Port = 5001;  
                         
          //String salutation = "Hi there, I am "+LOCAL_IP+" and I need your data.";
          String salutation ="start";
          println(salutation); 
  
          byte[] packet = salutation.getBytes();
  
          // Setting up the DatagramSocket, requires try/catch
          try {
            sendDS= new DatagramSocket();
          } catch (SocketException e) {
            e.printStackTrace();
          }
           
          for (int i =1; i<256; i++)
          {
                String ip = a+"."+b+"."+c+"."+i;
                println(ip);     
                     
                // Send JPEG data as a datagram
                println("Sending datagram with " + packet.length + " bytes");
                try {                     
                   sendDS.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(ip),Port));
                } 
                catch (Exception e) {
                  e.printStackTrace();
                }
              
          }
                   
}

void send_commands(String command, String ip_address, int port_ip) 
{                       
          println(command + "-"+ ip_address +"-"+ port_ip); 
  
          byte[] packet = command.getBytes();
  
          // Setting up the DatagramSocket, requires try/catch
          try {
            sendDS= new DatagramSocket();
          } catch (SocketException e) {
            e.printStackTrace();
          }

          try {                     
            sendDS.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(ip_address),port_ip));
          } 
          catch (Exception e) {
            e.printStackTrace();
          }
}



 void checkForLivingServers() 
 {
        //this piece of code does not work if I have working the thre ReceiverThread class 
   
   
        // A byte array to read into (max size of 65536, could be smaller)
        byte[] buffer_recv = new byte[65536]; 
        int recv_port=6001;
        
        // Setting up the DatagramSocket, requires try/catch
        try {
            receiveDS= new DatagramSocket(recv_port);
        } catch (SocketException e) {
            e.printStackTrace();
        }
        
       
        DatagramPacket message = new DatagramPacket(buffer_recv, buffer_recv.length); 
       // receiveDS.setSoTimeout(1000);
        try {
           
          receiveDS.receive(message);
        } 
        catch (IOException e) {
          e.printStackTrace();
        } 
        

        byte[] data = message.getData();
      
        println("Received datagram with " + data.length + " bytes." );
      
        String s = Base64.getEncoder().encodeToString(data);
          
        println(s);
}






static final String findLanIp()
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