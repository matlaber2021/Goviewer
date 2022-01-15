function UpdateStoneMarker(h)
% 刷新当前棋子标记

fig = ancestor(h,'figure');
ax = findobj(fig,'type','axes');
marker = findobj(ax,'tag','marker','type','patch');
delete(marker);
Manager = get(fig,'UserData');

stone = getPropValDATA(Manager,'CURRENT_STONE');

while(stone.status~=1)
  
  % BUGFIX
  if(stone.status==2)
    if(stone.side==0)
      break
    end
  end
  stone=stone.parent;
  if(isempty(stone)), return; end %BUGFIX
end
state = getPropValDATA(Manager,'CURRENT_STATE');
[m,n]=size(state);%#ok


if(stone.status==1)
  p = stone.position;
if ~isempty(p)
  x=p(2);
  y=m+1-p(1);
  xdata=[x;x;x+0.4;x];
  ydata=[y;y-0.4;y;y];
  patch(ax,'XData',xdata,'YData',ydata,...
    'EdgeColor','none','FaceColor','r','tag','marker');
end
end

