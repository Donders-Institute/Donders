import java.util.Date;
import java.sql.Timestamp;

long time;

class timeStamp
{
      timeStamp(){}
      
      float getTime()
      {    
               Date date= new Date();
   
               time = date.getTime();
               println("Time in Milliseconds: " + time);
            
               Timestamp ts = new Timestamp(time);
               println("Current Time Stamp: " + ts);
 
               return time;
      }
}