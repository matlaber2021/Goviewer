function StoneNodeExpandCallback(h,e,option)

% DEPTH=0,2,4,6,...
% DEPTH=1,3,5,7,...

if(nargin<3)
  option=1;
end

if(isa(h,'matlab.ui.container.Tree'))
  node=h.SelectedNodes;
  if(isempty(node))
    node=e.Node;
  end
else
  node=h;
end

if(~isempty(node.Children))
  cnodes=node.Children;
  for i=1:length(cnodes)
    StoneNodeExpandCallback(cnodes(i),[],0);
  end
  return
end

stone=node.NodeData;
children=stone.children;
L=length(children);

if(L==0), return; end

layer=0;
node0=node;
while(~isa(node0,'matlab.ui.container.Tree'))
  layer=layer+1;
  node0=node0.Parent;
end

if(rem(layer,2)==0)
  %node1=node;
  stone1=stone;
  while(1)
    node1=uitreenode(node);
    stone1=stone1.children(1);
    str=displaySGFInfo(stone1);
    node1.Text=str(1:min(length(str),10));
    node1.NodeData=stone1;
    if(isempty(stone1.children))
      break
    end
  end
elseif(rem(layer,2)==1)
  for idx=2:L
    node1=uitreenode(node);
    stone1=stone.children(idx);
    str=displaySGFInfo(stone1);
    node1.Text=str(1:min(length(str),10));
    node1.NodeData=stone1;
  end
end

if(option)
  cnodes=node.Children;
  for i=1:length(cnodes)
    StoneNodeExpandCallback(cnodes(i),[],0);
  end
end
    
