function h=arrow(ax,x,y,headlength)
% A simple arrow function in the specified axes.

l=headlength;
if(x(1)==x(2))
  if(y(1)==y(2))
    h=[];
    return
  end
end

% solve the arrow position
o = onCleanup(@() set(ax,'DataAspectRatio',[1,1,1]));
if(x(1)==x(2))
  X=x(2);
  Y=y(2);
  x_a=[X;X-0.5*l;X+0.5*l;X];
  y_a=[Y;Y-sign(y(2)-y(1))*l;Y-sign(y(2)-y(1))*l;Y];
end

if(y(1)==y(2))
  X=x(2);
  Y=y(2);
  x_a=[X;X-sign(x(2)-x(1))*l;X-sign(x(2)-x(1))*l;X];
  y_a=[Y;Y-0.5*l;Y+0.5*l;Y];
end

if(x(1)~=x(2))
  if(y(1)~=y(2))
    x1=x(1);
    x2=x(2);
    y1=y(1);
    y2=y(2);
    D=sqrt((x1-x2)^2+(y1-y2)^2);
    k1=(y2-y1)/(x2-x1);
    theta=[atan(-1/k1);atan(-1/k1)+pi];
    x0=x2-(l/D)*(x2-x1);
    y0=y2-(l/D)*(y2-y1);
    
    x_a=[x2;x0+1/2*l*cos(theta);x2];
    y_a=[y2;y0+1/2*l*sin(theta);y2];
    
  end
end

line(ax,'XData',x,'YData',y,'Tag','arrow','Color','m','LineWidth',2);
patch(ax,'XData',x_a,'YData',y_a,'Tag','arrow','FaceColor','m',...
  'EdgeColor','m');