
function myLoopingFcn() 
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
gcf
set(gcf, 'KeyPressFcn', @myKeyPressFcn)
while ~KEY_IS_PRESSED
      drawnow
      %%disp('looping...')
      
      % IMPORTANT : here we have to play with the port!
      % sometimes is occupied by another application
      % so we should try with another one.
      
      mssg = judp('receive',9990,1024,1000);
      char(mssg')           
      
      judp('send',8880,'localhost',int8('Pong!!'));
      
     

      
end
disp('loop ended')

end


function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end