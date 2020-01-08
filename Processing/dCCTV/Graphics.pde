class puntero 
{
     int x1,x2,y1,y2;
     int x3,x4,y3,y4;
  
     puntero(){}
     
     // parametros: "a" tiene que ser el doble de "b"
     void encuadre(int x,int y, int a, int b,int tono)
     {
           // esquina izquierda-norte
           x1=x-a;
           y1=y-a;
           x2=x-b;
           y2=y-a;               
           fill(tono);
           line(x1,y1,x2,y2);
           
           x3=x-a;
           y3=y-b;
           x4=x-a;
           y4=y-a;               
           fill(tono);
           line(x3,y3,x4,y4); 
           
           // esquina izquierda-sud
           x1=x-a;
           y1=y+a;
           x2=x-b;
           y2=y+a;               
           fill(tono);
           line(x1,y1,x2,y2);
           
           x3=x-a;
           y3=y+b;
           x4=x-a;
           y4=y+a;               
           fill(tono);
           line(x3,y3,x4,y4);
           
                 
           // esquina derecha-norte
           x1=x+a;
           y1=y-a;
           x2=x+b;
           y2=y-a;               
           fill(tono);
           line(x1,y1,x2,y2);
           
           x3=x+a;
           y3=y-b;
           x4=x+a;
           y4=y-a;               
           fill(tono);
           line(x3,y3,x4,y4);
           
           // esquina derecha-sud
           x1=x+a;
           y1=y+a;
           x2=x+b;
           y2=y+a;               
           fill(tono);
           line(x1,y1,x2,y2);
           
           x3=x+a;
           y3=y+b;
           x4=x+a;
           y4=y+a;               
           fill(tono);
           line(x3,y3,x4,y4);
     }

     
     void subencuadre(int x,int y, int a, int b)
     {
           // esquina izquierda-norte
           x1=x-a;
           y1=y-a;
           x2=x-b;
           y2=y-a;               
           fill(0);
           line(x1,y1,x2,y2);
           
           x3=x-a;
           y3=y-b;
           x4=x-a;
           y4=y-a;               
           fill(0);
           line(x3,y3,x4,y4); 
           
           // esquina izquierda-sud
           x1=x-a;
           y1=y+a;
           x2=x-b;
           y2=y+a;               
           fill(0);
           line(x1,y1,x2,y2);
           
           x3=x-a;
           y3=y+b;
           x4=x-a;
           y4=y+a;               
           fill(0);
           line(x3,y3,x4,y4);
           
                 
           // esquina derecha-norte
           x1=x+a;
           y1=y-a;
           x2=x+b;
           y2=y-a;               
           fill(0);
           line(x1,y1,x2,y2);
           
           x3=x+a;
           y3=y-b;
           x4=x+a;
           y4=y-a;               
           fill(0);
           line(x3,y3,x4,y4);
           
           // esquina derecha-sud
           x1=x+a;
           y1=y+a;
           x2=x+b;
           y2=y+a;               
           fill(0);
           line(x1,y1,x2,y2);
           
           x3=x+a;
           y3=y+b;
           x4=x+a;
           y4=y+a;               
           fill(0);
           line(x3,y3,x4,y4);
     }

}
