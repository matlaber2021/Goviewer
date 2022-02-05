function updateStonePath(h)
% update the stone path if stone has many children, will show the child 
% stone's labels.

fig=ancestor(h,'figure');
ax=findobj(fig,'type','axes');
path=findobj(fig,'tag','path');
delete(path);
manager=get(fig,'UserData');
stone=manager.DATA.CURRENT_STONE;
state=manager.DATA.CURRENT_STATE;
[m,n]=size(state);%#ok
L=length(stone.children);
if(L==1), return; end

fontname='Arial';
fontsize=12;
idx=1;

for i=1:L
  NO_CALLBACK=0;
  HasPath=0;
  node=stone.children(i);
  if(~node.HasBeenPlayedOnBoard)
    SGFInfoSyncFun(node,-1);
  end
  
  if(node.status~=2)
    if(node.side==0)
      if(isempty(node.position))
        continue;
      end
    end
  end
  
  if(node.status==2)
    if(node.side>0)
      continue;
    end
  end
  
  if(node.status==1)
    if(~isempty(node.position))
      x=node.position(2);
      y=m+1-node.position(1);
      HasPath=1;
    end
  end
  
  if(node.status==0)
    continue;
  end
  
  % BUGFIX:
  if(node.status==2)
    if(node.side==0) % AE
      NO_CALLBACK=1;
      node0=node;
      while(1)
        
        nodes0=node0.children;
        
        if(length(nodes0)>1)
          HasPath=0;
          break
        end
        
        if(length(nodes0)==1)
          if(~nodes0.HasBeenPlayedOnBoard)
            SGFInfoSyncFun(nodes0,-1);
          end
          
          if(nodes0.status==1)
            if(nodes0.side>0)
              if(~isempty(nodes0.position))
                x=nodes0.position(2);
                y=m+1-nodes0.position(1);
              else
                x=[];
                y=[];
              end
              HasPath=1;
              break
            end
          end
          
          % If the child node is still AE, then continue while loop to find
          % out the path.
          if(nodes0.status==2)
            if(nodes0.side==0)
              node0=nodes0;
              HasPath=0;
              continue;
            end
          end
          
          if(nodes0.status==2)
            if(nodes0.side>0)
              HasPath=0;
              %break
              node0=nodes0;
              continue;
            end
          end
        end
        
        if(isempty(nodes0))
          HasPath=0;
          break
        end
        
      end
      
    end
  end
  
  if(HasPath)
    str=char(idx+64);
    if(state(m+1-y,x)==0)
      obj=text(ax,x,y,str,...
        'FontSize',fontsize,...
        'FontName',fontname,...
        'Color','b',...
        'Tag','path',...
        'FontWeight','bold',...
        'BackgroundColor',[249 214 91]/255,...
        'HorizontalAlignment','center',...
        'VerticalAlignment','middle');
      
      % BUGFIX
      if(~NO_CALLBACK)
        set(obj,'ButtonDownFcn',@CallbackSet.MoveStoneCallback);
      end
      
    end
    idx=idx+1;
  end
end

