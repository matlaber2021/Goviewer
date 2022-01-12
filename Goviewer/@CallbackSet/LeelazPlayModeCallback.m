function LeelazPlayModeCallback(h,e)
%Leela引擎对弈模式的回调函数
%

% 新建棋盘
NewBoardCallback(h,e);

% 清除里拉对弈的Timer
ClearTimerObjects('TimerLeelazMove');

hList = findAllGobjects(h);
CleanUp = onCleanup(@() ...
  set(hList, 'ButtonDownFcn', @DefaultCallback) );

% 打开里拉引擎对弈设置弹窗
fig = ancestor(h,'figure');
ax = findobj(fig,'type','axes');
GoViewer.CreateLeelazOptionsWindow(fig);

% 直到弹窗中参数设置完毕后跳出循环
while (1)
  USERDATA = get(ax,'UserData');
  if isfield(USERDATA,'LEELAZ_OPTION')
    LEELAZ_OPTION = USERDATA.LEELAZ_OPTION;
    if LEELAZ_OPTION.OPTIONSET
      break
    end
  end
end

% 中国让子棋的贴目规则
% 比如让5子，黑棋按照贴2.5目对局
if LEELAZ_OPTION.HANDICAP > 0
  isHandicapGame = 1;
  LEELAZ_OPTION.KOMI = LEELAZ_OPTION.HANDICAP/2;
elseif LEELAZ_OPTION.HANDICAP == 0
  isHandicapGame = 0;
end

if USERDATA.LEELAZ_OPTION.LEELAZ_SIDE == 1
  sLeelaz_Engine = 'Black';
  sHuman_Engine = 'White';
elseif USERDATA.LEELAZ_OPTION.LEELAZ_SIDE == 2
  sLeelaz_Engine = 'White';
  sHuman_Engine = 'Black';
end

sendCommand(EngineObj, sprintf('komi %d', LEELAZ_OPTION.KOMI));
getCommand(EngineObj);

% 打开里拉引擎
EngineObj = LeelazEngineInterface(0);

if ~isHandicapGame
  % 赋予初始命令
  InitializeEngine(EngineObj);
  
else % 让子棋模式
  
  % TODO...
  InitializeEngine(EngineObj);
  
  switch LEELAZ_OPTION.HANDICAP
    
    case {2}
      
      % 向里拉传输指令
      sendCommand(EngineObj,'play b Q16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D4');
      getCommand(EngineObj);
      
      
      xy = PLeelaz2PMatlab('Q16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
    case {3}
      
      sendCommand(EngineObj,'play b Q16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D16');
      getCommand(EngineObj);
      
      
      xy = PLeelaz2PMatlab('Q16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
    case {4}
      
      sendCommand(EngineObj,'play b Q16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b Q4');
      getCommand(EngineObj);
      
      xy = PLeelaz2PMatlab('Q16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('Q4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
    case {5}
      
      sendCommand(EngineObj,'play b Q16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b Q4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b K10');
      getCommand(EngineObj);
      
      xy = PLeelaz2PMatlab('Q16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('Q4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('K10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
    case {6}
      sendCommand(EngineObj,'play b Q16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b Q4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D10');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b Q10');
      getCommand(EngineObj);
      
      xy = PLeelaz2PMatlab('Q16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('Q4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('Q10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
    case {7}
      sendCommand(EngineObj,'play b Q16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b Q4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D10');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b Q10');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b K10');
      getCommand(EngineObj);
      
      xy = PLeelaz2PMatlab('Q16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('Q4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('Q10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('K10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
    case {8}
      sendCommand(EngineObj,'play b Q16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b Q4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D10');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b Q10');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b K4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b K16');
      getCommand(EngineObj);
      
      xy = PLeelaz2PMatlab('Q16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('Q4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('Q10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('K4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('K16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
    case {9}
      sendCommand(EngineObj,'play b Q16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b Q4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b D10');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b Q10');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b K4');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b K16');
      getCommand(EngineObj);
      
      sendCommand(EngineObj,'play b K10');
      getCommand(EngineObj);
      
      xy = PLeelaz2PMatlab('Q16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('Q4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('D10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('Q10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('K4');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('K16');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
      xy = PLeelaz2PMatlab('K10');
      x = xy(2);
      y = 19+1-xy(1);
      FormalEvent.IntersectionPoint = [x,y,0];
      CallbackSet.MoveStoneCallback(h,FormalEvent,1);
      
    otherwise
      error('让子棋参数只能设置为2,3,4,5,6,7,8,9.')
  end
  
end

% 里拉对弈定时器
TimerLeelaz = timer(...
  'BusyMode'        ,'queue',...
  'ExcecutionMode'  ,'fixRate',...
  'ObjectVisibility','on',...
  'Period'          ,0.002,...
  'StartDelay'      ,0, ...
  'Tag'             ,'TimerLeelazMove', ...
  'TasksToExecute'  ,Inf,...
  'TimerFcn'        ,@LeelazPlayCallback);



HasLeelazMoved = 0;
HasHumanMoved  = 0;

start(TimerLeelaz);

  function LeelazPlayCallback(h,e) %#ok
    % 里拉判断并且落子的回调程序
    
    isLeelazResign = 0;
    
    % 如果人类还没有落子
    if ~HasHumanMoved
      return
    end
    
    % 向引擎发生落子指令
    cmd = sprintf('genmove %s', sLeelaz_Engine);
    sendCommand(EngineObj,cmd);
    
    % 引擎给出反馈
    msg = getCommand(EngingObj,'timeout',10);
    
    % 提取里拉的落子位置信息
    pLeelazToMove = regexp(msg,'\s([A-T]\d{1,2})\s','tokens');
    if isempty(pLeelazToMove)
      pLeelazToMove = [];
    elseif ~isempty(pLeelazToMove)
      pLeelazToMove = pLeelazToMove{1}{1};
      pLeelazToMove = PLeelaz2PMatlab(pLeelazToMove);
    end
    
    % 判断里拉是否决定认输
    % TODO...
    
    if isLeelazResign
      GameResult.Loser = 'Leelaz'; %#ok
      GameResult.Winner = 'Human';
      stop(TimerLeelaz);
      set(TimerLeelaz,'UserData',GameResult);
      return
    end
    
    % 执行落子程序（调用落子回调函数）
    FormalEvent = struct();
    FormalEvent.IntersectionPoint = pLeelazToMove;
    MoveStoneCallback(ax,FormalEvent);
    
    HasLeelazMoved = 1;
    HasHumanMoved  = 0;
    
  end

  function HumanPlayCallback(h,e) %#ok
    % 人类落子的回调程序
    
    % 执行落子程序
    
    if HasLeelazMoved
      
      RealEvent = e;
      status = MoveStoneCallback(ax,RealEvent);
      
      if status
        pHumanToMove = PMatlab2PLeelaz(e.IntersectionPoint);
        cmd = sprintf('play %s %s', sHuman_Engine, pHumanToMove);
        
        sendCommand(EngingObj,cmd);
        o = onCleanup(@() getCommand(EngineObj) );
        
        HasLeelazMoved = 0;
        HasHumanMoved  = 1;
      end
    end
    
  end

end

function ResignModeCallback(h,e) %#ok
% 认输回调函数

TimerLeelaz = timerfind('tag','TimerLeelazMove');
if ~isempty(TimerLeelaz)
  Running = get(TimerLeelaz,'Running');
  if strcmp(Running,'on')
    GameResult.Winner = 'Leelaz';
    GameResult.Loser  = 'Human';
    set(TimerLeelaz,'UserData',GameResult);
  end
end

end
