//I am not using anymore this function 
//now is placed at Thread_getImage

void lanchingThreads()
{

      if (thread.available()) 
      { 
        video = thread.getImage();
      }
      
      if (thread_2.available()) 
      { 
        video_2 = thread_2.getImage();
      }
      
      if (thread_3.available()) 
      { 
        video_3 = thread_3.getImage();
      }
      
      if (thread_4.available()) 
      { 
        video_4 = thread_4.getImage();
      }
      
      if (thread_5.available()) 
      { 
        video_5 = thread_5.getImage();
      }
      
      
      if (thread_6.available()) 
      { 
        video_6 = thread_6.getImage();
      }
      
      if (thread_7.available()) 
      { 
        video_7 = thread_7.getImage();
      }
      
      if (thread_8.available()) 
      { 
        video_8 = thread_8.getImage();
      }
      
      if (thread_9.available()) 
      { 
        video_9 = thread_9.getImage();
      }
      
      
      
}
