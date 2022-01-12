function DrawTerrtory(ax,p,s)

h=findobj(ax,'tag','judgment');
delete(h);
[m,n]=size(CURRENT_STATE);
N=size(p,1);
for i = 1:N
  x=p(i,2);
  y=m+1-p(i,1);
  xdata=[x-0.3;x+0.3;x+0.3;x-0.3;x-0.3];
  ydata=[y-0.3;y-0.3;y+0.3;y+0.3;y-0.3];
  if s==1
    patch(ax,'XData',xdata,'YData',ydata,'Tag','judgment',...
      'EdgeColor','none','FaceColor','g');
  elseif s==2
    patch(ax,'XData',xdata,'YData',ydata,'Tag','judgment',...
      'EdgeColor','none','FaceColor','c');
  end
end