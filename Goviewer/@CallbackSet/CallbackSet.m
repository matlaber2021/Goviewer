classdef CallbackSet < handle
  % Using this callback object to collect and manager all the Matlab [or
  % Java] callback functions.
  
  methods
    
    function obj = CallbackSet()
      
    end
    
  end
  
  % Buttons in the first toolbar
  methods(Static)
    OpenFileCallback(h,e);
    SaveFileCallback(h,e);
    NewBoardCallback(h,e);
    BlackModeCallback(h,e);
    WhiteModeCallback(h,e);
    DefaultModeCallback(h,e);
    PassCallback(h,e);
    RetractStoneCallback(h,e);
    ResignCallback(h,e);
  end
  
  % Buttons in the second toolbar
  methods(Static)
    SettingsCallback(h,e);
    RotateCallback(h,e);
    SwitchOrderCallback(h,e);
    StartCallback(h,e);
    BackwardCallback(h,e);
    ForwardCallback(h,e,i);
    StopCallback(h,e);

    AutoForwardCallback(h,e);
    ScanShotCallback(h,e);
    CommentCallback(h,e);
    TreeNodeCallback(h,e);
    LabelCallback(h,e);    
  end
  
  % Callbacks on the graphic objects on the board
  methods(Static)
    
    % the default move
    DefaultCallback(h,e);
    MoveStoneCallback(h,e,s);
    MoveNewStoneCallback(h,e,s);
    
    % add stone
    AddStoneCallback(h,e,s);
    WhiteAddCallback(h,e);
    BlackAddCallback(h,e);
    
    % add label
    AddLabelCallback(h,e);
    DeleteLabelCallback(h,e);
    
    % move number
    StoneOrderCallback(h,e,option);
    
    %RecordModeCallback(h,e,time);
    
    % engine
    SaveLeelazOptionsCallback(h,e);
    LeelazGameCallback(h,e);
    DeadStoneCallback(h,e,s);
    
  end
  
  % read or write comment
  methods(Static)
    CommentSyncCallback(h,e);
    CommentEditCallback(h,e);
    CommentClosedCallback(h,e);
    CommentValueChangedCallback(h,e);
  end
  
  % treenode callbacks
  methods(Static)
    StoneNodeExpandCallback(h,e,arg);
    StoneNodeSelectedCallback(h,e,arg);
    TreeClosedCallback(h,e);
    NodeRouteCallback(h,e);
    EditNodeNameCallback(h,e);
  end
  
end










