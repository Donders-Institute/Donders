class commands
{
     Boolean flag_found;
     String lab;
     String command;
     String ip;
     int port;
    
     boolean flag_active_lab = false;
     boolean flag_reset_lab  = false;
    
     
     // This is our object that sends/recev UDP out
     DatagramSocket sendDS; 
     DatagramSocket receiveDS; 
     
          
     commands(String Lab)
     {
        lab = Lab;
     }
   
     void cPlay(){        send_commands("play", ip, port);    }
     
     void cStop(){        send_commands("stop", ip, port);    }
     
     void cPause(){       send_commands("pause", ip, port);   }
     
     void cCommand(){     send_commands(command, ip, port);   }
     
     void cScann() 
     {                       
          //int a=192,b=168,c=1;
          //int a=192,b=168,c=200;// this one for my pc router
          int a=192,b=168,c=193; // this configuration for the cubicles
          //int a=192,b=168,c=1;//193
          int Port = 5001;  
                         
          //String salutation = "Hi there, I am "+LOCAL_IP+" and I need your data.";
          
          String salutation =lab; //9100
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

}
