function updateStoneLabels(fig)
% Update the stone labels.

fontname='Arial';
fontsize=12;

fig=ancestor(fig,'figure');
delete(findobj(fig,'tag','label'));
ax=findobj(fig,'type','axes');
manager=get(fig,'UserData');
stone=manager.DATA.CURRENT_STONE;
M=manager.CONFIG.BOARDSIZE(1);
color=manager.CONFIG.BOARDCOLOR;
if(~isempty(stone.label))
  tokens=regexp(stone.label,'\[\s*?(\w\w):(.*?)\]','tokens');
  if(~isempty(tokens))
    data=vertcat(tokens{:});
    N=size(data,1);
    
    for i=1:N
      
      x=upper(data{i,1}(1))-64;
      y=M+1-(upper(data{i,1}(2))-64);
      text(ax,x,y,strtrim(data{i,2}),...
          'FontSize',fontsize,...
          'FontName',fontname,...
          'Color','#2ac67d',...
          'Tag','label',...
          'BackgroundColor',color,...
          'FontWeight','bold',...
          'HorizontalAlignment','center',...
          'VerticalAlignment','middle', ...
          'ButtonDownFcn',@CallbackSet.MoveStoneCallback);

    end
    
  end
  
end