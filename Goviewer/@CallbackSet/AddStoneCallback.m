function AddStoneCallback(h,e,s)
% 添加落子的回调函数

fig = ancestor(h,'figure');
ax  = findobj(fig,'type','axes');
Manager = get(fig,'UserData');

state0 = getPropValDATA(Manager,'CURRENT_STATE');
stone0 = getPropValDATA(Manager,'CURRENT_STONE');

% 获取落子区域
p = round(e.IntersectionPoint);
p0=p;
[m,n] = size(state0); %#ok
p = [m+1-p(2),p(1)];
if state0(p(1),p(2))~=0, return, end

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

hAdd = patch(...
    'parent',ax,'XData',x1,'YData',y1,'FaceColor',c);
set(hAdd,'tag','stone');
set(hAdd,'userdata',p); % 追踪落子位置p（矩阵索引）
setappdata(hAdd,'status',2);

% 保存信息
state1=state0;
state1(p(1),p(2))=s;
stone1 = addStone(stone0,s,p); % TODO...
stone1.HasBeenPlayedOnBoard=1;
refreshOrderProp(stone1);
setPropValDATA(Manager,'CURRENT_STONE',stone1);
setPropValDATA(Manager,'CURRENT_STATE',state1);
SGFInfoSyncFun(stone1,1);
showSGFInfo(stone1);