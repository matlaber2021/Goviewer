function result = tryMove(state,s,p)
% 尝试落子算法
%
% 棋盘：19*19
% 放置黑棋：1
% 未放置：0
% 放置白棋：2
%
% 棋子
% Black：1
% White：2
% Pass：0

result.canmove = [];    % 是否可以落子
result.code = [];       % 行为代码
result.action = 'move'; % 行为类别
result.stone = s;       % 落子颜色
result.position = p;    % 落子坐标
result.totake = [];     % 提子坐标
result.isko = 0;        % 是否为提劫动作
result.state0 = state;  % 落子前状态
result.state1 = state;     % 落子后状态

% 如果选择当前局面弃权，则认为弃权有效，且可以在任意棋盘位置弃权
if (isempty(p))
  result.canmove=1;
  result.code=0;
  result.state1=state;
  return
end

x=p(1);
y=p(2);
[M,N] = size(state);

if x>M || x<0
  result.canmove=0;
  result.code=-3;
  return
end

if y>N || y<0
  result.canmove=0;
  result.code=-3;
  return
end

if(s==0)
  result.canmove=0;
  result.code=-4;
  return
end

% 如果落子的位置已经有子，则不可落子（code=-1）
if state(x,y)~=0
  result.canmove=0;
  result.code=-1;
  %result.state1=[];
  return
end

STATE = state;
STATE(x,y)=s;
next = NaN(0,2);

% 找到对方的邻接棋子
if x>1
  if state(x-1,y)~=0
    if state(x-1,y)~=s
      next = [next; [x-1,y] ];
    end
  end
end
if x<M
  if state(x+1,y)~=0
    if state(x+1,y)~=s
      next = [next; [x+1,y] ];
    end
  end
end
if y>1
  if state(x,y-1)~=0
    if state(x,y-1)~=s
      next = [next; [x,y-1] ];
    end
  end
end
if y<N
  if state(x,y+1)~=0
    if state(x,y+1)~=s
      next = [next; [x,y+1] ];
    end
  end
end

nn = size(next,1);
bNext = cell([nn,1]);
%numBlock=0;
snNext=NaN([nn,1]); % 各个块状区域的数量
lnNext=NaN([nn,1]); % 各个块状区域的气
for i = 1:nn
  bNext{i} = findBlock(STATE,next(i,:));
  if ~isempty(bNext{i})
    %numBlock=numBlock+1;
    lnNext(i) = getLiberty(STATE,bNext{i});
  end
  snNext(i) = size(bNext{i},1);
end

% 打劫的情形是正常的
bSelf = findBlock(STATE,p);
lnSelf = getLiberty(STATE,bSelf);

idx = lnNext==0 & snNext==1;
if sum(lnNext==0)==1
  if sum(idx)==1
    if lnSelf == 0
      if size(bSelf,1)==1
        %FindKO = 1;
        pKO = next(idx,:);
        
        STATE1 = STATE;
        STATE1(pKO(1,1), pKO(1,2)) = 0;
        
        result.canmove = 1;
        result.code = 0;
        result.totake = pKO;
        result.isko = 1; %%
        result.state1 = STATE1;
        return
      end
    end
  end
end

% 正常提子的情形
if any(lnNext==0)
  idx = find(lnNext==0);
  pToBeRemoved = vertcat(bNext{idx});
  pToBeRemoved = unique(pToBeRemoved,'rows','stable');
  NumRm = size(pToBeRemoved,1);
  STATE1 = STATE;
  for k = 1:NumRm
    xp = pToBeRemoved(k,1);
    yp = pToBeRemoved(k,2);
    STATE1(xp,yp)=0;
  end
  
  result.canmove = 1;
  result.code = 0;
  result.totake = pToBeRemoved;
  result.state1 = STATE1;
  return
end

% 以下情形考虑没有提子的情形

% 存在禁入点的情形（code=-2）
if all(lnNext~=0)
  if lnSelf==0
    result.canmove=0;
    result.code=-2;
    return
  end
end

% 正常落子
result.canmove=1;
result.code=0;
result.state1=STATE;






