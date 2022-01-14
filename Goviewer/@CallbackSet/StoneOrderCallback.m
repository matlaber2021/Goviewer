function StoneOrderCallback(h,e,option) %#ok
% 展示棋子的顺序

% option
% 1: 不显示棋子顺序
% 2: 显示最近1手
% 3: 显示最近5手
% 4: 显示所有手

% persistent option
% if isempty(option)
%   option=1;
% elseif option==1
%   option=2;
% elseif option==2
%   option=3;
% elseif option==3
%   option=4;
% elseif option==4
%   option=1;
% end

fig=ancestor(h,'figure');
ax=findobj(fig,'type','axes');
h=findobj(ax,'tag','order');
if ~isempty(h)
  delete(h);
end
Manager=get(fig,'UserData');
stone = getPropValDATA(Manager,'CURRENT_STONE');
state = getPropValDATA(Manager,'CURRENT_STATE');
[m,n]=size(state); %#ok
beenDrawn=zeros(size(state));
addedStoneState=zeros(size(state));

switch option
  case {2}
    MAX_ORDER_NUM=1;
  case {3}
    MAX_ORDER_NUM=5;
  case {4}
    MAX_ORDER_NUM=Inf;
  otherwise
    return
end

NUM=1;
while(stone.order>0)
  
  p=stone.position;
  
  if(stone.status==2)
    for ii=1:size(p,1)
      addedStoneState(p(ii,1),p(ii,2))=1;
    end
    stone=stone.parent;
    continue
  elseif(isempty(stone.position))
    stone=stone.parent;
    continue;
  end
  
  if(NUM>MAX_ORDER_NUM)
    break
  end
  
  x=p(2);
  y=m+1-p(1);
  O=stone.order;
  
  if O<100
    fontsize=11;
    fontname='Arial';
  else
    fontsize=9;
    fontname='Arial';
  end
  
  if stone.side==1
    color='w';
  elseif stone.side==2
    color='k';
  end
  
  if state(p(1),p(2))~=0
    if beenDrawn(p(1),p(2))==0
      if(~addedStoneState(p(1),p(2)))
        text(ax,x,y,num2str(stone.order),...
          'FontSize',fontsize,...
          'FontName',fontname,...
          'Color',color,...
          'Tag','order',...
          'FontWeight','bold',...
          'HorizontalAlignment','center',...
          'VerticalAlignment','middle');
        beenDrawn(p(1),p(2))=1;
      end
    end
  end
  
  if(O==1)
    break
  end
  
  stone=stone.parent;
  NUM=NUM+1;
  
end

