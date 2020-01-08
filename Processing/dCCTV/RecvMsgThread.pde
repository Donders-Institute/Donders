
class RecvMsgThread extends Thread {

        // Port we are receiving.
        //int port = 9700; 
        DatagramSocket DS; 
        // A byte array to read into (max size of 65536, could be smaller)
        byte[] buffer = new byte[65536]; 
      
        boolean running;    // Is the thread running?  Yes or no?
        boolean available;  // Are there new tweets available?
      
        boolean flag;
      
        String message= "Nothing";
        String address_server= "0.0.0.0";
      
        RecvMsgThread(int port){
          running = false;
          available = true; // We start with "loading . . " being available
      
          try {
           DS = new DatagramSocket(port);
          } catch (SocketException e) {
            e.printStackTrace();
          }
        }
      
        String getMessage() {
          // We set available equal to false now that we've gotten the data
          available = false;
          return message;
        }
      
        boolean available() {
          return available;
        }
      
        // Overriding "start()"
        void start () {
          running = true;
          super.start();
        }
      
        // We must implement run, this gets triggered by start()
        void run () {
          while (running) {
            //checkForMessage();
            checkForLivingServers();
            // New data is available!
            available = true;
            println("running");
          }
        }
      
        
           
        void checkForLivingServers() 
        {
      
         
              // A byte array to read into (max size of 65536, could be smaller)
              byte[] buffer_recv = new byte[55]; 
      
             
              DatagramPacket message = new DatagramPacket(buffer_recv, buffer_recv.length); 
              // receiveDS.setSoTimeout(1000);
              try {
                 
                DS.receive(message);
              } 
              catch (IOException e) {
                e.printStackTrace();
              } 
                    
              //String strRecv = new String(message.getData(), 0, message.getLength()) + "  [from " + message.getAddress().getHostAddress() + ":" + message.getPort()+ "]"; 
            
              String strRecv = new String(message.getData(), 0, message.getLength());
              
         
              
              if(new String(strRecv).equals("1234"))
              {  
                  //Address of the server
                  address_server = message.getAddress().getHostAddress();
                  int port_server = message.getPort();
                  println(address_server+":"+ port_server);
                  
                  flag = true;
                  
              }
              
              //Boolean found=false;
              
              //found = strRecv.contains("ping"); 
              //if (found){
              //  println(strRecv);
                
              //  println(strRecv.length());
                
              //}
              
        
              //spliting a string
              String string  = "192.168.1.1-5001";
              String[] parts = string.split("-");
              String part1   = parts[0];
              String part2   = parts[1];
                           
              println(parts[0]);               
                   
      }
        
      
      
        // Our method that quits the thread
        void quit() {
            System.out.println("Quitting."); 
            running = false;  // Setting running to false ends the loop in run()
            // In case the thread is waiting. . .
            interrupt();
        }
}
