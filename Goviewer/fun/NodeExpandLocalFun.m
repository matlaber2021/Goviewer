function NodeExpandLocalFun(node,option)
% Tree nodes expand algorithm, imitating from MultiGo style.
%
% WARN: Some tree-nodes are different from MultiGo, because some SGF
% information when parsing may be split into multi-nodes for ease of
% programing.

%o = onCleanup(@() setappdata(node,'HasExpanded',1));
if(isa(node,'matlab.ui.container.Tree'))
  stone=node.UserData;
else
  stone=node.NodeData;
end

if(nargin<2), option=1; end

children=stone.children;
L=length(children);
if(L==0), return; end

if(L==1)
  stone1=stone;
  while(1)
      
      % If the node has no children, quit from the while-loop.
      if(isempty(stone1.children))
        break
      end
      
      % Find the first node, then build a new tree node.
      stone1=stone1.children(1);
      if(~stone1.ShownInTreeNode)
        node1=uitreenode(node);
        %setappdata(node1,'HasExpanded',0);
        node1.NodeData=stone1;
        stone1.ShownInTreeNode=1;
        updateNodeInfo(node1);
      end
      
  end
  
end

if(L>1)
  
  % Find node which can expand, and be prevent from repeating generation as
  % well.
  children=stone.children;
  for i=length(children):-1:1
    if(children(i).ShownInTreeNode)
      children(i)=[];
    end
  end
  LL=length(children);
  
  for idx=1:LL
    stone1=children(idx);
    node1=uitreenode(node);
    %setappdata(node1,'HasExpanded',0);
    node1.NodeData=stone1;
    stone1.ShownInTreeNode=1;
    updateNodeInfo(node1);
  end
  
end

% expand the child nodes.
if(option)
  cnodes=node.Children;
  for i=1:length(cnodes)
    NodeExpandLocalFun(cnodes(i),0);
  end
end