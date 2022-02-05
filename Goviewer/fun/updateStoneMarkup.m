function updateStoneMarkup(fig)
% update the stone markups

fig=ancestor(fig,'figure');
deleteMarkups(fig);
ax=findobj(fig,'type','axes');
manager=get(fig,'UserData');
stone=manager.DATA.CURRENT_STONE;
m=manager.CONFIG.BOARDSIZE(1);
color=manager.CONFIG.BOARDCOLOR;
theta=manager.CONFIG.THETAFORCIRCLE;
fontname='Arial';
fontsize=12;

if(~stone.HasBeenPlayedOnBoard)
  SGFInfoSyncFun(stone,-1);
end

%%% Label %%%
if(~isempty(stone.label))
  tokens=regexp(stone.label,'\[\s*?(\w\w):(.*?)\]','tokens');
  if(~isempty(tokens))
    data=vertcat(tokens{:});
    N=size(data,1);
    for i=1:N
      x=upper(data{i,1}(1))-64;
      y=m+1-(upper(data{i,1}(2))-64);
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

%%% Dim points %%%
if(~isempty(stone.dim))
  P=regexprep(stone.dim,'\s','');
  match=regexp(P,'\[[\w|:]*?\]','match');
  pos=[];
  for jj=1:length(match)
    if(~contains(match{jj},':'))
      pos(end+1,:)=match{jj}(end-1:-1:2)-96; %#ok
    else
      for k=(match{jj}(2)-96):(match{jj}(5)-96)
        for l=(match{jj}(3)-96):(match{jj}(6)-96)
          pos(end+1,:)=[l,k]; %#ok
        end
      end
    end
  end
  
  for idx=1:size(pos,1)
    X=pos(idx,2);
    Y=m+1-pos(idx,1);
    x=[X-0.5;X-0.5;X+0.5;X+0.5;X-0.5];
    y=[Y-0.5;Y+0.5;Y+0.5;Y-0.5;Y-0.5];
    patch('Parent',ax,'XData',x,'YData',y,'EdgeColor','none',...
      'FaceColor','k','FaceAlpha',0.2,'Tag','dim');
  end
end

%%% Triangles %%%
r=0.2;
if(~isempty(stone.triangle))
  P=regexprep(stone.triangle,'\s','');
  match=regexp(P,'\[[\w|:]*?\]','match');
  pos=[];
  for jj=1:length(match)
    if(~contains(match{jj},':'))
      pos(end+1,:)=match{jj}(end-1:-1:2)-96; %#ok
    else
      for k=(match{jj}(2)-96):(match{jj}(5)-96)
        for l=(match{jj}(3)-96):(match{jj}(6)-96)
          pos(end+1,:)=[l,k]; %#ok
        end
      end
    end
  end
  
  for idx=1:size(pos,1)
    X=pos(idx,2);
    Y=m+1-pos(idx,1);
    x=[X;X-r*sin(pi/3);X+r*sin(pi/3);X];
    y=[Y+r;Y-r*cos(pi/3);Y-r*cos(pi/3);Y+r];
    patch('Parent',ax,'XData',x,'YData',y,'EdgeColor','none',...
      'FaceColor','#2ac67d','FaceAlpha',1,'Tag','triangle');
  end
end

%%% circle %%%
r=0.15;
if(~isempty(stone.circle))
  P=regexprep(stone.circle,'\s','');
  match=regexp(P,'\[[\w|:]*?\]','match');
  pos=[];
  for jj=1:length(match)
    if(~contains(match{jj},':'))
      pos(end+1,:)=match{jj}(end-1:-1:2)-96; %#ok
    else
      for k=(match{jj}(2)-96):(match{jj}(5)-96)
        for l=(match{jj}(3)-96):(match{jj}(6)-96)
          pos(end+1,:)=[l,k]; %#ok
        end
      end
    end
  end
  
  for idx=1:size(pos,1)
    X=pos(idx,2);
    Y=m+1-pos(idx,1);
    x=X+r*cos(theta);
    y=Y+r*sin(theta);
    patch('Parent',ax,'XData',x,'YData',y,'EdgeColor','#2ac67d',...
      'FaceColor','none','EdgeAlpha',1,'Tag','circle','LineWidth',2);
  end
end

%%% Square %%%
a=0.3;
if(~isempty(stone.square))
  P=regexprep(stone.square,'\s','');
  match=regexp(P,'\[[\w|:]*?\]','match');
  pos=[];
  for jj=1:length(match)
    if(~contains(match{jj},':'))
      pos(end+1,:)=match{jj}(end-1:-1:2)-96; %#ok
    else
      for k=(match{jj}(2)-96):(match{jj}(5)-96)
        for l=(match{jj}(3)-96):(match{jj}(6)-96)
          pos(end+1,:)=[l,k]; %#ok
        end
      end
    end
  end
  
  for idx=1:size(pos,1)
    X=pos(idx,2);
    Y=m+1-pos(idx,1);
    x=[X-a/2;X-a/2;X+a/2;X+a/2;X-a/2];
    y=[Y+a/2;Y-a/2;Y-a/2;Y+a/2;Y+a/2];
    patch('Parent',ax,'XData',x,'YData',y,'EdgeColor','none',...
      'FaceColor','#2ac67d','FaceAlpha',1,'Tag','square');
  end
end

%%% Mark %%%
if(~isempty(stone.mark))
  P=regexprep(stone.mark,'\s','');
  match=regexp(P,'\[[\w|:]*?\]','match');
  pos=[];
  for jj=1:length(match)
    if(~contains(match{jj},':'))
      pos(end+1,:)=match{jj}(end-1:-1:2)-96; %#ok
    else
      for k=(match{jj}(2)-96):(match{jj}(5)-96)
        for l=(match{jj}(3)-96):(match{jj}(6)-96)
          pos(end+1,:)=[l,k]; %#ok
        end
      end
    end
  end
  
  for idx=1:size(pos,1)
    X=pos(idx,2);
    Y=m+1-pos(idx,1);
    text(ax,X,Y,'X',...
      'FontSize',8,...
      'FontName',fontname,...
      'Color','#2ac67d',...
      'Tag','label',...
      'BackgroundColor','none',...
      'FontWeight','bold',...
      'HorizontalAlignment','center',...
      'VerticalAlignment','middle');
  end
end

%%% Selected points %%%
a=0.3;
if(~isempty(stone.selected))
  P=regexprep(stone.selected,'\s','');
  match=regexp(P,'\[[\w|:]*?\]','match');
  pos=[];
  for jj=1:length(match)
    if(~contains(match{jj},':'))
      pos(end+1,:)=match{jj}(end-1:-1:2)-96; %#ok
    else
      for k=(match{jj}(2)-96):(match{jj}(5)-96)
        for l=(match{jj}(3)-96):(match{jj}(6)-96)
          pos(end+1,:)=[l,k]; %#ok
        end
      end
    end
  end
  
  for idx=1:size(pos,1)
    X=pos(idx,2);
    Y=m+1-pos(idx,1);
    x=[X-a/2;X-a/2;X+a/2;X+a/2;X-a/2];
    y=[Y+a/2;Y-a/2;Y-a/2;Y+a/2;Y+a/2];
    patch('Parent',ax,'XData',x,'YData',y,'EdgeColor','#2ac67d',...
      'FaceColor','none','EdgeAlpha',1,'Tag','selected','LineWidth',2);
  end
end

%%% arrows %%%
headlength=0.3;
if(~isempty(stone.arrow))
  P=regexprep(stone.arrow,'\s','');
  match=regexp(P,'\[[\w|:]*?\]','match');
  pos=[];
  for jj=1:length(match)
    if(contains(match{jj},':'))
      pos(end+1,:)= match{jj}(2:3)-96; %#ok
      pos(end+1,:)= match{jj}(5:6)-96; %#ok
    end
  end
  
  for idx=1:2:size(pos,1)
    X=[pos(idx,1);pos(idx+1,1)];
    Y=[m+1-pos(idx,2);m+1-pos(idx+1,2)];
    arrow(ax,X,Y,headlength);
  end
end

%%% lines %%%
if(~isempty(stone.line))
  P=regexprep(stone.line,'\s','');
  match=regexp(P,'\[[\w|:]*?\]','match');
  pos=[];
  for jj=1:length(match)
    if(contains(match{jj},':'))
      pos(end+1,:)= match{jj}(2:3)-96; %#ok
      pos(end+1,:)= match{jj}(5:6)-96; %#ok
    end
  end
  
  for idx=1:2:size(pos,1)
    X=[pos(idx,1);pos(idx+1,1)];
    Y=[m+1-pos(idx,2);m+1-pos(idx+1,2)];
    line(ax,'XData',X,'YData',Y,'LineWidth',2,'Color','m','tag','line');
  end
end

%%% Black Territory %%%
if(~isempty(stone.territory_black))
  P=regexprep(stone.territory_black,'\s','');
  match=regexp(P,'\[[\w|:]*?\]','match');
  pos=[];
  for jj=1:length(match)
    if(~contains(match{jj},':'))
      pos(end+1,:)=match{jj}(end-1:-1:2)-96; %#ok
    else
      for k=(match{jj}(2)-96):(match{jj}(5)-96)
        for l=(match{jj}(3)-96):(match{jj}(6)-96)
          pos(end+1,:)=[l,k]; %#ok
        end
      end
    end
  end
  
  for idx=1:size(pos,1)
    X=pos(idx,2);
    Y=m+1-pos(idx,1);
    text(ax,X,Y,'X',...
      'FontSize',8,...
      'FontName',fontname,...
      'Color','k',...
      'Tag','territory',...
      'BackgroundColor','none',...
      'FontWeight','bold',...
      'HorizontalAlignment','center',...
      'VerticalAlignment','middle');
  end
end

%%% White Territory %%%
if(~isempty(stone.territory_white))
  P=regexprep(stone.territory_white,'\s','');
  match=regexp(P,'\[[\w|:]*?\]','match');
  pos=[];
  for jj=1:length(match)
    if(~contains(match{jj},':'))
      pos(end+1,:)=match{jj}(end-1:-1:2)-96; %#ok
    else
      for k=(match{jj}(2)-96):(match{jj}(5)-96)
        for l=(match{jj}(3)-96):(match{jj}(6)-96)
          pos(end+1,:)=[l,k]; %#ok
        end
      end
    end
  end
  
  for idx=1:size(pos,1)
    X=pos(idx,2);
    Y=m+1-pos(idx,1);
    text(ax,X,Y,'X',...
      'FontSize',8,...
      'FontName',fontname,...
      'Color','w',...
      'Tag','territory',...
      'BackgroundColor','none',...
      'FontWeight','bold',...
      'HorizontalAlignment','center',...
      'VerticalAlignment','middle');
  end
end


function deleteMarkups(fig)

delete(findobj(fig,'Tag','label'));
delete(findobj(fig,'Tag','triangle'));
delete(findobj(fig,'Tag','circle'));
delete(findobj(fig,'Tag','square'));
delete(findobj(fig,'Tag','selected'));
delete(findobj(fig,'Tag','mark'));
delete(findobj(fig,'Tag','arrow'));
delete(findobj(fig,'Tag','line'));
delete(findobj(fig,'Tag','dim'));
delete(findobj(fig,'Tag','territory'));