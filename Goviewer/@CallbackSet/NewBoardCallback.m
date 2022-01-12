function NewBoardCallback(h,e) %#ok
% 新建棋谱的回调函数

fig = ancestor(h,'figure');
ax = findobj(fig,'type','axes');

% To be safe, clean up the Engine object before initializing the Manager
% object self. In addition, delete all STONE objects.
Manager=get(fig,'UserData');
if isfield(Manager.DATA,'ENGINE')
  if isa(Manager.DATA.ENGINE, 'LeelaZero.EngineInterface')
    quitEngine(Manager.DATA.ENGINE);
  end
end

% Using deleteStone method to clear all the stone and their children.
ROOT=findAncestor(Manager.DATA.CURRENT_STONE);
deleteStone(ROOT);

% Reset the UserDataManager object
GoViewer.initUserDataManager(fig);

% Delete all the stones
hStones = findobj(ax,'tag','stone');
delete(hStones);

% Delete all the markers
marker = findobj(ax,'tag','marker','type','patch');
delete(marker);

% Delete all the move numbers
numbers=findobj(ax,'tag','order');
delete(numbers);

% Reactivate the callbacks on the board
GoViewer.initCallbackOnBoard(ax);

end