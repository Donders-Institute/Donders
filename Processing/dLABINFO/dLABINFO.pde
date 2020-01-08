import java.io.*;
import java.net.*;

import javax.imageio.*;
import java.awt.image.*;  

import gohai.glvideo.*;

GLCapture video;

threads hilo_1,hilo_2;

PFont myFont_1, myFont_2,myFont_3,myFont_4,myFont_1_2;
float scale_factor=1, my_width,my_height;

PImage img;

int flag_status   = 1;


int[] visual_status_out = {0,0,0,0};



// threads
udp_Threads hilo_send,hilo_recv;


void setup() 
{
      size(1280, 720, P3D);
      //fullScreen();
    
      
      my_width  = int(width*scale_factor);
      my_height = int(height*scale_factor);
    

      myFont_1 = createFont("Arial", 12);
      myFont_1_2 = createFont("Arial", 50);
      myFont_2 = createFont("ArialMT", 120);
      myFont_3 = createFont("Arial", 100);
      myFont_4 = createFont("ArialMT", 60);
       
       
      img = loadImage("logo.png");

      hilo_1 = new threads(10, "dibujar");
      hilo_1.start();   
      
      
      grafica_ini();
      
      
      //udp ports
      hilo_send = new udp_Threads(1000,"send");
      hilo_send.port = 5001;
      hilo_send.ip = "192.168.1.13";            // ip of the IoT
      hilo_send.start();
    
      hilo_recv = new udp_Threads(50,"recv"); // ip of the IoT
      hilo_recv.port = 4001;
      hilo_recv.ip = "192.168.1.13";
      hilo_recv.start();
      
      
      
      

}

void draw() 
{
      background(0);
      
      //text 05
          rectMode(CORNER);
          fill(148,14,40);
          textFont(myFont_2);
    
             text("21",20,700);
      
      //text month
          rectMode(CORNER);
          fill(148,14,40);
          textFont(myFont_1_2);
    
             text("AUG",150,650);
             
      //text year
          rectMode(CORNER);
          fill(200,200,200);
          textFont(myFont_1_2);
    
             text("2019",150,700);
      
        
      //text MEGLab
          rectMode(CORNER);
          fill(255,255,255);
          textFont(myFont_4);
    
             //text("MEGLab",20,600);
             text("MEGLab",20,590);
             
             
       //text temperature humidity
          rectMode(CORNER);
          fill(255,255,0);
          textFont(myFont_1_2);
    
             //text("MEGLab",20,600);
         
            
            
            
            
            if (hilo_recv.temperature1 != null && !hilo_recv.temperature1.isEmpty())
            {
               text(hilo_recv.temperature1+"C",312,620);  
            }
            text("48%",312,700);   
             

           
             
          strokeWeight(1);stroke(10);fill(10);
           rect(312,560,my_width*0.07,my_height*0.02);
           rect(312,640,my_width*0.07,my_height*0.02);
         noStroke();  
         
                //boxes
          rectMode(CORNER);
          fill(200,200,200);
           textFont(myFont_1);
           text("HUMIDITY",312,652);
           text("TEMPERATURE",312,572);
 
 
                  
      //frame screen
          //strokeWeight(0.6);stroke(250);noFill();
          //rect(10,10,my_width-20,my_height-20,1);
          //noStroke();  
        
      
      //logo  
      //imageMode(CENTER);
      //image(img, 210, 660, 80, 80);
 
     
      
      //headers
      //top 
      strokeWeight(1);stroke(250);fill(250);
       rect(20,35,my_width*0.3,my_height*0.003);
      noStroke();  
     
     
     
     //text-header
          rectMode(CORNER);
          fill(200,200,200);
          textFont(myFont_1);
    
             text("MEG USER",22,55);
     
     
     //before-bottom
      strokeWeight(1);stroke(255);fill(255);
       line(20,60,20+my_width*0.3,60);
      noStroke();  
     
     //bottom
     strokeWeight(1);stroke(250);fill(250);
       rect(20,65,my_width*0.3,my_height*0.003);
      noStroke();  
         
     //box photo
     strokeWeight(1);stroke(255);noFill();
       rect(20,90,my_width*0.3,my_height*0.3);
      noStroke();  
      
     //box project
     strokeWeight(1);stroke(255);noFill();
       rect(20,320,my_width*0.3,my_height*0.05);
      noStroke(); 
      
      
     ////box temperature
     //strokeWeight(1);stroke(255);noFill();
     //  rect(267,600,my_width*0.09,my_height*0.05);
     // noStroke();  
      
   
   
     flag_status = 1;
     visual_status_out = status(flag_status);
   
   
     //box status
     strokeWeight(.5);stroke(150);fill(visual_status_out[0],visual_status_out[1],visual_status_out[2]);
       rect(20,370,my_width*0.3,my_height*0.22);
      noStroke();  
          
     int i=0;
     for(i=0;i<my_width*0.3;i=i+4)
     {
        strokeWeight(1);stroke(0);fill(0);
        line(20+i,370,20+i,370+my_height*0.22);
        //line(20,370+i,20+my_height*0.22,370+i);
        noStroke();
     
     }      
          
          
     for(i=0;i<my_height*0.22;i=i+4)
     {
        strokeWeight(1);stroke(0);fill(0);
        line(20,370+i,20+my_width*0.3,370+i);
        noStroke();
     
     }       
          
          
      
     //text scanning 
     rectMode(CORNER);
     fill(0,0,0);
     textFont(myFont_1_2);
    
     if(visual_status_out[3]==1) {text("SCANNING",72,470);}
     if(visual_status_out[3]==2) {text("FREE",132,470);}
     if(visual_status_out[3]==3) {text("HELIUM",112,470);}
     if(visual_status_out[3]==4) {text("MAINTENANCE",34,470);}
     
     
     //scanning line
     strokeWeight(0.5);stroke(170);fill(170);
      line(20,366+hilo_1.count,20+my_width*0.3,366+hilo_1.count);
      line(20,368+hilo_1.count,20+my_width*0.3,368+hilo_1.count);
     noStroke();  
     
     strokeWeight(1);stroke(150);fill(150);
      line(20,370+hilo_1.count,20+my_width*0.3,370+hilo_1.count);
      line(20,370+hilo_1.count,20+my_width*0.3,370+hilo_1.count);
     noStroke(); 
     

     agenda();
     lab_contact();
     helium_statistics();

     pushMatrix();    
        //translate(850,0);
        translate(780,40);
       // scale(0.8,0.5);
           grafica_on();     
     popMatrix();
     
     
     pushMatrix();    
        //translate(850,0);
        translate(780,180);
       // scale(0.8,0.5);
           grafica_on();     
     popMatrix();
     
     
     pushMatrix();    
        //translate(850,0);
        translate(780,320);
       // scale(0.8,0.5);
           grafica_on();     
     popMatrix();
     
       
}


int[] status(int flag)
{
    int[] visual_status={0,0,0,0};
    
    if(flag == 1){visual_status[0]=200;visual_status[1]=0;visual_status[2]=0;visual_status[3]=1;}
    if(flag == 2){visual_status[0]=10;visual_status[1]=180;visual_status[2]=10;visual_status[3]=2;}
    if(flag == 3){visual_status[0]=200;visual_status[1]=200;visual_status[2]=200;visual_status[3]=3;}
    if(flag == 4){visual_status[0]=0;visual_status[1]=200;visual_status[2]=2000;visual_status[3]=4;}

    return visual_status;
}


void agenda()
{

   pushMatrix(); 
   
    //translate(850,0);
    translate(400,0);
         //headers
      //top 
      strokeWeight(1);stroke(0,200,200);fill(0,200,200);
       rect(20,35,my_width*0.3,my_height*0.003);
      noStroke();  
   
   
     //text-header
     rectMode(CORNER);
       fill(0,200,200);
       textFont(myFont_1);
    
        text("MEG AGENDA",22,55);
     
     
     //before-bottom
      strokeWeight(1);stroke(0,200,200);fill(0,200,200);
       line(20,60,20+my_width*0.3,60);
      noStroke();  
     
     //bottom
     strokeWeight(1);stroke(0,200,200);fill(0,200,200);
       rect(20,65,my_width*0.3,my_height*0.003);
      noStroke();  
         
     //box photo
     //strokeWeight(1);stroke(0,200,200);noFill();
     //  rect(20,90,my_width*0.3,my_height*0.85);
     // noStroke();
     
     

    
     //text("08:00",20,100);
     //strokeWeight(1);stroke(0,200,200);fill(0,200,200);
     //   line(60,102,20+my_width*0.3,102);
     //noStroke();
     
    ///josito
          //text-header
     rectMode(CORNER);
       fill(200,200,200);
       textFont(myFont_1);
     for(int j=0;j<9;j++){
          
          int time= j+9;
          if(time<10)
          {
            text("0"+time+":00",20,110+j*52);
          }
          else
          {
            text(time+":00",20,110+j*52);
          }
          strokeWeight(1);stroke(200,200,200);fill(200,200,200);
          line(60,112+52*j,20+my_width*0.3,112+52*j);
          noStroke();
     
     }
     

   
   popMatrix(); 

}

void emergency()
{




}

void lab_contact()
{
  
     pushMatrix(); 
   
    translate(800,462);
   
         //headers
      //top 
      strokeWeight(1);stroke(200,200,0);fill(200,200,0);
       rect(20,35,my_width*0.35,my_height*0.003);
      noStroke();  
   
   
     //text-header
     rectMode(CORNER);
       fill(200,200,0);
       textFont(myFont_1);
    
        text("LAB INFO",22,55);
     
     
     //before-bottom
      strokeWeight(1);stroke(200,200,0);fill(200,200,0);
       line(20,60,20+my_width*0.35,60);
      noStroke();  
     
     //bottom
     strokeWeight(1);stroke(200,200,0);fill(200,200,0);
       rect(20,65,my_width*0.35,my_height*0.003);
      noStroke();  
 
    popMatrix();       
         
     ////box photo
     strokeWeight(1);stroke(200,200,0);noFill();
       rect(425,543,my_width*0.659,my_height*0.22);
      noStroke();

  
  


}


void helium_statistics()
{
  
  int[] rgb={255,165,0};

     pushMatrix(); 
   
    translate(800,0);
   
         //headers
      //top 
      strokeWeight(1);stroke(rgb[0],rgb[1],rgb[2]);fill(rgb[0],rgb[1],rgb[2]);
       rect(20,35,my_width*0.35,my_height*0.003);
      noStroke();  
   
   
     //text-header
     rectMode(CORNER);
       fill(rgb[0],rgb[1],rgb[2]);
       textFont(myFont_1);
    
        text("HELIUM HISTORICAL DAYLY-DATA",22,55);
     
     
     //before-bottom
      strokeWeight(1);stroke(rgb[0],rgb[1],rgb[2]);fill(rgb[0],rgb[1],rgb[2]);
       line(20,60,20+my_width*0.35,60);
      noStroke();  
     
     //bottom
     strokeWeight(1);stroke(rgb[0],rgb[1],rgb[2]);fill(rgb[0],rgb[1],rgb[2]);
       rect(20,65,my_width*0.35,my_height*0.003);
      noStroke();  
         
     ////box photo
     //strokeWeight(1);stroke(200,200,0);noFill();
     //  rect(20,90,my_width*0.418,my_height*0.14);
     // noStroke();

   popMatrix(); 


}



void main_structure_move(int i)
{
        //width and height, dimension of the structure
        float d = my_width;
        float c = my_height;
        float b = d/3;
        float a = d-b;
       
        float moriginx=1,moriginy=1;
        float offsetx =0.5;
         
        //coordenates of the structure
        
        //left rectangle
        strokeWeight(1.5);stroke(150);noFill();
          rect(moriginx,moriginy,a,c,1);
          line(moriginx,moriginy,a,moriginy);
        noStroke();   
        
        //right rectangle
        strokeWeight(1.5);stroke(150);noFill();
          rect(moriginx+a+10,moriginy,b-offsetx*2,c,1);
          //line(moriginx+a+10,moriginy+i,moriginx+a+b,moriginy+i);
        noStroke();         
}