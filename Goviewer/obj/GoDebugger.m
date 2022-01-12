classdef GoDebugger < handle
  
  methods(Static)
    function CheckBoardState(fig)
      
      Manager=get(fig,'UserData');
      state0=Manager.DATA.CURRENT_STATE;
      state1=zeros([19,19]);
      h=findobj(fig,'tag','stone','FaceColor','w');
      p=get(h,'UserData');
      if(~isempty(p))
        if isnumeric(p)
          p{1}=p;
        end
      end
      for i=1:length(p)
        x=p{i}(1);
        y=p{i}(2);
        state1(x,y)=2;
      end
      h=findobj(fig,'tag','stone','FaceColor','k');
      p=get(h,'UserData');
      if(~isempty(p))
        if isnumeric(p)
          pp{1}=p;
          p=pp;
        end
      end
      for i=1:length(p)
        x=p{i}(1);
        y=p{i}(2);
        state1(x,y)=1;
      end
      
      if(~isequal(state0,state1))
        error('棋盘状态与显示不同步.');
      end
      
    end
  end
  
  
end