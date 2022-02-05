function updateStoneNode(h)
% Refresh the current node, if the current stone has no tree node,
% expanding and setting up from the beginning stone.
%
% The function can used at any time after the current stone data has been
% generated. Nevertheless when the tree-node skip status is false, the
% function does not work.
%
% After the function finished, the selected node will changed to the new
% node and it will scroll to the position of the target node. Make sure
% that the NodeData property value of the target node is equal to the
% current stone.

f=ancestor(h,'figure');
if(strcmp(f.Name,'Stone Tree'))
  ufig=f;
  fig=get(ufig,'UserData');
  manager=get(fig,'UserData');
  stone1=manager.DATA.CURRENT_STONE;
else
  fig=f;
  manager=get(fig,'UserData');
  stone1=manager.DATA.CURRENT_STONE;
  
  if(~isfield(manager.CONFIG,'SHOW_TREE'))
    manager.CONFIG.SHOW_TREE=0;
  end
  
  if(manager.CONFIG.SHOW_TREE)
    ufig=manager.WINDOW.TREE_WINDOW;
  else
    return
  end
  
end

if(manager.SKIP_TREENODE), return; end

tree=findobj(ufig,'type','uitree');
if(isempty(tree)), return; end

% if(isempty(tree.SelectedNodes))
%   node0=tree;
%   stone0=tree.UserData;
% else
%   node0=tree.SelectedNodes;
%   stone0=tree.NodeData;
% end

if(stone1.ShownInTreeNode)
  node=stone1.TreeNode;
  NodeExpandLocalFun(node);
  tree.SelectedNodes=node;
  scroll(tree,node);
  while(1)
    node.expand();
    node=node.Parent;
    if(isempty(node))
      break
    end
    
    % BUGFIX: When the node is the root node, skip out.
    if(isa(node,'matlab.ui.Figure'))
      break
    end
  end
  
elseif(~stone1.ShownInTreeNode)
  
  % BUGFIX
  %
  % If the stone has no node, need to establish a new tree node. We assume
  % that the parent stone must have node. If the stone is the first child,
  % then add the sibling stone. If the stone is not the first child, add
  % the new treenode from the parent node. But MultiGo seems not that.
  %
  % Looking to the origin node, if the origin node's layer, if the layer is
  % odd number, turn to case 1, but if even, then turn to case 2.
  %
  % Case 1
  % If the first child, then build a new sibling node.
  % If not the first, add a child node from the parent node.
  %
  % Case 2
  % Add a child node directly from the parent node.
  %
  % Warning:
  % In the preorder-traversal mode, parent node still exists.
  %
  % TODO
  % Maybe we could consider more general case, the pnode doesn't exist, we
  % can go back to the original stone with node. And layer unfolding.
  
  if(isempty(stone1.parent))
    tree.SelectedNodes=[];
    return
  end
  
  
  stone=stone1;
  index=[];
  while(1)
    [stone,index(end+1)]=getParent(stone); %#ok
    if(stone.ShownInTreeNode)
      break
    end
  end
  index=index(end:-1:1);
  
  node=stone.TreeNode;
  NodeExpandLocalFun(node.Parent);
  node.Parent.expand();
  NodeExpandLocalFun(node);
  node.expand();
  
  for i=1:length(index)
    idx=index(i);
    stone=stone.children(idx);
    node=stone.TreeNode;
    NodeExpandLocalFun(node);
    node.expand();
  end
  
  tree.SelectedNodes=stone1.TreeNode;
  scroll(tree,stone1.TreeNode);
  
end