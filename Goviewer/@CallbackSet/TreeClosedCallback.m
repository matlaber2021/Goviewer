function TreeClosedCallback(h,e)%#ok
% 树图回调函数

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

delete(h);