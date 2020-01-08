/*Mi propio Thread de ejemplo*/

volatile boolean flag_draw= false;

class threads extends Thread 
{
 
      boolean running;           // esta el thread corriendo?
      float wait;                  // tiempo entre ejecuciones
      String id;                 // Thread nombre
      int count;
      int count_2;
      
      Rectangle rect = new Rectangle( Toolkit.getDefaultToolkit().getScreenSize() );
      //BufferedImage[] image = new BufferedImage[32*3600];
      String path =dataPath("");
      long actual_time =0;    

      long cuenta=0;
      
      boolean flag_on = false;
   
      
      /////////////////////////////////////////////////////////////////////////////////////////

      threads (float w, String s)
      {
            wait = w;
            running = false;
            id = s;
            count=0;
            count_2 = 0;
      }

      /////////////////////////////////////////////////////////////////////////////////////////

      int getCount() 
      {
          return count;
      }

      /////////////////////////////////////////////////////////////////////////////////////////

      void start () 
      {
          // activamos con running, = true
          running = true;
          println("Starting the Thread con ID: "+id+" (se ejecuta cada " + wait + " ms.)"); 
       
          super.start();
      }
      
      /////////////////////////////////////////////////////////////////////////////////////////
     
      void run ()                               // debemos implementar run() que es llamado por start()
      {
          while (running)
          {    
              if((id=="garbageCollector")){garbageCollector();}
              if((id=="video")){video();}
              if((id=="ScreenShot")){ScreenShot();}
              if((id=="saveImage")){saveImage();}
              if((id=="waitt")){waitt();}
                         
              try 
              {
                 sleep((long)(wait));
              } 
              catch (Exception e) {}
 
          }
      
          println("Id: " + id + " --> El thread ha muerto");  // The thread is done when we get to the end of run()
      }
      
      
      
            public synchronized void waitt()
      { 
           try
           {
                  flag_on = true;
           }
           catch(Exception ex){}          
           
      }
      
      
      ////////////////////////////////////////////////////////////////////////////////////////
      
      public synchronized void garbageCollector()
      { 
           try
           {
             // println("Contando: "+count);
              count++;
              if(count==6){count=0;  System.gc(); }
           }
           catch(Exception ex){}          
           
      }
      
      ////////////////////////////////////////////////////////////////////////////////////////
      long video_actual,video_late;
      public synchronized void video()
      { 
           try{
               video_actual = System.currentTimeMillis();
               
               //newImage = video.get();  
               
                      //pushMatrix();
       //   scale(0.3);
       //   translate(10,10);
       //   image(img,0,10); 
       //   // can appears in the frame if you make bigger the screen 
          
       //   scale(6);
       //   translate(150,0);
          
       //   image(video, 300, 0);    
       //popMatrix();
               
               
               
               video_late = System.currentTimeMillis();
               
               //println("video "+(video_late)+"  "+(video_actual));              
           }catch(Exception ex){ println(ex);}          
      }
      
      /////////////////////////////////////////////////////////////////////////////////////////
      long new_time;
      
      int size =100;
      
      BufferedImage[] imageSC = new BufferedImage[size];
      
      PImage[] imageV = new PImage[size];
      long[] timeArray =new long[size];
      
      int cnt_1=0;
      public synchronized void ScreenShot()
      {
          try {
              //println("I am in screen");
              Robot robot = new Robot();
              actual_time = System.currentTimeMillis();
              timeArray[1]=actual_time;
              
              //imageV[1] = video.get();
              //streaming(imageV[1]);
              streaming(screenshot);
              //imageSC[1] = robot.createScreenCapture( rect );
              
               //PImage   imageV[2]= (PImage) imageSC[1].getImage();
              
               //streaming_2(imageSC[1]);
              //BufferedImage img[1] = new Robot().createScreenCapture(rect);
              //ImageIO.write(image[1], "jpg", new File(path+"\\img\\img_"+actual_time+".jpg")); 
              new_time = System.currentTimeMillis();
              println("SC "+ (new_time-actual_time));
              if(cnt_1<size)
              {
                //print(cnt_1);
                cnt_1++;
               }else{cnt_1=0;}
          } 
          catch ( Exception e ) { println(e);}
      }
      
      /////////////////////////////////////////////////////////////////////////////////////////
      
      int cnt_2=0;
      public synchronized void saveImage()
      { 
           try{
           //  String path =dataPath("");
           //ImageIO.write(imageSC[cnt_2], "jpg", new File(path+"\\img\\img_"+timeArray[cnt_2]+".jpg"));
           
           
              if(cnt_2<size)
              {
                cnt_2++;
               }else{cnt_2=0;}
           
           //count_2++;
           }catch(Exception ex){} 
      }
      
      /////////////////////////////////////////////////////////////////////////////////////////

      public synchronized void quit()                         // matamos el thread  //
      {
            println("El thread va a morir..."); 
            running = false;                                  // running lo pasamos a false //
            interrupt();                                      // en el caso que este esperamos interrumpimos //
      }
  
}
