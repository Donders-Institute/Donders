class CameraThread extends Thread {

  boolean running;    // Is the thread running?  Yes or no?
  boolean available;  // Are there new tweets available?
  
  int port_in;
   
  // Start with something 
  PImage img;

  CameraThread(int w, int h,int port) {
    img = createImage(w,h,RGB);
    running = false;
    available = true; // We start with "loading . . " being available

    port_in = port;
    //try {
    //  //ds = new DatagramSocket(port);
    //} catch (SocketException e) {
    //  e.printStackTrace();
    //}
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

    //try {
     
    //} 
    //catch (IOException e) {
    //  e.printStackTrace();
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
