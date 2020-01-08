function obj = circulo(x,y,r,color)

if nargin <=3
obj=rectangle('Position',[x,y,r,r],'Curvature',[1 1]);
else
obj=rectangle('Position',[x,y,r,r],'Curvature',[1 1],'FaceColor',color);
    
end
end