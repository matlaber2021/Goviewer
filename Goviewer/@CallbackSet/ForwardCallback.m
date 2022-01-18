function ForwardCallback(h,e,idx)
% Forwarding callback
%
% ForwardCallback(handle,event)  Forward way follows preorder-traversal of
% the Stone tree-struct.
%
% ForwardCallback(handle,event,index) Getting to the nth children of the
% current stone, is much easier than the preorder-traversal method.
%
% Hint:
% ForwardCallback would not change the Stone hierarchical structure.

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

if nargin==2
  forwardfun(fig);
elseif(nargin==3)
  forwardfunToChild(fig,idx);
end

state1=Manager.DATA.CURRENT_STATE;
stone1=Manager.DATA.CURRENT_STONE;

[rr,cc]=find(state1~=state0);
pp=[rr,cc];
[m,n]=size(state1);%#ok
theta = linspace(0,2*pi,20);
r=0.45;

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
stone1.HasBeenPlayedOnBoard=1;
