class Text 
{

        PFont font1, font2, font3, font4;
        int black = 0;              
        int white = 255;
        String milis;
      
        void textsetup() 
        {
              font1 = loadFont("arial.vlw");
              font2 = loadFont("Arial-italic.vlw");
              font3 = loadFont("courier.vlw");
              font4 = loadFont("courier-12.vlw");
        }
      
        void statictext() 
        {
          
          
              fill(white);
              //textFont(font1);
          
              //text("by Jose Garcia-Uceda Calvo", width-170, height-30);
              text("Donders Centre for Cognitive Neuroimaging", width-450,height-15);
           
        }
        
        void vartext(String texto, int x, int y) 
        {
              fill(100);
              //textFont(font1);
       
              text(texto, x, y);
              
        }
        
        void vartext(String texto, int x, int y, int tono) 
        {
              fill(tono);
              textFont(font1);
       
              text(texto, x, y);
              
        }
      
        void info_time(String hora, String fecha) 
        {
              fill(white);
              //textFont(font1,14);
              
              text(fecha+" "+hora, width-528, 25);
        }
        
        void info_test() 
        {
            
              fill(white);
              //textFont(font1,14);
              
              milis=str(millis());
              text("Time in ms [ "+milis+" ]", width-(width-10), height-30,8);
               
 
        }
        
}
