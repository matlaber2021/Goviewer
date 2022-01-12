function DeadStoneCallback(h,e)
% 确认死子回调函数

fig = ancestor(h,'figure');
ax = findobj(fig,'type','axes');
Manager=get(fig,'UserData');
state=getPropValDATA(Manager,'CURRENT_STATE');

% 对当前局面作区域分析
%result = simpleJudgment(state);
p=round(e.IntersectionPoint);
[m,~]=size(state);
x=m+1-p(2);
y=p(1);

if state(x,y)==0, return, end
if state(x,y)==1
  color = 'g';
elseif state(x,y)==2
  color = 'c';
end

p1 = findBlock(state,[x,y]);
[~,p2] = getLiberty(state,p1);
pEmpty=NaN([0,2]);
for i=1:size(p2,1)
  pEmpty = [pEmpty; findBlock(state,p2(i,:))]; %#ok
end
pEmpty = unique(pEmpty,'rows','stable');

% % 判断当前的区域是否和已经确定的区域相重叠
% hRegions = findobj(ax,'tag','region');
% pEmpty_Done = get(hRegions,'UserData');
% if iscell(pEmpty_Done)
%   pEmpty_Done = vertcat(pEmpty_Done{:});
% elseif isempty(pEmpty_Done)
%   pEmpty_Done = NaN([0,2]);
% end
% for i = size(pEmpty,1):-1:1
%   P = setdiff(pEmpty(i,:),pEmpty_Done,'rows');
%   if isempty(P)
%     pEmpty(i,:) = [];
%   end
% end

P=[p1; pEmpty];
for i = 1:size(P,1)
  x=P(i,2);
  y=m+1-P(i,1);
  xdata=[x-0.3;x+0.3;x+0.3;x-0.3;x-0.3];
  ydata=[y-0.3;y-0.3;y+0.3;y+0.3;y-0.3];
  patch(ax,'XData',xdata,'YData',ydata,'Tag','region', ...
    'userdata', [x,y] ,'EdgeColor','none','FaceColor',color,...
    'facealpha',0.5);
end
