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
  Manager=get(fig,'UserData');
  stone1=Manager.DATA.CURRENT_STONE;
else
  fig=f;
  Manager=get(fig,'UserData');
  stone1=Manager.DATA.CURRENT_STONE;
  
  if(~isfield(Manager.CONFIG,'SHOW_TREE'))
    Manager.CONFIG.SHOW_TREE=0;
  end
  
  if(Manager.CONFIG.SHOW_TREE)
    ufig=Manager.WINDOW.TREE_WINDOW;
  else
    return
  end
  
end

if(Manager.SKIP_TREENODE), return; end

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
  stone=stone1;
  depth=0;
  index=[];
  while(1)
    depth=depth+1;
    [stone,nth]=getParent(stone);
    index(end+1)=nth; %#ok
    if(stone.ShownInTreeNode)
      node=stone.TreeNode;
      NodeExpandLocalFun(node);
      break
    end
  end
  
  stone=node.NodeData;
  for i=1:depth
    stone=stone.children(index(i));
    node=stone.TreeNode;
    NodeExpandLocalFun(node);
  end
  tree.SelectedNodes=node;
  scroll(tree,node);
  if(~isequal(node.NodeData,stone1))
    fprintf(2,'Debugging the node route bug.\n');
  end
  
end