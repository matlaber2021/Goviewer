function RetractStoneCallback(h,e) %#ok
% 悔棋回调函数

fig = ancestor(h,'figure');
ax  = findobj(fig,'type','axes');

Manager = get(fig,'UserData');
o1 = onCleanup(@() UpdateStoneMarker(h) );
o2 = onCleanup(@() UpdateStoneOrder(h) );
state0 = getPropValDATA(Manager,'CURRENT_STATE');
stone0 = getPropValDATA(Manager,'CURRENT_STONE');

[m,n]=size(state0); %#ok
if isempty(stone0.parent), return; end
if ~isempty(stone0.children), return; end

% 清除节点并解除关联，找到恢复的提子
stone1 = stone0.parent;
pRestore = stone0.pRemovedStone;
if isempty(stone0.side)
  sRes = 1;
  cRes = 'k';
elseif stone0.side==1
  sRes = 2;
  cRes = 'w';
elseif stone0.side==2
  sRes = 1;
  cRes = 'k';
end

% 删除最新的落子
% 兼容AB[??][??][??]...的情形
p = stone0.position;
for idx=1:size(p,1)
h = findobj(ax,'userdata',p(idx,:),'tag','stone');
delete(h);
end
deleteStone(stone0);

% 恢复提子
N = size(pRestore,1);
r = getPropValCONFIG(Manager,'STONERADIUS');
theta = getPropValCONFIG(Manager,'THETAFORCIRCLE');

for k = 1:N
  x = pRestore(k,2)+r*cos(theta);
  y = m+1-pRestore(k,1)+r*sin(theta);
  %drawnow;
  hRes = patch(...
    'parent',ax,'XData',x,'YData',y,'FaceColor',cRes);
  set(hRes,'tag','stone','userdata',pRestore(k,:));
end

% 修改当前棋盘状态
CURRENT_STATE = state0;
if ~isempty(p)
  CURRENT_STATE(p(1),p(2)) = 0;
end
if ~isempty(pRestore)
  for k = 1:N
    CURRENT_STATE(pRestore(k,1), pRestore(k,2)) ...
      = sRes;
  end
end
setPropValDATA(Manager,'CURRENT_STONE',stone1);
setPropValDATA(Manager,'CURRENT_STATE',CURRENT_STATE);
setPropValDATA(Manager,'ISKOLOCKED',0);

end

