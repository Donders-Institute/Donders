import java.io.*;
import java.io.IOException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

String one = "/usr/local/bin";
String two = "bash";
String three = "alias vlc='/Applications/VLC.app/Contents/MacOS/VLC' & vlc";
   
String s = null;


//https://wiki.videolan.org/Documentation:Command_line/#Opening_streams

void setup()
{
  
        try {
            
            // run the Unix "ps -ef" command
            // using the Runtime exec method:
            Process p = Runtime.getRuntime().exec("alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'");
            //asi se ejecuta mucho mejor ya que los espacios en el pwd te matan
            String[] a = new String[] {"/Applications/VLC.app/Contents/MacOS/VLC","/Volumes/LiluPassport/Movies/paycheck.avi", "--fullscreen"};
            //Process p2 = Runtime.getRuntime().exec("/Applications/VLC.app/Contents/MacOS/VLC /Volumes/Lilu Passport/Movies/paycheck.avi --fullscreen");
            Process p2 = Runtime.getRuntime().exec(a);
            
            
            
            
            BufferedReader stdInput = new BufferedReader(new 
                 InputStreamReader(p.getInputStream()));

            BufferedReader stdError = new BufferedReader(new 
                 InputStreamReader(p.getErrorStream()));

            // read the output from the command
            System.out.println("Here is the standard output of the command:\n");
            while ((s = stdInput.readLine()) != null) {
                System.out.println(s);
            }
            
            // read any errors from the attempted command
            System.out.println("Here is the standard error of the command (if any):\n");
            while ((s = stdError.readLine()) != null) {
                System.out.println(s);
            }
            
            //System.exit(0);
        }
        catch (IOException e) {
            System.out.println("exception happened - here's what I know: ");
            e.printStackTrace();
            System.exit(-1);
        }

}

void draw()
{
   
}
