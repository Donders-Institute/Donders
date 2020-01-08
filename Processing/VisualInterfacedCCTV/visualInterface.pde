class vinterface
{  
    PImage img,img_main,img_1,img_2,img_3,img_4;
    PImage maskImage;
    
    PShader blur;
    

 
    float x_0_e, y_0_e, x_0_i=60,y_0_i=60;
    float width_pic=320, height_pic=240;
    
    float wt,ht,ww,scalex,scaley;
    
    vinterface()
    {         
              scalex = 400;
              scaley = 300;
              
              ww =(width_pic/4)*scalex*0.01;
              ht=height_pic*scalex*0.01;
              wt=width_pic*scalex*0.01;
              
              
              
              
              img_1 = createImage(320, 240, ARGB);
              for(int i = 0; i < img_1.pixels.length; i++) 
              {
                float a = map(i, 0, img_1.pixels.length, 255, 0);
                img_1.pixels[i] = color(0, 153, 204, a); 
              }
              img_1.filter(BLUR,10);
              
    }
    
    void viStart()
    {
              stroke(255);noFill();
              
              pushMatrix();
                rectMode(CORNER);
                translate(x_0_i, y_0_i); 
                scale((width_pic/400)*scalex*0.0125);   
                image(img, 0, 0);
              popMatrix();
             
              //racbox 2   
              pushMatrix();
                rectMode(CORNER);
                translate(x_0_i+wt+ww, y_0_i); 
                scale((width_pic/400)*scalex*0.00313);
                 //tint(0, 153, 204,100);
                image(img, 0, 0);
                image(img_1, 0, 0);
                     
                //img.mask(maskImage);
               
                //img.filter(BLUR, 6); 
                //filter(BLUR,10);
                
              popMatrix();
              
                           
              // //racbox 4   
              pushMatrix();
                rectMode(CORNER);
                translate(x_0_i+wt+ww, y_0_i+ht/4); 
                scale((width_pic/400)*scalex*0.00313);
                image(img, 0, 0);
              popMatrix();
              
              ////racbox 6   
              pushMatrix();
                rectMode(CORNER);
                translate(x_0_i+wt+ww, y_0_i+(ht/4)*2); 
                scale((width_pic/400)*scalex*0.00313);
                image(img, 0, 0);
              popMatrix();
              
               //racbox 8   
              pushMatrix();
                rectMode(CORNER);
                translate(x_0_i+wt+ww, y_0_i+(ht/4)*3); 
                scale((width_pic/400)*scalex*0.00313);
                image(img, 0, 0);
              popMatrix();
              
              //racbox 1
              pushMatrix();
                rectMode(CORNER);
                translate(x_0_i+wt, y_0_i); 
                scale((width_pic/400)*scalex*0.00313);
                image(img, 0, 0);
              popMatrix();
              
              //racbox 3
              pushMatrix();
                rectMode(CORNER);
                translate(x_0_i+wt, y_0_i+ht/4); 
                scale((width_pic/400)*scalex*0.00313);
                image(img, 0, 0);
              popMatrix();
              
              //racbox 5
              pushMatrix();
                rectMode(CORNER);
                translate(x_0_i+wt, y_0_i+(ht/4)*2); 
                scale((width_pic/400)*scalex*0.00313);
                image(img, 0, 0);
              popMatrix();
              
              //racbox 7
              pushMatrix();
                rectMode(CORNER);
                translate(x_0_i+wt, y_0_i+(ht/4)*3); 
                scale((width_pic/400)*scalex*0.00313);
                image(img, 0, 0);
              popMatrix();
             
              //main box
              rect(x_0_i, y_0_i, wt, ht);
          
              //racbox 1
              rect(x_0_i+wt, y_0_i, (width_pic/4)*scalex*0.01, (height_pic/4)*scalex*0.01);
              rect(x_0_i+wt, y_0_i+ht/4, (width_pic/4)*scalex*0.01, (height_pic/4)*scalex*0.01);
              rect(x_0_i+wt, y_0_i+(ht/4)*2, (width_pic/4)*scalex*0.01, (height_pic/4)*scalex*0.01);
              rect(x_0_i+wt, y_0_i+(ht/4)*3, (width_pic/4)*scalex*0.01, (height_pic/4)*scalex*0.01);
              
              //racbox 2
              //float ww =(width_pic/4)*scalex*0.01;
              rect(x_0_i+wt+ww, y_0_i, ww, (height_pic/4)*scalex*0.01);
              rect(x_0_i+wt+ww, y_0_i+ht/4, (width_pic/4)*scalex*0.01, (height_pic/4)*scalex*0.01);
              rect(x_0_i+wt+ww, y_0_i+(ht/4)*2, (width_pic/4)*scalex*0.01, (height_pic/4)*scalex*0.01);
              rect(x_0_i+wt+ww, y_0_i+(ht/4)*3, (width_pic/4)*scalex*0.01, (height_pic/4)*scalex*0.01);             
                      
    }

}