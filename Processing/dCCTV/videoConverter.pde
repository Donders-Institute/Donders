void convertImg_to_vid()
{
    Process chperm;
    try {
        chperm=Runtime.getRuntime().exec("su");
          DataOutputStream os = 
              new DataOutputStream(chperm.getOutputStream());


              //the point is to add in a folfer all the images with numbers since 1 to x for example.    
              os.writeBytes("ffmpeg -f image2 -i img%d.jpg /tmp/a.mpg\n");
              os.flush();

              chperm.waitFor();

    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    } catch (InterruptedException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}
