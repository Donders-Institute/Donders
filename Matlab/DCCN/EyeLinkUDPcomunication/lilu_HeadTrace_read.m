% Jose Garcia-Uceda Calvo
% Reading a txt file with data and delimiter comma 

clear
clc
close all

fileID = fopen('HeadTrace.txt','r');
C = textscan(fileID,'%f %f %f %f','Delimiter',',');
fclose(fileID);

tilt=C{1,1}
yaw=C{1,2}
roll=C{1,3}
seconds=C{1,4}

figure(73)
plot(tilt,'k.');
hold on
plot(yaw,'b.');
hold on
plot(roll,'g.');

