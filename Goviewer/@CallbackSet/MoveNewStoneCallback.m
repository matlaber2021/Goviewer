function status = MoveNewStoneCallback(h,e,s)
% callback of moving new stones
%
% MoveStoneCallback(h,e,1) % move new black stone
% MoveStoneCallback(h,e,2) % move new white stone
%
% Hint
% The function has nothing to do with pass callbacks.

fig = ancestor(h,'figure');
ax  = findobj(fig,'type','axes');
manager = get(fig,'UserData');
o1 = onCleanup(@() updateStoneMarker(h) );
o2 = onCleanup(@() updateStoneOrder(h) );
o6 = onCleanup(@() updateStoneNode(fig) );
state0 = getPropValDATA(manager,'CURRENT_STATE');
stone0 = getPropValDATA(manager,'CURRENT_STONE');

% get the region of position clicked
p = round(e.IntersectionPoint);
p0=p;
[m,n] = size(state0); %#ok
p = [m+1-p(2),p(1)];

% decide if the position can move, try it.
result = tryMove(state0,s,p);
if ~result.canmove, status = 0; return, end

% Decide if the point is related to ko, if the ko state is locked, the
% position cannot move.
isKOLocked=manager.DATA.ISKOLOCKED;
if isKOLocked
  parentStone = stone0.parent; %#ok
  pRemovedStone0 = stone0.pRemovedStone;
  if p(1)==pRemovedStone0(1)
    if p(2)==pRemovedStone0(2)
      status = 0;
      return
    end
  end
  
  % BUGFIX: If double ko, maybe the ko state still locked.
  isKOLocked = result.isko;
  
else %(isKOLocked==0)
  % make ko
  isKO = result.isko;
  if isKO
    isKOLocked = 1;
  end
end

% add new Stone object after ko state judgment
stone1 = moveStone(stone0,s,p);
refreshOrderProp(stone1);

% draw moving stone
r = getPropValCONFIG(manager,'STONERADIUS');
theta = getPropValCONFIG(manager,'THETAFORCIRCLE');
x1 = p0(1)+r*cos(theta);
y1 = p0(2)+r*sin(theta);
if s==1
  c = 'k';
elseif s==2
  c = 'w';
end

hMove = patch(...
  'parent',ax,'XData',x1,'YData',y1,'FaceColor',c);
set(hMove,'tag','stone');
set(hMove,'userdata',p);
setappdata(hMove,'status',1);
stone1.HasBeenPlayedOnBoard=1;
playsound('move');

% remove the prisoners
pToBeRemoved = result.totake;
N = size(pToBeRemoved,1);
for i = 1:N
  hRm = findobj(...
    ax,'userdata',pToBeRemoved(i,:),'tag','stone');
  delete(hRm);
end
stone1.pRemovedStone = pToBeRemoved;
if ~isempty(pToBeRemoved)
  playsound('deadstonemore');
end

% save infomation
setPropValDATA(manager,'CURRENT_STONE',stone1);
setPropValDATA(manager,'CURRENT_STATE',result.state1);
setPropValDATA(manager,'ISKOLOCKED'   ,isKOLocked);
setPropValDATA(manager,'NEXTSIDE'    ,s-(-1)^s);

SGFInfoSyncFun(stone1,1);