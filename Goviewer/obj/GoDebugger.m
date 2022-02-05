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
    
    function result=block_analysis()
      fig=gcf;
      Manager=get(fig,'UserData');
      state=Manager.DATA.CURRENT_STATE;
      result=block_analysis(state);
      
    end
    
    function varargout=territory_show()
      delete(findobj(gca,'tag','territory'));
      fig=gcf;
      Manager=get(fig,'UserData');
      state=Manager.DATA.CURRENT_STATE;
      
      result=influence_territory(state);
      territory=result.potential_territory;
      
      for i=1:19
        for j=1:19
          if(territory(i,j)==1)
            color='k';
          elseif(territory(i,j)==2)
            color='w';
          else
            color=[];
          end
          
          X=j;
          Y=20-i;
          x=[X-0.5;X-0.5;X+0.5;X+0.5;X-0.5];
          y=[Y+0.5;Y-0.5;Y-0.5;Y+0.5;Y+0.5];
          
          if(~isempty(color))
            patch(gca,'XData',x,'YData',y,'FaceColor',color,'FaceAlpha',0.3,...
              'EdgeColor','none','tag','territory');
          end
        end
      end
      
      if(nargout==1)
        varargout{1}=result;
      end
      
    end
    
  end
end