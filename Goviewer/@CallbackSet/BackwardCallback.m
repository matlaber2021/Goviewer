function BackwardCallback(h,e)
% Backward callback, Noticing that the backward does not perform an inverse
% operation, relative to the forward callback. Backward only fall back to 
% the parent node. And the backward callback would not change the Stone 
% hierarchical structure.
%
% Warning:
% The HasBeenPlayedOnBoard property is 1, the backward step will not change
% the state of HasBeenPlayedOnBoard.

fig = ancestor(h,'figure');
ax=findobj(fig,'type','axes');
Manager = get(fig,'UserData');
o1 = onCleanup(@() CallbackSet.CommentSyncCallback(h,e) );
o2 = onCleanup(@() UpdateStoneMarker(h) );
o3 = onCleanup(@() UpdateStoneOrder(h) );
o4 = onCleanup(@() ShowChildNodePath(h));
o5 = onCleanup(@() updateStoneLabels(h) );
o6 = onCleanup(@() updateStoneNode(fig) );

state0=Manager.DATA.CURRENT_STATE;

backwardfun(fig);
state1=Manager.DATA.CURRENT_STATE;
%stone1=Manager.DATA.CURRENT_STONE;

[rr,cc]=find(state1~=state0);
pp=[rr,cc];
[m,n]=size(state1);%#ok
theta = Manager.CONFIG.THETAFORCIRCLE;
r=Manager.CONFIG.STONERADIUS;

for idx=1:size(pp,1)
  x=cc(idx)+r*cos(theta)';
  y=m+1-rr(idx)+r*sin(theta)';
  hh=findobj(ax,'tag','stone','UserData',pp(idx,:));
  
  if(state1(pp(idx,1),pp(idx,2))==0)
    delete(hh);
  elseif(state1(pp(idx,1),pp(idx,2))==1)
    if(~isempty(hh))
      set(hh,'FaceColor','k');
    else
      hh = patch('parent',ax,'xdata',x,'ydata',y,'FaceColor','k');
      set(hh,'tag','stone','userdata',pp(idx,:));
      %set(hh,'DataTipTemplate',stone1.note);
    end
  elseif(state1(pp(idx,1),pp(idx,2))==2)
    if(~isempty(hh))
      set(hh,'FaceColor','w');
    else
      hh = patch('parent',ax,'xdata',x,'ydata',y,'FaceColor','w');
      set(hh,'tag','stone','userdata',pp(idx,:));
      %set(hh,'DataTipTemplate',stone1.note);
    end
  end
end
%stone1.HasBeenPlayedOnBoard=1;