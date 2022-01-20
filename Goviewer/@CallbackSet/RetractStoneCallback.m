function RetractStoneCallback(h,e)
% 悔棋回调函数

fig = ancestor(h,'figure');
Manager = get(fig,'UserData');
origin = getPropValDATA(Manager,'CURRENT_STONE');
if isempty(origin.parent), return; end
if ~isempty(origin.children), return; end

% Using BackWardCallback function to do backward step.
BackWardCallback(h,e);

% The ko state has been unlocked, the ko does not exist.
setPropValDATA(Manager,'ISKOLOCKED',0);

% We must delete the original stone
origin.deleteStone();

end

