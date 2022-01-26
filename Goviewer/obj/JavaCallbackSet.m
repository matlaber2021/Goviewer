classdef JavaCallbackSet < handle
  
  
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