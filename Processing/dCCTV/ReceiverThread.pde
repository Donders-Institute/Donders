
class ReceiverThread extends Thread {

          // Port we are receiving.
          //int port = 9700; 
          DatagramSocket ds; 
          // A byte array to read into (max size of 65536, could be smaller)
          byte[] buffer = new byte[65536]; 
          
          byte[] buffer_recv = new byte[65536]; 
          
          //byte[][] video_buffer_1 = new byte[65536][1000]; 
        
        
          boolean running;    // Is the thread running?  Yes or no?
          boolean available;  // Are there new tweets available?
        
          // Start with something 
          PImage img;
          
          int port_;
          
          String  address_server= "0.0.0.0"; 
        
         
          ReceiverThread (int w, int h,int port) {
            img = createImage(w,h,RGB);
            running = false;
            available = true; // We start with "loading . . " being available
        
            try {
              ds = new DatagramSocket(port);
            } catch (SocketException e) {
              e.printStackTrace();
            }
            
            port_=port;
          }
        
          PImage getImage() {
            // We set available equal to false now that we've gotten the data
            available = false;
            return img;
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
              checkForImage();
              // New data is available!
              available = true;
            }
          }
        
          void checkForImage() {
            DatagramPacket p = new DatagramPacket(buffer, buffer.length); 
            try {
              ds.receive(p);
            } 
            catch (IOException e) {
              e.printStackTrace();
            } 
            byte[] data = p.getData();
            
            //myfile.writedata(data);
            
            address_server = p.getAddress().getHostAddress();
        
            //////////////////////////////////////////////////////////////////////////////////////
            ///// checking for messages. We filter between images and messages by using the length
            
            //if(port_== 800){
            
            //    //If there is a message we should decoded to read it
            //    String s = Base64.getEncoder().encodeToString(data);
                   
                      
                     
            //    if(s.length()<200){
            //                    println("Received datagram with " + data.length + " bytes.\n" ); 
            //                    println(s+"\n");
            //                    exit();  
                                 
            //     }
                 
            // }
            /////////////////////////////////////////////////////////////////////////////////////
            //else
            //{
                
                //println("Received datagram with " + data.length + " bytes." );
            
                // Read incoming data into a ByteArrayInputStream
                ByteArrayInputStream bais = new ByteArrayInputStream( data );
            
                // We need to unpack JPG and put it in the PImage img
                img.loadPixels();
                try {
                  // Make a BufferedImage out of the incoming bytes
                  BufferedImage bimg = ImageIO.read(bais);
                  // Put the pixels into the PImage
                  bimg.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
                } 
                catch (Exception e) {
                  e.printStackTrace();
                }
                // Update the PImage pixels
                img.updatePixels();
                
        
                
           //}
           
          }
        
        
          // Our method that quits the thread
          void quit() {
            System.out.println("Quitting."); 
            running = false;  // Setting running to false ends the loop in run()
            // In case the thread is waiting. . .
            interrupt();
          }
}
