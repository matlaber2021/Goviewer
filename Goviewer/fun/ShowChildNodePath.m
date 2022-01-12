function ShowChildNodePath(h)

fig=ancestor(h,'figure');
ax=findobj(fig,'type','axes');
path=findobj(fig,'tag','path');
delete(path);
Manager=get(fig,'UserData');
stone=Manager.DATA.CURRENT_STONE;
state=Manager.DATA.CURRENT_STATE;
[m,n]=size(state);%#ok
L=length(stone.children);
if(L==1), return; end
fontname='Arial';
fontsize=12;
idx=1;
for i=1:L
  node=stone.children(i);
  if(~node.HasBeenPlayedOnBoard)
    SGFInfoSyncFun(node,-1);
  end
  
  if(node.status~=2)
    if(isempty(node.position))
      continue;
    end
  end
  
  if(node.status==2)
    if(node.side>0)
      continue; 
    end
  end
  
  if(~isempty(node.position))
    x=node.position(2);
    y=m+1-node.position(1);
  end
  
  % BUGFIX: 路径嗅探程序
  if(node.status==2)
    if(node.side==0) % AE
      %PathAlongAENode=0;
      node0=node;
      while(1)
        nodes0=node0.children;
        if(length(nodes0)>1)
          break
        elseif(length(nodes0)==1)
          if(~nodes0.HasBeenPlayedOnBoard)
            SGFInfoSyncFun(nodes0,-1);
          end
          if(nodes0.status==1)
            if(nodes0.side>0)
              %PathAlongAENode=1;
              
              x=nodes0.position(2);
              y=m+1-nodes0.position(1);
              
              break
            end
          end
          if(nodes0.status==2)
            if(nodes0.side==0)
              node0=nodes0;
              continue;
            end
          end
          break
        elseif(isempty(nodes0))
          break
        end
      end
      
    end
  end
  
  str=char(idx+64);
  text(ax,x,y,str,...
    'FontSize',fontsize,...
    'FontName',fontname,...
    'Color','b',...
    'Tag','path',...
    'FontWeight','bold',...
    'BackgroundColor',[249 214 91]/255,...
    'HorizontalAlignment','center',...
    'VerticalAlignment','middle', ...
    'ButtonDownFcn',@CallbackSet.MoveStoneCallback);
  idx=idx+1;
end  
