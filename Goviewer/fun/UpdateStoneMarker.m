function UpdateStoneMarker(h)
% 刷新当前棋子标记

fig = ancestor(h,'figure');
ax = findobj(fig,'type','axes');
marker = findobj(ax,'tag','marker','type','patch');
delete(marker);
Manager = get(fig,'UserData');

obj = getPropValDATA(Manager,'CURRENT_STONE');
while(obj.status==2)
  obj=obj.parent;
end
state = getPropValDATA(Manager,'CURRENT_STATE');
[m,n]=size(state);%#ok
p = obj.position;

if ~isempty(p)
  x=p(2);
  y=m+1-p(1);
  xdata=[x;x;x+0.4;x];
  ydata=[y;y-0.4;y;y];
  patch(ax,'XData',xdata,'YData',ydata,...
    'EdgeColor','none','FaceColor','r','tag','marker');
end

