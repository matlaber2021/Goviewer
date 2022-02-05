function DefaultCallback(h,e)
% the default callback on the graphic objects on the board
% [1] left click: move stone
% [2] right click: redo stone

fig=ancestor(h,'figure');
manager=get(fig,'UserData');
NEXTSIDE=manager.DATA.NEXTSIDE;
if(isempty(NEXTSIDE)), NEXTSIDE=1; end
  
%stone=manager.DATA.CURRENT_STONE;
%while(~isempty(stone))
%  if(stone.status==1)
%    break
%  end
%  stone=stone.parent;
%end

%if(isempty(stone))
%  NEXTSIDE=1;
%else
%  NEXTSIDE=stone.side-(-1)^(stone.side);
%end

iPoint = e.Button;
if iPoint==1      % left click
  CallbackSet.MoveStoneCallback(h,e,NEXTSIDE);
elseif iPoint==3  % right click
  CallbackSet.RetractStoneCallback(h,e);
end

end