public void fullScreenFPSCheck()
    {
        //On a resolution of 1920x1080 it finishes 30 screenshots in about 4 seconds
        Rectangle rect = new Rectangle(Toolkit.getDefaultToolkit().getScreenSize());
        int count =1;
        
        
        while(true)
        {
            if(count == 30)
                break;
            try {
                BufferedImage img = new Robot().createScreenCapture(rect);
                ImageIO.write(img, "jpeg", new File(dataPath("")+"\\img\\img_"+frameCount+"_"+time+".jpg"));
                ///new Thread_Alg();
            } catch (Exception e) {
                e.printStackTrace();
            }
            count++;
            println(count);
            
        }
    }

//BufferedImage[] image = new BufferedImage[32*3600];
//public void fullScreenFPSCheck_2()
//{
//    Rectangle rect = new Rectangle( Toolkit.getDefaultToolkit().getScreenSize() );
//    //BufferedImage[] image = new BufferedImage[32*3600];
//    String path =dataPath("");
//    try {
//          Robot robot = new Robot();
//          int count = 1;
//          long beforeTime = System.currentTimeMillis();
          
//          while ( count < 32 ) {
//                image[count] = robot.createScreenCapture( rect );
//                //BufferedImage img = new Robot().createScreenCapture(rect);
//                //ImageIO.write(image, "jpg", new File(path+"\\img\\img_"+frameCount+"_"+time+".jpg"));
              
//              count++;
//          }
//          double time = System.currentTimeMillis() - beforeTime;
//          System.out.println( "Seconds it took for 32 screen captures: " + time / 1000 );
//    } 
//    catch ( Exception e ) { }

//}


//////test for the thread

//Rectangle rect = new Rectangle( Toolkit.getDefaultToolkit().getScreenSize() );
////BufferedImage[] image = new BufferedImage[32*3600];
//String path =dataPath("");
//long actual_time =0;    

//long cuenta=0;
//public void screenShot()
//{
//    try {
//          Robot robot = new Robot();
//          actual_time = System.currentTimeMillis();
          
//          image[1] = robot.createScreenCapture( rect );
//          //BufferedImage img[1] = new Robot().createScreenCapture(rect);
//          //ImageIO.write(image[1], "jpg", new File(path+"\\img\\img_"+actual_time+".jpg")); 
          
//          println(cuenta++);
          
//    } 
//    catch ( Exception e ) { }

//}
