/*This thread depends from ReceiverThread which get images from the ports 9X00*/

class thread_getImg extends Thread 
{
 
      boolean running;           
      float wait;                
      String id;                 
      int count;
      long cnt;
      String filename;
      
   
      /////////////////////////////////////////////////////////////////////////////////////////

      thread_getImg(float w, String s)
      {
            wait = w;
            running = false;
            id = s;
            count=0;
            cnt =0;
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
              if((id=="getImg")){getImg();}                        
              try 
              {
                 sleep((long)(wait));
              } 
              catch (Exception e) {}
 
          }
      
          println("Id: " + id + " --> El thread ha muerto");  // The thread is done when we get to the end of run()
      }
      

      ////////////////////////////////////////////////////////////////////////////////////////
      public synchronized void getImg()
      {
           try 
           {
                      
                    if (thread.available()) 
                    { 
                      video = thread.getImage();
                      
                      //cnt = cnt +1;
                      //filename = "\\img\\9100\\subjectX\\"+cnt+".jpg" ;
                      //video.save(filename);
                    }
                    
                    if (thread_2.available()) 
                    { 
                      
                      video_2 = thread_2.getImage(); 
                      //filename = "\\img\\9200\\subjectX\\"+cnt+".jpg" ;
                      //video_2.save(filename);

                    }
                    
                    if (thread_3.available()) 
                    { 
                      video_3 = thread_3.getImage();
                    }
                    
                    if (thread_4.available()) 
                    { 
                      video_4 = thread_4.getImage();
                    }
                    
                    if (thread_5.available()) 
                    { 
                      video_5 = thread_5.getImage();
                    }
                    
                    
                    if (thread_6.available()) 
                    { 
                      video_6 = thread_6.getImage();
                    }
                    
                    if (thread_7.available()) 
                    { 
                      video_7 = thread_7.getImage();
                    }
                    
                    if (thread_8.available()) 
                    { 
                      video_8 = thread_8.getImage();
                    }
                    
                    if (thread_9.available()) 
                    { 
                      video_9 = thread_9.getImage();
                    }
                 
           } 
           catch (Exception e) {}
      }      
      
      /////////////////////////////////////////////////////////////////////////////////////////

      public synchronized void saveImg(PImage img)                       
      {

      }
  

      /////////////////////////////////////////////////////////////////////////////////////////

      public synchronized void quit()                         // matamos el thread  //
      {
            println("El thread va a morir..."); 
            running = false;                                  // running lo pasamos a false //
            interrupt();                                      // en el caso que este esperamos interrumpimos //
      }
  
}
