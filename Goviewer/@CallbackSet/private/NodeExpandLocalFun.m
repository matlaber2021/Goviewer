function NodeExpandLocalFun(node,option)
% 树节点展开算法

o = onCleanup(@() setappdata(node,'HasExpanded',1));
if(isa(node,'matlab.ui.container.Tree'))
  stone=node.UserData;
else
  stone=node.NodeData;
end

children=stone.children;
L=length(children);
if(L==0), return; end

if(L==1)
  stone1=stone;
  while(1)
      
      % 如果节点没有下一节点，退出循环
      if(isempty(stone1.children))
        break
      end
      
      % 优先找到第一个子节点，新建树节点
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
  
  % 找到可以循环的子节点，避免子节点重复生成
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

% 展开子节点
if(option)
  cnodes=node.Children;
  for i=1:length(cnodes)
    NodeExpandLocalFun(cnodes(i),0);
  end
end