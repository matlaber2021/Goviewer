function LeelazGameCallback(h,e) %#ok
% leelaz对局回调函数

fig = ancestor(h,'figure');
Manager = get(fig,'UserData');

% 激活认输按钮
fprintf('激活认输按钮...\n');
hh = findobj(fig,'ToolTip','resign');
set(hh,'Enable','on');
o = onCleanup(@() set(hh,'Enable','off') );

fprintf('正在设置对局参数...\n');
GoViewer.LeelazOptionsWindow(fig);
waitfor(Manager,'OPTIONSET_LEELAZERO',1);

% 准备建立与引擎的通信
fprintf('准备建立与引擎的通信...\n');
Manager = get(fig,'UserData');
Engine = LeelaZero.EngineInterface();
KOMI   = Manager.LEELAZERO.KOMI;
Manager.LEELAZERO.ENGINE = Engine;

% 设定贴目规则
fprintf('设定贴目规则（中国规则7目半）...\n');
message=sprintf('Komi %s',char(KOMI));
sendCommand(Engine,message);
WaitForCommands(Engine);

% 设定LeelaZero用时
fprintf('设定LeelaZero用时（1秒1步）...\n');
message='time_settings 0 1 1';
sendCommand(Engine,message);
WaitForCommands(Engine);

% 设定让子棋规则（如有）
fprintf('设定让子棋规则（如有）...\n');
initHandicapGame(fig);

% 开始对局
fprintf('开始对局...\n');
Manager.GAMERESULT.ISOVER = 0;
Manager.GAMERESULT.CONTINUE = 1;
Manager.GAMERESULT.HUMAN_PASS = 0;
Manager.GAMERESULT.LEELAZ_PASS = 0;
while (~Manager.GAMERESULT.ISOVER)
  WaitForLeelaMove(fig);
  WaitForHumanMove(fig);
  pause(0.001);
end
Manager.GAMERESULT.CONTINUE = 0;

end

function WaitForLeelaMove(fig)
% 等待LeelaZero落子的程序

Manager=get(fig,'UserData');
if (Manager.GAMERESULT.ISOVER)
  return;
end

Engine = Manager.LEELAZERO.ENGINE;
stone=getPropValDATA(Manager,'CURRENT_STONE');
state=getPropValDATA(Manager,'CURRENT_STATE');
[m,n]=size(state); %#ok
side0=stone.side;
sideL=Manager.LEELAZERO.LEELAZ_SIDE;
sideH=Manager.LEELAZERO.HUMAN_SIDE;

if sideL==1
  command = sprintf('genmove b');
elseif sideL==2
  command = sprintf('genmove w');
end

if isempty(side0)
  if sideH==1
    return
  end
end

cond=(sideL~=side0 & ~isempty(side0)) | ...
  (isempty(side0) & sideL==1);

if(cond)
  
  fprintf('向引擎传送指令[%s]...\n', command);
  sendCommand(Engine,command);
  msg=WaitForMove(Engine);
  
  p=regexp(msg,'=\s(.*?)\n','tokens');
  p=p{1}{1};
  p=strtrim(p);
  
  if strcmp(p,'resign')
    fprintf('LeelaZero投子认输，您已获胜.\n');
    quitEngine(Engine);
    
    Manager.GAMERESULT.ISOVER = 1;
    Manager.GAMERESULT.WINNER = Manager.LEELAZERO.HUMAN_SIDE;
    Manager.OPTIONSET_LEELAZERO = 0;
    Manager.GAMERESULT.CONTINUE = 0;
    return
  elseif(strcmp(p,'pass'))
    % TODO
    fprintf('LeelaZero选择弃权.\n');
    Manager.GAMERESULT.LEELAZ_PASS = 1;
    if(Manager.GAMERESULT.HUMAN_PASS)
      fprintf('由于您也弃权，棋局终止.\n');
      Manager.GAMERESULT.ISOVER = 1;
      Manager.GAMERESULT.WINNER = [];
      Manager.OPTIONSET_LEELAZERO = 0;
      Manager.GAMERESULT.CONTINUE = 0;
      return
    end
    Manager.GAMERESULT.HUMAN_PASS = 0;
    
    if(Manager.LEELAZERO.LEELAZ_SIDE==2)
      CallbackSet.WhitePassCallback(h,e);
    elseif(Manager.LEELAZERO.LEELAZ_SIDE==1)
      CallbackSet.BlackPassCallback(h,e);
    end
    return
  else
    fprintf('LeelaZero选择落子%s...\n',p);
  end
  
  P=zeros([1,3]);
  
  if p(1)<73
    P(1)=(p(1)-64);
    P(2)=str2double(p(2:end));
    
  elseif p(1)>73
    P(1)=(p(1)-65);
    P(2)=str2double(p(2:end));
    
  end
  
  % Leela Zero落子
  FormalEvent=struct();
  FormalEvent.IntersectionPoint=P;
  CallbackSet.MoveStoneCallback(fig,FormalEvent,sideL);
  
end

end

function WaitForHumanMove(fig)
% 等待人类落子程序

% 准备全局信息
Manager=get(fig,'UserData');
if (Manager.GAMERESULT.ISOVER)
  return;
end
ax = findobj(fig,'type','axes');
Engine=getPropValPrivFcn(Manager,'LEELAZERO','ENGINE');
sideH=getPropValPrivFcn(Manager,'LEELAZERO','HUMAN_SIDE');
state=getPropValDATA(Manager,'CURRENT_STATE');
[m,n]=size(state); %#ok
labels=get(ax,'XTickLabel');

% 如果已经识别到人类已经落子，程序终止
stone=getPropValDATA(Manager,'CURRENT_STONE');
sDone=stone.side;
if sDone==sideH
  return
end

% 设置循环等待人类落子
while(~Manager.GAMERESULT.ISOVER) && (~Manager.GAMERESULT.HUMAN_PASS)
  stone=getPropValDATA(Manager,'CURRENT_STONE');
  sDone = stone.side;
  
  if(sDone==sideH)
    if(~isempty(stone.position))
      p=stone.position;
      x=p(2);
      y=m+1-p(1);
      P=[labels{x}, num2str(y)];
      
      if sideH==1
        command=sprintf('play b %s',P);
      elseif sideH==2
        command=sprintf('play w %s',P);
      end
      
      fprintf('向引擎传送指令[%s]...\n',command);
      sendCommand(Engine,command);
      WaitForCommands(Engine);
      break
    end
  end
  
  pause(0.001);
end

end

function autoBlackMove(fig,p)
% 自动落子（用于让子棋）

ax = findobj(fig,'type','axes');
label=get(ax,'XTickLabel');
pp = [label{p(1)},num2str(p(2))];
FormalEvent=struct;
FormalEvent.IntersectionPoint=p;
CallbackSet.MoveStoneCallback(ax,FormalEvent,1);
Manager=get(fig,'UserData');
Engine=Manager.LEELAZERO.ENGINE;
sendCommand(Engine,sprintf('play b %s', pp));
WaitForCommands(Engine);

end

function initHandicapGame(fig)

Manager=get(fig,'UserData');
Handicap=Manager.LEELAZERO.HANDICAP;
Engine = Manager.LEELAZERO.ENGINE;

if(Handicap==0)
  return
end
switch Handicap
  case {2}
    p=[4,4;16,16];
  case {3}
    p=[4,4;16,16;4,16];
  case {4}
    p=[4,4;16,16;4,16;16,4];
  case {5}
    p=[4,4;16,16;4,16;16,4;10,10];
  case {6}
    p=[4,4;16,16;4,16;16,4;4,10;16,10];
  case {7}
    p=[4,4;16,16;4,16;16,4;4,10;16,10;10,10];
  case {8}
    p=[4,4;16,16;4,16;16,4;4,10;16,10;10,4;10,16];
  case {9}
    p=[4,4;16,16;4,16;16,4;4,10;16,10;10,4;10,16;10,10];
end
%KOMI=num2str(Handicap/2);
KOMI='0';

fprintf('让子棋修改贴目规则（贴%s目）...\n',char(KOMI));
message=sprintf('Komi %s',char(KOMI));
sendCommand(Engine,message);
WaitForCommands(Engine);

for i = 1:size(p,1)
  autoBlackMove(fig,p(i,:));
end

end