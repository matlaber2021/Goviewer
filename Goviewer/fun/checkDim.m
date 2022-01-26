function checkDim(fig)
% Dim means to grey out the given point. The dim property of the current
% Stone object is default as empty.

fig=ancestor(fig,'figure');
ax=findobj(fig,'type','axes');
delete(findobj(fig,'tag','dim'));
Manager=get(fig,'UserData');
state=Manager.DATA.CURRENT_STATE;
stone=Manager.DATA.CURRENT_STONE;
[m,n]=size(state); %#ok

if(~stone.HasBeenPlayedOnBoard)
  SGFInfoSyncFun(stone,-1);
end
if(isempty(stone.dim)), return; end

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
