import java.awt.image.*; 
import javax.imageio.*;

import java.io.*;
import java.net.*;

import javax.imageio.*;
import java.awt.image.*; 

PImage video,video_2,video_3,video_4,video_5,video_6,video_7,video_8,video_9;
PImage img_basement;


//threads hilo_1;

thread_getImg thread_gImg;

RecvMsgThread  thread_message;

ReceiverThread thread;
ReceiverThread thread_2;
ReceiverThread thread_3;
ReceiverThread thread_4;
ReceiverThread thread_5;
ReceiverThread thread_6;
ReceiverThread thread_7;
ReceiverThread thread_8;
ReceiverThread thread_9;

int port;
int my_height, my_width, origin_x, origin_y;
float x,x1;
float width_box, width_video,scale_width_video,height_box,height_video,scale_height_video;
float scale_camera_9 = 4;


float main_cam = 0;
      
int mousex;
int mousey;
int i =0;

boolean flag_expand = false;



puntero mipuntero    = new puntero();
canvas_lilu micanvas = new canvas_lilu();

commands comLab01 = new commands("9100");
commands comLab02 = new commands("9200");
commands comLab03 = new commands("9300");
commands comLab04 = new commands("9400");
commands comLab05 = new commands("9500");
commands comLab06 = new commands("9600");
commands comLab07 = new commands("9700");
commands comLab08 = new commands("9800");
commands comLab09 = new commands("9900");


Text texto = new Text();

PGraphics tile;

void setup() 
{
      //full HD
      //size(1920,1080,P3D); 
      //frame.setResizable(true); 
     
      fullScreen();
     
     
      frameRate(120);
      
      //hypermedia udp, this is another
      //udp = new UDP(this,6001);
      //udp.log(true);
      //udp.listen(true);
        

     
      texto.textsetup(); 
     
     
      tile = createGraphics(width, height);
     
      video     = createImage(320,240,RGB);
      video_2   = createImage(320,240,RGB);        
      video_3   = createImage(320,240,RGB);
      video_4   = createImage(320,240,RGB);
      video_5   = createImage(320,240,RGB);
      video_6   = createImage(320,240,RGB);
      video_7   = createImage(320,240,RGB);
      video_8   = createImage(320,240,RGB);
      video_9   = createImage(320,240,RGB);
              
            
      //hilo_1 = new threads(0.01,"dibujar");      
      //hilo_1.start();      
        
      //we check if there are images waiting for us 
      //It is better to do this process by a thread than sequentially
      thread_gImg = new thread_getImg(10,"getImg"); 
      thread_gImg.start(); 
        
      //we receive commands, info, etc    
      thread_message = new RecvMsgThread(4001);
      thread_message.start();
      //thread_message.setPriority(10);
                                      
      thread = new ReceiverThread(video.width,video.height,9100);
      thread.start();

      
      thread_2 = new ReceiverThread(video.width,video.height,9200);
      thread_2.start();
      
      thread_3 = new ReceiverThread(video.width,video.height,9300);
      thread_3.start();
      
      thread_4 = new ReceiverThread(video.width,video.height,9400);
      thread_4.start();
      
      thread_5 = new ReceiverThread(video.width,video.height,9500);
      thread_5.start();
      
      thread_6 = new ReceiverThread(video.width,video.height,9600);
      thread_6.start();
      
      thread_7 = new ReceiverThread(video.width,video.height,9700);
      thread_7.start();
      
      thread_8 = new ReceiverThread(video.width,video.height,9800);
      thread_8.start();
      
      thread_9 = new ReceiverThread(video.width,video.height,9900);
      thread_9.start();
      
  
      float scale_factor=1;
      
      my_width  = int(width*scale_factor);
      my_height = int(height*scale_factor);
      
      micanvas.specs(origin_x, origin_y, my_width, my_height, 255);
      micanvas.ini();
      
      x =(my_width/4)*2.8;                                     // left line
      x1 = ((my_width-(my_width/4)*2.8)/2 + (my_width/4)*2.8); //right line

      width_box = x1-x;
      width_video = video.width;
      scale_width_video = width_box/width_video;
      scale_width_video= scale_width_video - .1;
      
      height_box = my_height/4;
      height_video = video.height;
      scale_height_video = height_box/height_video;
      
      //img_basement = loadImage("basement.png");
      
      main_cam = scale_width_video*3.71;
 
}

 void draw() 
 {
       
      //thread hace referencia al lab1
      if(new String(thread.address_server).equals("0.0.0.0") && (comLab01.flag_active_lab == true) || (comLab01.flag_reset_lab == true))
      {
           //9100   
           comLab01.cScann();
           println("Scanning LAB9100");
           comLab01.flag_reset_lab = false;
      }
       println("lAB9100 " +thread.address_server);
      
      
      //thread_2 hace referencia al lab2
      if(new String(thread_2.address_server).equals("0.0.0.0") && (comLab02.flag_active_lab == true) || (comLab02.flag_reset_lab == true))
      {
           //9200   
           comLab02.cScann();
           println("Scanning LAB9200");
           comLab02.flag_reset_lab = false;
      }
       println("LAB9200 " +thread_2.address_server);
       
       
      //thread_3 hace referencia al lab3   
      if(new String(thread_3.address_server).equals("0.0.0.0") && (comLab03.flag_active_lab == true) || (comLab03.flag_reset_lab == true))
      {
           //9300   
           comLab03.cScann();
           println("Scanning LAB9300");
           comLab03.flag_reset_lab = false;
      }
       println("LAB9300 " +thread_3.address_server);
       
       
      //thread_4 hace referencia al lab4
      if(new String(thread_4.address_server).equals("0.0.0.0") && (comLab04.flag_active_lab == true) || (comLab04.flag_reset_lab == true))
      {
           //9400   
           comLab04.cScann();
           println("Scanning LAB9400");
           comLab04.flag_reset_lab = false;
      }
       println("lAB9400 " +thread_4.address_server);
      
      
      //thread_5 hace referencia al lab5
      if(new String(thread_5.address_server).equals("0.0.0.0") && (comLab05.flag_active_lab == true) || (comLab05.flag_reset_lab == true))
      {
           //9500   
           comLab05.cScann();
           println("Scanning LAB9500");
           comLab05.flag_reset_lab = false;
      }
       println("LAB9500 " +thread_5.address_server);
       
       
      //thread_6 hace referencia al lab6   
      if(new String(thread_6.address_server).equals("0.0.0.0") && (comLab06.flag_active_lab == true) || (comLab06.flag_reset_lab == true))
      {
           //9600   
           comLab06.cScann();
           println("Scanning LAB9600");
           comLab06.flag_reset_lab = false;
      }
       println("LAB9600 " +thread_6.address_server);
       
      //thread_5 hace referencia al lab5
      if(new String(thread_7.address_server).equals("0.0.0.0") && (comLab07.flag_active_lab == true) || (comLab07.flag_reset_lab == true))
      {
           //9500   
           comLab07.cScann();
           println("Scanning LAB9700");
           comLab07.flag_reset_lab = false;
      }
       println("LAB9700 " +thread_7.address_server);
       
       
      //thread_8 hace referencia al lab8   
      if(new String(thread_8.address_server).equals("0.0.0.0") && (comLab08.flag_active_lab == true) || (comLab08.flag_reset_lab == true))
      {
           //9800   
           comLab08.cScann();
           println("Scanning LAB9800");
           comLab08.flag_reset_lab = false;
      }
       println("LAB9800 " +thread_8.address_server);
           
      /////////////////////////////////////////////
      
   
      //println("My local IP is "+ LOCAL_IP);
   
      //if there is something available
      //lanchingThreads();
  
      // Draw the image
      background(0);
                
      //where is the mouse  
      fill(200,200,0);    
      textSize(20);
      //text("X["+mouseX+"] Y["+mouseY+"] " + width +" "+ height +" "+ LOCAL_IP , 20, height -20);
      text("X["+mouseX+"] Y["+mouseY+"] " +" "+ LOCAL_IP , 20, height -20);
      
      //display cameras
      micanvas.display();
      
           
      
      //Screen encuadre moving the mouse
      //stroke(250);strokeWeight(3);
      //mipuntero.encuadre(mousex,mousey,20,13,155);
      //strokeWeight(3);
      //stroke(250);
      //mipuntero.subencuadre(mousex,mousey,8,4);
            
}
