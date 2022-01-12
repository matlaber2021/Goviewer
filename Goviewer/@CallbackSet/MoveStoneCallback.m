function MoveStoneCallback(h,e,s)
% 落子程序

fig = ancestor(h,'figure');
Manager = get(fig,'UserData');
state0 = getPropValDATA(Manager,'CURRENT_STATE');
stone0 = getPropValDATA(Manager,'CURRENT_STONE');

[m,n]=size(state0); %#ok
p=round(e.IntersectionPoint); % Board Index
p0=p; % Matrix Index
p = [m+1-p(2),p(1)];

% 查找当前落子位置是否是已知节点
children=stone0.children;
L=length(children);
isNewStone=1;
idx=[];
for i=1:L
  child=children(i);
  if(~child.HasBeenPlayedOnBoard)
    SGFInfoSyncFun(child,-1);
  end
  
  if(child.status==1)
    if(isequal(child.position,p))
      isNewStone=0;
      idx=i;
      break
    else
      
    end
  end
  
  if(child.status==2)
    N=size(child.position,1);
    for j=1:N
      if(isequal(child.position,p0))
        isNewStone=0;
        idx=i;
        break;
      end
    end
    if(isNewStone==0)
      break
    end
  end
end

if(isNewStone)
  CallbackSet.MoveNewStoneCallback(h,e,s);
end

if(~isNewStone)
  CallbackSet.ForwardCallback(h,e,idx);
end