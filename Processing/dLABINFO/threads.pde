/*Mi propio Thread de ejemplo*/

class threads extends Thread 
{
 
      boolean running;           // esta el thread corriendo?
      float wait;                  // tiempo entre ejecuciones
      String id;                 // Thread nombre
      int count;
      
   
      
      /////////////////////////////////////////////////////////////////////////////////////////

      threads (float w, String s)
      {
            wait = w;
            running = false;
            id = s;
            count=0;            
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
              if((id=="dibujar")){dibujar();}
              if((id=="recibir")){recibir();}
              if((id=="enviar")){enviar();}
              if((id=="abortar")){abortar();}
                         
              try 
              {
                 sleep((long)(wait));
              } 
              catch (Exception e) {}
 
          }
      
          println("Id: " + id + " --> El thread ha muerto");  // The thread is done when we get to the end of run()
      }
      
      ////////////////////////////////////////////////////////////////////////////////////////
      
      public synchronized void dibujar()
      { 
           try
           {
              //println("Contando: "+count);
              count++;
              if(count==160){count=0;}
           }
           catch(Exception ex){}          
      }
      
      ////////////////////////////////////////////////////////////////////////////////////////
      
      public synchronized void recibir()
      { 
           try
           {
              println("Contando: "+count);
              count++;
              if(count==5){count=0;}
           }
           catch(Exception ex){}             
      }
      
      /////////////////////////////////////////////////////////////////////////////////////////
      
      public synchronized void enviar()
      {
           try{}catch(Exception ex){} 
      }
      
      /////////////////////////////////////////////////////////////////////////////////////////
      
      
      public synchronized void abortar()
      { 
           try{}catch(Exception ex){} 
      }
      
      /////////////////////////////////////////////////////////////////////////////////////////

      public synchronized void quit()                         // matamos el thread  //
      {
            println("El thread va a morir..."); 
            running = false;                                  // running lo pasamos a false //
            interrupt();                                      // en el caso que este esperamos interrumpimos //
      }
  
}