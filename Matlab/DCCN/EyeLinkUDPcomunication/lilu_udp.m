% Template to be controlled from outside of Matlab
% This Recipie has been coocked by Jose Garcia-Uceda Calvo

clear; close all;

o=1; t= 0; arr(1,1)=1;

mssg='#none#';
status = '@#Iniciated#@'; 

figure(1)
cnt = 1;
while (o == 1) && strcmp(status,'@#Iniciated#@')

  % receiving  
  try  
      
      % here we have to play with the port!
      % sometimes is occupied by another application
      % so we should try with another one.
      mssg = judp('receive',8886,1024,1000);
  catch
      
  end
 
  %C = textscan(char(mssg'),'%f %f %f %f','Delimiter',',');
  C = textscan(char(mssg'),'%s','Delimiter','');
  
  
      
  %Q=C{1}; % esto es un tip cell
  B=num2str(cell2mat(C{1}))
  
  A = strsplit(B,',');
  roll   = str2num(A{3}); % 
  yaw    = str2num(A{2}); % no con la cabeza
  pitch  = str2num(A{1}); % si con la cabeza
  
  if cnt == 1      
      yawlim   = yaw;     
      pitchlim = pitch;      
      rolllim  = roll;
  end
  
  
  
  
  
  subplot(1,3,1);title('Yaw drift');
  plot(yaw,0,'ko','MarkerFaceColor','r','MarkerSize',3);
  xlabel('angle deviation deg');xlim([(yawlim-6) (yawlim+6)]); nicegraph;
  axis normal;hold on;
  
  subplot(1,3,2);title('Roll drift');
  plot(roll,0,'ko','MarkerFaceColor','r','MarkerSize',3);
  xlabel('angle deviation deg');xlim([(rolllim-3) (rolllim+3)]); nicegraph;hold on;
  axis normal;hold on;
  
  subplot(1,3,3);title('Pitch drift');
  plot(pitch,0,'ko','MarkerFaceColor','r','MarkerSize',3);
  xlabel('angle deviation deg');xlim([(pitchlim-3) (pitchlim+3)]); nicegraph;hold on;
  axis normal;hold on;
  
  
  cnt = cnt+1;
  
  
  % sending
  try
      %judp('send',8888,'localhost',int8('Connection stablished! keep sending'));
      if B == '0'         
          %o=0;
          judp('send',8888,'localhost',int8('Connection terminated...chao!'));
      end
      
  catch
      
  end
  
  
  
  %------------------------ Do my stuff
  
  x = 0:0.001:1;
  y = 0:1:1000;
 
 
  
  if strcmp(B,'xlimmin')
      
       plot(x,y,'o');
       ylim([0 100])
       hold on;
    
  end
  
  if strcmp(B,'xlimmax')
      
       plot(x,y);
       ylim([0 50])
       hold on; 
      
  end
      
  
  
  
  %------------------------ End Do my stuff
  
  
  
  
  
 pause(0.01);
  
%   t = t +1;
%   
%   arr=cat(1,arr,Q);
%   n=size(arr,1);
%   
%   if n > 800
%   
%        plot(arr(n-800:n,1), 'k');
%   
%   else 
%        plot(arr(:,1), 'k');
%   end
%   
%   ylim([-120 120])
  %%hold on
  %scatter(Q,Q);
  
 
end