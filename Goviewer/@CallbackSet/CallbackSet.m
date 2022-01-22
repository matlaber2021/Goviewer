classdef CallbackSet < handle
  % 该对象用来收集并管理所有的回调函数
  %
  % Properties
  % [1] CURRENT_CALLBACK_FCN
  %
  % Static Methods
  % [1] DefaultCallback         默认模式下的回调函数，用于图形对象的回调
  % [2] BlackMoveCallback       黑棋落子下的回调函数，即只能黑棋落子
  % [3] WhiteMoveCallback       白棋落子的回调函数
  % [4] BlackPassCallback       黑棋脱先的回调函数，不用于图形对象的回调
  % [5] WhitePassCallback       白棋脱先的回调函数，不用于图形对象的回调
  % [6] MoveStoneCallback       顺序落子模式或自定义落子模式
  % [7] RotateCallback          棋盘旋转的回调模式，单次逆时针旋转90度
  % [8] ForwardCallback         前进的回调函数，不改变落子数据的记录
  % [9] BackwardCallback        后退的回调函数
  % [10] RecordCallback         自动打谱的回调函数，用户需自定义选择打谱的频率
  % [11] BMoveModeCallback      黑棋模式切换，用于工具栏图标的回调
  % [12] WMoveModeCallback      白棋模式切换，用于工具栏图标的回调
  %
  
  methods
    
    function obj = CallbackSet()
      
    end
    
  end
  
  methods(Static)
    FileImportCallback(h,e);
    SaveFileCallback(h,e);
    DefaultModeCallback(h,e);
    DefaultCallback(h,e);
    BlackAddCallback(h,e);
    WhiteAddCallback(h,e);
    BlackPassCallback(h,e);
    WhitePassCallback(h,e);
    RotateCallback(h,e);
    RecordModeCallback(h,e,time);
    WhiteModeCallback(h,e);
    BlackModeCallback(h,e);
    SwitchOrderCallback(h,e);
    ResignCallback(h,e);
    AutoForwardCallback(h,e);
    NewBoardCallback(h,e);
    ScanShotCallback(h,e);
    StopCallback(h,e);
    LabelCallback(h,e);
    
  end
  
  methods(Static)
    AddStoneCallback(h,e,s);
    status = MoveNewStoneCallback(h,e,s);
    status = MoveStoneCallback(h,e,s);
    flag   = ForwardCallback(h,e,i);
    flag   = BackwardCallback(h,e);
    RetractStoneCallback(h,e);
    DeadStoneCallback(h,e,s);
    StoneOrderCallback(h,e,option);
    SaveLeelazOptionsCallback(h,e);
    LeelazGameCallback(h,e);
    AddLabelCallback(h,e);
    DeleteLabelCallback(h,e);
    
  end
  
  methods(Static) % listener callbacks
    CommentCallback(h,e);
    CommentSyncCallback(h,e);
    CommentEditCallback(h,e);
    CommentClosedCallback(h,e);
  end
  
  methods(Static)
    TreeNodeCallback(h,e);
    StoneNodeExpandCallback(h,e,arg);
    StoneNodeSelectedCallback(h,e,arg);
    TreeClosedCallback(h,e);
    NodeRouteCallback(h,e);
  end
  
end










