function DefaultCallback(h,e)
% the default callback on the graphic objects on the board
% [1] left click: move stone
% [2] right click: redo stone
%
% This function also works on the uipushtool button.

flag=checkPushButtonHandle(h);
if(flag), return; end

fig=ancestor(h,'figure');
manager=get(fig,'UserData');
NEXTSIDE=manager.DATA.NEXTSIDE;
if(isempty(NEXTSIDE)), NEXTSIDE=1; end

iPoint = e.Button;
if iPoint==1      % left click
  CallbackSet.MoveStoneCallback(h,e,NEXTSIDE);
elseif iPoint==3  % right click
  CallbackSet.RetractStoneCallback(h,e);
end

function flag=checkPushButtonHandle(h)
% If the handle vararible is uipush object, then other uipush button
% state will be released after pushing it. If handle variable is other
% object, just neglect this function.
%

if ~isa(h,'matlab.ui.container.toolbar.PushTool')
  flag=0;
  return
else
  flag=1;
end

fig=ancestor(h,'figure');
ax=findobj(fig,'type','axes');
GoViewer.initCallbackOnBoard(ax);

toolbar=h.Parent;
obj=findobj(toolbar,'type','uitoggletool');
set(obj,'State','off');

manager=get(fig,'UserData');
s=manager.DATA.NEXTSIDE;
manager.DATA.NEXTSIDE=s-(-1)^s;
