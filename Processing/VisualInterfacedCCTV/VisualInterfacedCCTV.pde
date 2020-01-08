
vinterface v = new vinterface();


void setup()
{
    fullScreen();
    v.img = loadImage("batman.jpg"); 
    v.maskImage = loadImage("batman.jpg");
    v.blur = loadShader("blur.glsl"); 
    
}

void draw()
{
  
    background(0);    
    v.viStart();


}