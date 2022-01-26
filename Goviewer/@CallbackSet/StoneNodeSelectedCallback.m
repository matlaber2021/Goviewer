function StoneNodeSelectedCallback(h,e)

CallbackSet.StoneNodeExpandCallback(h,e);

node=h.SelectedNodes;
if(isempty(node)), return; end

ufig=ancestor(h,'figure');
fig=get(ufig,'UserData');
ax=findobj(fig,'type','axes');
Manager=get(fig,'UserData');
stone0=Manager.DATA.CURRENT_STONE;
state0=Manager.DATA.CURRENT_STATE;

o1 = onCleanup(@() CallbackSet.CommentSyncCallback(fig,[]) );
o2 = onCleanup(@() UpdateStoneMarker(fig) );
o3 = onCleanup(@() UpdateStoneOrder(fig) );
o4 = onCleanup(@() ShowChildNodePath(fig));
o5 = onCleanup(@() updateStoneMarkup(fig));
% o6 = onCleanup(@() checkDim(fig) );

stone1=node.NodeData;
route=getStoneRoute(stone0,stone1);
for idx=1:length(route.direction)
  if(route.direction(idx)==-1)
    backwardfun(fig);
  elseif(route.direction(idx)==1)
    forwardfunToChild(fig,route.index(idx));
  end
end

state1=Manager.DATA.CURRENT_STATE;
stone1_=Manager.DATA.CURRENT_STONE;

if(~isequal(stone1,stone1_))
  error('路径错误，原因待排查...');
end

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
