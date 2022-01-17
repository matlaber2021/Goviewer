function updateTreeNode(fig)
% update the tree node from this figure
%
% WARN: This function can only be used for the forward operation and moving
% or adding new stones.

fig=ancestor(fig,'figure');
Manager=get(fig,'UserData');
stone=Manager.DATA.CURRENT_STONE;
if(~isfield(Manager.CONFIG,'SHOW_TREE'))
  Manager.CONFIG.SHOW_TREE=0;
end

if(~Manager.CONFIG.SHOW_TREE)
  return
end

ufig=Manager.WINDOW.TREE_WINDOW;
tree=findobj(ufig,'type','uitree');

node=tree.SelectedNodes;
if(isempty(node))
  return
elseif(~isequal(node.NodeData,stone.parent))
  fprintf(2,'The current stone and tree-node are not synchronized.\n');
else
  
  % get the next sibling node
  sibling=getNextSibling(node);
  if(~isempty(sibling))
    if(isequal(sibling.NodeData,stone))
      NeedToUpdate=0;
      FindChild=0;
    else
      FindChild=1;
    end
  else
    %FindChild=0;
    
    % Add the sibling node and quit from this function.
    node1=uitreenode(node.Parent);
    node1.NodeData=stone;
    stone.ShownInTreeNode=1;
    tree.SelectedNodes=node1;
    updateNodeInfo(node1);
    return
  end
  
  if(FindChild)
    if(~isempty(node.Children))
      child=node.Children(1);
      if(isequal(child.NodeData,stone))
        NeedToUpdate=0;
      else
        NeedToUpdate=1;
      end
    else
      NeedToUpdate=1;
    end
  end
  
  if(NeedToUpdate)
    node1=uitreenode(node);
    node1.NodeData=stone;
    %if(~stone.HasBeenPlayedOnBoard)
    %  SGFInfoSyncFun(stone,-1);
    %end
    stone.ShownInTreeNode=1;
    updateNodeInfo(node1);
    tree.SelectedNodes=node1;
    node.expand();
  else
    tree.SelectedNodes=sibling;
  end
  
end

function sibling=getNextSibling(node)

jnode=java(node);
sibling=handle(jnode.browseablePrevSibling());