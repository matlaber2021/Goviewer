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
    AddStoneCallback(h,e,s);
    DefaultCallback(h,e);
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
    ArrowCallback(h,e,option);
  end
  
  % Callbacks on the graphic objects on the board
  methods(Static)
    
    % the default move
    MoveStoneCallback(h,e,s);
    MoveNewStoneCallback(h,e,s);
    
    % add label
    AddLabelCallback(h,e);
    DeleteLabelCallback(h,e);
    
    % move number
    StoneOrderCallback(h,e,option);
    
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
  
  % Java
  methods(Static)
    function MouseWheelCallback(h,e)
      % Control back and forward move step by the mouse wheel.
      
      fig=getappdata(h,'Figure');
      if(isempty(fig)), return; end
      if(handle(e).getPreciseWheelRotation==-1)
        CallbackSet.BackwardCallback(fig,[]);
      elseif(handle(e).getPreciseWheelRotation==1)
        CallbackSet.ForwardCallback(fig,[]);
      end
      
    end
  end
  
end










