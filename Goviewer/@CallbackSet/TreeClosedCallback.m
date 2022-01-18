function TreeClosedCallback(h,e)%#ok
% Before closing the tree window, we clean up the ShownInTreeNode property
% of the all child of current root. And don't forget to delete all the
% containers in the uitree, make the TreeNode property value invalid.

fig=get(h,'UserData');
Manager=get(fig,'UserData');
Manager.CONFIG.SHOW_TREE=0;
stone=Manager.DATA.CURRENT_STONE;
stone=findAncestor(stone);
descendant=findall(stone);
if(~isempty(descendant))
  for idx=1:numel(descendant)
    descendant(idx).ShownInTreeNode=0;
  end
end

% BUGFIX
tree=findobj(fig,'type','uitree');
containers=findall(tree);
delete(containers);

delete(h);