function DefaultCallback(h,e)
% 默认模式下的回调函数
% [1] 左击鼠标：落子模式
% [2] 右击鼠标：悔棋模式

persistent NEWSTONE

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
stone=Manager.DATA.CURRENT_STONE;
while 1
  if(stone.status~=2)
    break
  end
  stone=stone.parent;
end

if(isempty(NEWSTONE))
  if(stone.status==0)
    NEWSTONE=1;
  end
end

if(isempty(NEWSTONE))
  if(stone.status>0)
    NEWSTONE=stone.side-(-1)^(stone.side);
  end
end

if(~isempty(NEWSTONE))
  NEWSTONE=NEWSTONE-(-1)^(NEWSTONE);
end

iPoint = e.Button;
if iPoint==1      % 左点鼠标
  CallbackSet.MoveStoneCallback(h,e,NEWSTONE);
elseif iPoint==3  % 右点鼠标
  CallbackSet.RetractStoneCallback(h,e);
end

end