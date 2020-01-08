class canvas_lilu 
{ 
     float a,b,c,d,e,f,g,h,i,j,k,l;
     float mwidth,mheight,moriginx,moriginy;
     
     int   mbackground = 255;
     
     int   offsetx = 10;
     int   offsety = 10;
     
     float x1,x2,x3,x4,x5,x6,x7,x8,x9,x10;
     float x11,x22,x33,x44,x55,x66,x77,x88,x99;
     
     float y1,y2,y3,y4,y5,y6,y7,y8,y9,y10;
     float y11,y22,y33,y44,y55,y66,y77,y88,y99;
     
     PImage img,img2,img3,img4,img5;
     
     int varTint_x =155, varTint_y = 155;
     
     String textLab= "";
     
     canvas_lilu()
     {

     }
     void ini()
     {
        img  = loadImage("pause-w.png");
        img2 = loadImage("stop-w.png");
        img3 = loadImage("play-w.png");
        img4 = loadImage("rec-w.png");
        img5 = loadImage("vbuttons-white.png");
     }
     
     void buttons()
     {
          pushMatrix();
              translate(width/2,height/2);
              scale(0.3);
              tint(255, 100);
              image(img, 50, 0);
              image(img2, 250, 0);
              image(img3, 450, 0);
              image(img4, 650, -2);
          popMatrix();   
     }
     
     void specs(int coriginx, int coriginy,int cwidth, int cheight, int cbackground)
     {
        //mwidth   = cwidth-offsetx*2;
        //mheight  = cheight-offsety*2;
        
        mwidth   = cwidth-offsetx*2;
        mheight  = cheight-offsety*2;
        
        moriginx = coriginx;
        moriginy = coriginy;
        mbackground = cbackground;
     }
     
     
     void main_structure()
     {
        //width and height, dimension of the structure
        d = mwidth;
        c = mheight;
        b = d/3;
        a = d-b;
        
        //coordenates of the structure
        
        //left top line
        strokeWeight(1.5);stroke(150);noFill();
          //rect(moriginx,moriginy,a,c,1);
          line(moriginx,moriginy,a,moriginy);
        noStroke();   
        
        //right top line
        strokeWeight(1.5);stroke(150);noFill();
          //rect(moriginx+a+10,moriginy,b-offsetx*2,c,1);
          line(moriginx+a+a/160,moriginy,moriginx+a+b,moriginy);
        noStroke();  
        

        //right line substructure
        strokeWeight(1.5);stroke(150);noFill();       
          rect(moriginx+a+a/160+a/160,moriginy+a/160,((moriginx+a+b)-(moriginx+a+a/160))-2*(a/160), mheight-2*moriginy);
        noStroke();  
        
        println("ancho linea "+(((moriginx+a+b)-(moriginx+a+a/160))-2*(a/160)));
        
        
        float inicio_linea=0;
        
        float ancho_linea = (((moriginx+a+b)-(moriginx+a+a/160))-2*(a/160));
              
        float side = ancho_linea/2 -  video.width*scale_width_video;
        
        float origin_foto = inicio_linea + side;
        
        float origin_foto_2 = inicio_linea+ancho_linea/2 + side;
                
                
        //right top line
        strokeWeight(1.5);stroke(150);noFill();
          line((moriginx+a+a/160)+b/2,moriginy+a/160,(moriginx+a+a/160)+b/2,mheight-2*moriginy);
        noStroke();         
                
                        
        //camera 1
        pushMatrix();
           translate(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160);
           scale(scale_width_video);//,scale_height_video);
           image(video,0,0);               
        popMatrix();
        
        strokeWeight(1.5);stroke(150);
        noFill();
        //rect(x+40,0+40,video.width-50,video.height-50,1);
          rect(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
        noStroke();
        
        
        println("ancho foto "+video.width*scale_width_video);
        
      
        fill(200);strokeWeight(1);
        textSize(20*scale_width_video);
        text("B-LAB01", moriginx+a+a/160+a/160+a/160+3*a/160+10, moriginy+a/160+a/160+video.height*scale_width_video-10);
        
       
        //camera 2
        pushMatrix();
         float ancho_video = video.height*scale_width_video;
         translate(ancho_video+moriginx+a+a/160+a/160+a/160+11*a/160 +3*a/160,moriginy+a/160+a/160);
           scale(scale_width_video);//,scale_height_video);
           image(video_2,0,0);
        popMatrix();
        
        
        strokeWeight(1.5);stroke(150);
        noFill();
        //rect(x+40,0+40,video.width-50,video.height-50,1);
        rect(ancho_video+ 11*a/160+moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
        noStroke();
        
        fill(200);strokeWeight(1);
        textSize(20*scale_width_video);
        text("B-LAB02", ancho_video+ 11*a/160+moriginx+a+a/160+a/160+a/160+3*a/160+10,moriginy+a/160+a/160+video.height*scale_width_video-10);
      
       

       
       
       
        //left line substructure
        
        
     }
     
     void main_structure_move(int i)
     {
        //width and height, dimension of the structure
        d = mwidth;
        c = mheight;
        b = d/3;
        a = d-b;
       
        
        //coordenates of the structure
        
        //left rectangle
        strokeWeight(1.5);stroke(150);noFill();
          //rect(moriginx,moriginy,a,c,1);
          line(moriginx,moriginy,a,moriginy);
        noStroke();   
        
        //right rectangle
        strokeWeight(1.5);stroke(150);noFill();
          //rect(moriginx+a+10,moriginy,b-offsetx*2,c,1);
          line(moriginx+a+10,moriginy+i,moriginx+a+b,moriginy+i);
        noStroke();         
     }
     
     
     
     
     void sub_structure_1()
     {
        d = mwidth;
        c = mheight;
        b = d/3;
        a = d-b;  
     }
     
     
     
     void coordinates_canvas()
     {
        //mwidth,mheight,moriginx,moriginy;
       
        d = mwidth;
        c = mheight;
        b = d/3;
        a = d-b;
         
        x1 = moriginx; 
        x2=x1+a; x4=x2; x6=x2; x8=x2; 
        x3 = x2 + b/2; x5 =x3; x7=x3; x9=x3;
        
        
        y1 = moriginy;
        y2=y1; y3=y1;
        y4=y1+mheight/4;
        y5=y4;
        y6=y1+2*(mheight/4);
        y7=y6;
        y8=y1+3*(mheight/4);
        y9=y8;  
            
     }
         
     float center_h(float x, float w,float w_i)
     {
          float ls = (w-w_i)/2; //left side
          //float rs = ls;        //right side
          
          float c_x= x+ ls;
          
          return c_x;
     }
     
     float center_v(float y,float h, float h_i)
     {
          float ts = (h-h_i)/2;   //top side
          //float bs = ts;        //bottom side
          
          float c_y= y+ ts;
          
          return c_y;
     }
     
     void io_mouse()
     {
     
          if ((mouseX> x2) && (mouseY>y2) && (mouseX<x3) && (mouseY<y4))
          {
              if(flag_expand == false)
              {
                  video_9 = video;
                  textLab= "B-LAB01";
                  //thread_message.address_server;
                  //send_commands("start", thread_message.address_server, 5001);    
                  
                  comLab01.flag_reset_lab = true;
              }
          }
          
          if ((mouseX> x3) && (mouseY>y2) && (mouseY<y4))
          {
              if(flag_expand == false)
              {
                  video_9 = video_2;
                  textLab= "B-LAB02";
                  //send_commands("pause", thread_message.address_server, 5001); 
                  comLab02.flag_reset_lab = true;
              }
          }
          
          if ((mouseX> x2) && (mouseY>y4) && (mouseX<x3) && (mouseY<y6))
          {
              if(flag_expand == false)
              {
                  video_9 = video_3;
                  textLab= "B-LAB03";
                  comLab03.flag_reset_lab = true;
              }
          }
          
          if ((mouseX> x3) && (mouseY>y4) && (mouseY<y6))
          {
              if(flag_expand == false)
              {
                  video_9 = video_4;
                  textLab= "B-LAB04";
                  comLab04.flag_reset_lab = true;
              }
          }
          
          
          if ((mouseX> x2) && (mouseY>y6) && (mouseX<x3) && (mouseY<y8))
          {
              if(flag_expand == false)
              {
                  video_9 = video_5;
                  textLab= "B-LAB05";
                  comLab05.flag_reset_lab = true;
              }
          }
          
          if ((mouseX> x3) && (mouseY>y6) && (mouseY<y8))
          {
              if(flag_expand == false)
              {
                  video_9 = video_6;
                  textLab= "B-LAB06";
                  comLab06.flag_reset_lab = true;
              }
          }
          
          
          if ((mouseX> x2) && (mouseY>y8) && (mouseX<x3))
          {
              if(flag_expand == false)
              {
                  video_9 = video_7;
                  textLab= "B-LAB07";
                  comLab07.flag_reset_lab = true;
              }
          }
          
          if ((mouseX> x3) && (mouseY>y8) )
          {
              if(flag_expand == false)
              {
                  video_9 = video_8;
                  textLab= "B-LAB08";
                  comLab08.flag_reset_lab = true;
              }
          }
          
     
     }
             
     void display()
     {
       
        coordinates_canvas();
       
        float cam_y = center_v(y2,mheight/4, video_3.height*scale_width_video);
        float cam_x = center_h(x2, b/2,video_3.width*scale_width_video);
        
        //camera 1
        pushMatrix();
           translate(cam_x,cam_y);  
           scale(scale_width_video);//,scale_height_video);
           //imageMode(CORNER);
           image(video,0,0);               
        popMatrix();
        
        strokeWeight(1.5);stroke(150);
        noFill();
        ////rect(x+40,0+40,video.width-50,video.height-50,1);
        //  rect(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
        rect(cam_x,cam_y,video_3.width*scale_width_video,video_3.height*scale_width_video,1);
        noStroke();
     
        fill(200);strokeWeight(1);
        textSize(20*scale_width_video);
        text("B-LAB01", cam_x+10, cam_y+video.height*scale_width_video-10);
      
        stroke(200);strokeWeight(3);
        mipuntero.subencuadre(int(cam_x+video.width*scale_width_video-20),int(cam_y+video.height*scale_width_video-20),8,4); 
     
     
        //--------------------------------------------------------------------------------------------------------------------------//

        cam_x = center_h(x3, b/2,video_2.width*scale_width_video);
        cam_y = center_v(y3,mheight/4, video_2.height*scale_width_video);

        //camera 2
        pushMatrix();
           translate(cam_x,cam_y);  
           scale(scale_width_video);//,scale_height_video);
           //imageMode(CORNER);
           image(video_2,0,0);               
        popMatrix();
        
        strokeWeight(1.5);stroke(150);
        noFill();
        ////rect(x+40,0+40,video.width-50,video.height-50,1);
        //  rect(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
        rect(cam_x,cam_y,video_2.width*scale_width_video,video_2.height*scale_width_video,1);
        noStroke();
     
         fill(200);strokeWeight(1);
        textSize(20*scale_width_video);
        text("B-LAB02", cam_x+10, cam_y+video_2.height*scale_width_video-10);
        
        stroke(200);strokeWeight(3);
        mipuntero.subencuadre(int(cam_x+video_2.width*scale_width_video-20),int(cam_y+video_2.height*scale_width_video-20),8,4);
        
       
       //--------------------------------------------------------------------------------------------------------------------------//
       
       
        cam_x = center_h(x4, b/2,video_3.width*scale_width_video);
        cam_y = center_v(y4,mheight/4, video_3.height*scale_width_video);
       
        //camera 3
        pushMatrix();
           translate(cam_x,cam_y);  
           scale(scale_width_video);//,scale_height_video);
           //imageMode(CORNER);
           image(video_3,0,0);               
        popMatrix();
        
        strokeWeight(1.5);stroke(150);
        noFill();
        ////rect(x+40,0+40,video.width-50,video.height-50,1);
        //  rect(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
        rect(cam_x,cam_y,video_3.width*scale_width_video,video_3.height*scale_width_video,1);
        noStroke();
     
        fill(200);strokeWeight(1);
        textSize(20*scale_width_video);
        text("B-LAB03", cam_x+10, cam_y+video_3.height*scale_width_video-10);

        stroke(200);strokeWeight(3);
        mipuntero.subencuadre(int(cam_x+video_3.width*scale_width_video-20),int(cam_y+video_3.height*scale_width_video-20),8,4);

        
        //--------------------------------------------------------------------------------------------------------------------------//


        cam_x = center_h(x5, b/2,video_4.width*scale_width_video);
        cam_y = center_v(y5,mheight/4, video_4.height*scale_width_video);

        //camera 4
        pushMatrix();
           translate(cam_x,cam_y);  
           scale(scale_width_video);//,scale_height_video);
           //imageMode(CORNER);
           image(video_4,0,0);               
        popMatrix();
        
        strokeWeight(1.5);stroke(150);
        noFill();
        ////rect(x+40,0+40,video.width-50,video.height-50,1);
        //  rect(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
        rect(cam_x,cam_y,video_4.width*scale_width_video,video_4.height*scale_width_video,1);
        noStroke();
     
        fill(200);strokeWeight(1);
        textSize(20*scale_width_video);
        text("B-LAB04", cam_x+10, cam_y+video_4.height*scale_width_video-10);     

        stroke(200);strokeWeight(3);
        mipuntero.subencuadre(int(cam_x+video_4.width*scale_width_video-20),int(cam_y+video_4.height*scale_width_video-20),8,4);

        //--------------------------------------------------------------------------------------------------------------------------//


        cam_x = center_h(x6, b/2,video_5.width*scale_width_video);
        cam_y = center_v(y6,mheight/4, video_5.height*scale_width_video);

        //camera 5
        pushMatrix();
           translate(cam_x,cam_y);  
           scale(scale_width_video);//,scale_height_video);
           //imageMode(CORNER);
           image(video_5,0,0);               
        popMatrix();
        
        strokeWeight(1.5);stroke(150);
        noFill();
        ////rect(x+40,0+40,video.width-50,video.height-50,1);
        //  rect(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
        rect(cam_x,cam_y,video_5.width*scale_width_video,video_5.height*scale_width_video,1);
        noStroke();
     
        fill(200);strokeWeight(1);
        textSize(20*scale_width_video);
        text("B-LAB05", cam_x+10, cam_y+video_5.height*scale_width_video-10);     
     
        stroke(200);strokeWeight(3);
        mipuntero.subencuadre(int(cam_x+video_5.width*scale_width_video-20),int(cam_y+video_5.height*scale_width_video-20),8,4);
        

        //--------------------------------------------------------------------------------------------------------------------------//
        
        
        cam_x = center_h(x7, b/2,video_6.width*scale_width_video);
        cam_y = center_v(y7,mheight/4, video_6.height*scale_width_video);

        //camera 6
        pushMatrix();
           translate(cam_x,cam_y);  
           scale(scale_width_video);//,scale_height_video);
           //imageMode(CORNER);
           image(video_6,0,0);               
        popMatrix();
        
        strokeWeight(1.5);stroke(150);
        noFill();
        ////rect(x+40,0+40,video.width-50,video.height-50,1);
        //  rect(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
        rect(cam_x,cam_y,video_6.width*scale_width_video,video_6.height*scale_width_video,1);
        noStroke();
     
        
        fill(200);strokeWeight(1);
        textSize(20*scale_width_video);
        text("B-LAB06", cam_x+10, cam_y+video_6.height*scale_width_video-10);        
        
        stroke(200);strokeWeight(3);
        mipuntero.subencuadre(int(cam_x+video_6.width*scale_width_video-20),int(cam_y+video_6.height*scale_width_video-20),8,4);
        

        //--------------------------------------------------------------------------------------------------------------------------//
    

        cam_x = center_h(x8, b/2,video_7.width*scale_width_video);
        cam_y = center_v(y8,mheight/4, video_7.height*scale_width_video);

        //camera  7
        pushMatrix();
           translate(cam_x,cam_y);  
           scale(scale_width_video);//,scale_height_video);
           //imageMode(CORNER);
           image(video_7,0,0);               
        popMatrix();
        
        strokeWeight(1.5);stroke(150);
        noFill();
        ////rect(x+40,0+40,video.width-50,video.height-50,1);
        //  rect(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
        rect(cam_x,cam_y,video_7.width*scale_width_video,video_7.height*scale_width_video,1);
        noStroke();
     
        fill(200);strokeWeight(1);
        textSize(20*scale_width_video);
        text("B-LAB07", cam_x+10, cam_y+video_7.height*scale_width_video-10);
     
        stroke(200);strokeWeight(3);
        mipuntero.subencuadre(int(cam_x+video_7.width*scale_width_video-20),int(cam_y+video_7.height*scale_width_video-20),8,4);
     
  
        //--------------------------------------------------------------------------------------------------------------------------//
   
        
        cam_x = center_h(x9, b/2,video_8.width*scale_width_video);
        cam_y = center_v(y9,mheight/4, video_8.height*scale_width_video);

        //camera 8
        pushMatrix();
           translate(cam_x,cam_y);  
           scale(scale_width_video);//,scale_height_video);
           //imageMode(CORNER);
           image(video_8,0,0);               
        popMatrix();
        
        strokeWeight(1.5);stroke(150);
        noFill();
        ////rect(x+40,0+40,video.width-50,video.height-50,1);
        //  rect(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
        rect(cam_x,cam_y,video_8.width*scale_width_video,video_8.height*scale_width_video,1);
        noStroke();
     
        fill(200);strokeWeight(1);
        textSize(20*scale_width_video);
        text("B-LAB08", cam_x+10, cam_y+video_8.height*scale_width_video-10);
              
        stroke(200);strokeWeight(3);
        mipuntero.subencuadre(int(cam_x+video_8.width*scale_width_video-20),int(cam_y+video_8.height*scale_width_video-20),8,4);
      
              

        //--------------------------------------------------------------------------------------------------------------------------//

        
        cam_x = center_h(x11, a,video_9.width*main_cam);
        cam_y = center_v(y11,mheight, video_9.height*main_cam);
        //camera 9
        pushMatrix();
           translate(cam_x,cam_y);  
           scale(main_cam);//,scale_height_video);
           //imageMode(CORNER);
           image(video_9,0,0);  
        popMatrix();
        
        strokeWeight(1.5);stroke(150);
        noFill();
        ////rect(x+40,0+40,video.width-50,video.height-50,1);
        //  rect(moriginx+a+a/160+a/160+a/160+3*a/160,moriginy+a/160+a/160,video.width*scale_width_video,video.height*scale_width_video,1);
          rect(cam_x,cam_y,video_9.width*main_cam,video_9.height*main_cam,1);
        noStroke();
        
        //lines at the main cam
        strokeWeight(.6);stroke(150);
        noFill();    
            //vertical lines 
            line(cam_x+video_9.width*main_cam/3  ,    cam_y,cam_x+video_9.width*main_cam/3,   cam_y+video_9.height*main_cam);
            line(cam_x+2*(video_9.width*main_cam/3)  ,    cam_y,   cam_x+2*(video_9.width*main_cam/3),   cam_y+video_9.height*main_cam);
          
            //horizontal lines 
            line(cam_x ,    cam_y+1*(video_9.height*main_cam/3), cam_x+video_9.width*main_cam,   cam_y+1*(video_9.height*main_cam/3));
            line(cam_x ,    cam_y+2*(video_9.height*main_cam/3), cam_x+video_9.width*main_cam,   cam_y+2*(video_9.height*main_cam/3));      
        noStroke();
        
        //Lab number at bottom-left main cam 
        fill(200);strokeWeight(1);
        textSize(10*main_cam);
        text(textLab, cam_x+video_9.width*0.01, cam_y+video_9.height*main_cam*(1-0.01));
         
         
         
        //buttons
        pushMatrix(); 
          translate(cam_x+video_9.width*main_cam*0.41, cam_y+video_9.height*main_cam*(1-0.0564));  
          scale(0.07*main_cam);
          //tint(155, 155);
          if( (mouseX>cam_x+video_9.width*main_cam*0.41)  && (mouseX<cam_x+video_9.width*main_cam*0.61) && (mouseY>cam_y+video_9.height*main_cam*(1-0.0564) )&&( mouseY<cam_y+video_9.height*main_cam*(1-0.01)))
          {
              varTint_x =255; varTint_y=255;
              tint(varTint_x, varTint_y);
          } else{tint(0, 0);}
                image(img5, 0, 0); 
                //image(img3, 50, 10);
                //image(img,  250, -10);
                //image(img2, 450,-10);
                //image(img4, 650, -10-2);
          noTint();
        popMatrix(); 
         
         
        //date and time
        pushMatrix();
          fill(50,50,0);   
          textSize(7*main_cam);
            fill(0,0,0,80); 
             rect(cam_x+video_9.width*main_cam*0.74, cam_y+video_9.height*main_cam*0.020,+video_9.width*main_cam*0.245,video_9.height*main_cam*0.041);
            fill(250,250,0);
             text(time()+" "+date(), cam_x+video_9.width*main_cam*0.74, cam_y+video_9.height*main_cam*0.0515); //0.05 es como si le sumaramos cam_y + 20 pixels. Es perfectamente proporcional
            //text("Donders Centre for Cognitive Neuroimaging", width-450,height-15);
          noFill();
        popMatrix(); 
         
         
        //stroke(200);strokeWeight(3);
        //mipuntero.subencuadre(int(cam_x+video_9.width*main_cam-20),int(cam_y+video_9.height*main_cam-20),8,4);
        
        stroke(250);strokeWeight(3);
        mipuntero.encuadre(int(cam_x+video_2.width*main_cam-9*main_cam),int(cam_y+video.height*main_cam-9*main_cam),int(5*main_cam),int(3.25*main_cam),155);


        

     }
     
}
