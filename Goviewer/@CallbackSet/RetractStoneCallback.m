function RetractStoneCallback(h,e)
% when taking back a move, it would trigger this callback function.

fig = ancestor(h,'figure');
manager = get(fig,'UserData');
origin = manager.DATA.CURRENT_STONE;
if isempty(origin.parent), return; end
if ~isempty(origin.children), return; end

% Using BackWardCallback function to do backward step.
CallbackSet.BackwardCallback(h,e);

% The ko state has been unlocked, the ko does not exist.
setPropValDATA(manager,'ISKOLOCKED',0);

% We must delete the original stone
origin.deleteStone();

% BUGFIX
% Although stone hints will show after calling BackwardCallback, the hints 
% may incorrect, thus show hints again. 
updateStonePath(fig);

end

