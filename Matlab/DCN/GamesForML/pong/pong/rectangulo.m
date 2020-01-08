function rect = rectangulo(x,y,width,span,color)
global MainCanvas

if nargin <=4
rect = patch([0 width width 0],[0 0 span span],...
            'red',...
            'EdgeColor','none', ...
            'Visible','on', ...
            'Parent', MainCanvas);    
        
        rect.XData = rect.XData + x;
        rect.YData = rect.YData + y;
else
    rect = patch([0 width width 0],[0 0 span span],...
            color,...
            'EdgeColor','none', ...
            'Visible','on', ...
            'Parent', MainCanvas);    
        
        rect.XData = rect.XData + x;
        rect.YData = rect.YData + y;
end

end