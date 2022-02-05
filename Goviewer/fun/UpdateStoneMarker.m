function updateStoneMarker(h)
% refresh the current red triangle marker.

fig=ancestor(h,'figure');
ax=findobj(fig,'type','axes');
marker = findobj(ax,'tag','marker','type','patch');
delete(marker);
manager=get(fig,'UserData');
stone=manager.DATA.CURRENT_STONE;
state=manager.DATA.CURRENT_STATE;
[m,n]=size(state); %#ok

% If the board shows no move numbers, then we can display the stone marker,
% otherwise stone marker is disallowed.
option=manager.CONFIG.STONE_ORDER_OPTION;
if(option~=1), return; end

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

if(stone.status==1)
  p=stone.position;
  if ~isempty(p)
    x=p(2);
    y=m+1-p(1);
    xdata=[x;x;x+0.4;x];
    ydata=[y;y-0.4;y;y];
    patch(ax,'XData',xdata,'YData',ydata,...
      'EdgeColor','none','FaceColor','r','tag','marker');
  end
end

