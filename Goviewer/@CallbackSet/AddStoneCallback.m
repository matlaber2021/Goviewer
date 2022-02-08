function AddStoneCallback(h,e,s)
% adding black or white stone callback

flag=checkToggleButtonHandle(h,s);
if(flag), return; end

fig=ancestor(h,'figure');
ax=findobj(fig,'type','axes');
manager=get(fig,'UserData');

o1 = onCleanup(@() CallbackSet.CommentSyncCallback(h,e) );
o2 = onCleanup(@() updateStoneOrder(fig) );
o3 = onCleanup(@() updateStoneMarker(fig) );
o4 = onCleanup(@() updateStonePath(fig));
o5 = onCleanup(@() updateStoneLabels(fig) );
o6 = onCleanup(@() updateStoneNode(fig) );

state0 = getPropValDATA(manager,'CURRENT_STATE');
stone0 = getPropValDATA(manager,'CURRENT_STONE');

% gain the region of moving stones
p = round(e.IntersectionPoint);
p0=p;
[m,n] = size(state0); %#ok
p = [m+1-p(2),p(1)];
if state0(p(1),p(2))~=0, return, end

% start to draw stones
r = getPropValCONFIG(manager,'STONERADIUS');
theta = getPropValCONFIG(manager,'THETAFORCIRCLE');
x1 = p0(1)+r*cos(theta);
y1 = p0(2)+r*sin(theta);
if s==1
  c = 'k';
elseif s==2
  c = 'w';
end

hAdd = patch(...
  'parent',ax,'XData',x1,'YData',y1,'FaceColor',c);
set(hAdd,'tag','stone');
set(hAdd,'userdata',p); % using matrix index to trace the stone drawn.
setappdata(hAdd,'status',2);

% save the manager infomation
state1=state0;
state1(p(1),p(2))=s;
stone1 = addStone(stone0,s,p); % TODO...
stone1.HasBeenPlayedOnBoard=1;
refreshOrderProp(stone1);
setPropValDATA(manager,'CURRENT_STONE',stone1);
setPropValDATA(manager,'CURRENT_STATE',state1);
SGFInfoSyncFun(stone1,1);

function flag=checkToggleButtonHandle(h,s)
% If the handle vararible is uitoggle object, then other uitoggle button
% state will be released after pushing it. If handle variable is other
% object, just neglect this function.
%
% But if the button needs to release, then need to restore the objects on
% the board to make sure the callback property is default value.

if ~isa(h,'matlab.ui.container.toolbar.ToggleTool')
  flag=0;
  return
else
  flag=1;
end

fig=ancestor(h,'figure');
ax=findobj(fig,'type','axes');
%GoViewer.initCallbackOnBoard(ax);
children = findall(ax);

if strcmp(h.State,'on')
  toolbar=h.Parent;
  obj=findobj(toolbar,'-not','tooltip',get(h,'tooltip'),...
    'type','uitoggletool');
  set(obj,'State','off');
  
  set(children,'ButtonDownFcn',{@CallbackSet.AddStoneCallback,s});
else
  set(children,'ButtonDownFcn',@CallbackSet.DefaultCallback);
end