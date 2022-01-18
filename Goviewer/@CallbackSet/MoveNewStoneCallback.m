function status = MoveNewStoneCallback(h,e,s)
% 落子程序回调函数
%
% MoveStoneCallback(h,e)   % 按照黑白顺序落子
% MoveStoneCallback(h,e,1) % 指定黑棋落子
% MoveStoneCallback(h,e,2) % 指定白棋落子
%
% 提示：该函数与Pass程序无关

fig = ancestor(h,'figure');
ax  = findobj(fig,'type','axes');
Manager = get(fig,'UserData');
o1 = onCleanup(@() UpdateStoneMarker(h) );
o2 = onCleanup(@() UpdateStoneOrder(h) );
o6 = onCleanup(@() updateStoneNode(fig) );
state0 = getPropValDATA(Manager,'CURRENT_STATE');
stone0 = getPropValDATA(Manager,'CURRENT_STONE');

% 获取落子区域
p = round(e.IntersectionPoint);
p0=p;
[m,n] = size(state0); %#ok
p = [m+1-p(2),p(1)];

% 确定落子方
% if nargin < 3
%   s = getPropValDATA(Manager,'NEXTSIDE');
% end

% 判断该点是否可以落子
result = tryMove(state0,s,p);
if ~result.canmove, status = 0; return, end
stone1 = moveStone(stone0,s,p);
refreshOrderProp(stone1);

% 判断该点是否和劫有关，如果当前处于劫的位置，如果当前落子
% 位置正好是劫位置，则无法落子
isKOLocked = getPropValDATA(Manager,'ISKOLOCKED');
if isKOLocked
  parentStone = stone0.parent; %#ok
  pRemovedStone0 = stone0.pRemovedStone;
  if p(1)==pRemovedStone0(1)
    if p(2)==pRemovedStone0(2)
      status = 0;
      return
    end
  end
  isKOLocked = 0;
else %(isKOLocked==0)
  % 造劫的过程
  isKO = result.isko;
  if isKO
    isKOLocked = 1;
  end
end

% 绘制落子
r = getPropValCONFIG(Manager,'STONERADIUS');
theta = getPropValCONFIG(Manager,'THETAFORCIRCLE');
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
set(hMove,'userdata',p); % 追踪落子位置p（矩阵索引）
setappdata(hMove,'status',1);
stone1.HasBeenPlayedOnBoard=1;
playsound('move');

% 去掉提子
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

% 保存信息
setPropValDATA(Manager,'CURRENT_STONE',stone1);
setPropValDATA(Manager,'CURRENT_STATE',result.state1);
setPropValDATA(Manager,'ISKOLOCKED'   ,isKOLocked);
setPropValDATA(Manager,'NEXTSIDE'    ,s-(-1)^s);

SGFInfoSyncFun(stone1,1);
%showSGFInfo(stone1);

end