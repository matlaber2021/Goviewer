function TreeNodeCallback(h,e) %#ok
% Tree-Chart callback, establish the new but only one tree node chart.
%

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');

if(~isfield(Manager.CONFIG,'SHOW_TREE'))
  Manager.CONFIG.SHOW_TREE=0;
end

if(Manager.CONFIG.SHOW_TREE)
  return
elseif(~Manager.CONFIG.SHOW_TREE)
  Manager.CONFIG.SHOW_TREE=1;
  GoViewer.CreateTreeWindow(fig);
  updateStoneNode(fig);
end
