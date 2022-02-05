function NewBoardCallback(h,e) %#ok
% new board callback

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

% Delete all the graphic objects on the board
delete(allchild(ax));

% Reactivate the callbacks on the board
ax = GoViewer.DrawComponentsOnBoard(fig);
GoViewer.initCallbackOnBoard(ax);
