function StoneNodeExpandCallback(h,e,p)

% DEPTH=0,2,4,6,...
% DEPTH=1,3,5,7,...

% BUGFIX: Dealing with callbacks squeeze problem.
% ufig=ancestor(h,'figure');
% fig=get(ufig,'UserData');
% Manager=get(fig,'UserData');
% if(~isfield(Manager.CONFIG,'EXPANDING'))
%   Manager.CONFIG.EXPANDING=1;
%   %fprintf('Expanding...\n');
% elseif(Manager.CONFIG.EXPANDING==1)
%   return
% elseif(Manager.CONFIG.EXPANDING==0)
%   Manager.CONFIG.EXPANDING=1;
%   %fprintf('Expanding...\n');
% end
% o = onCleanup(@() setPropValCONFIG(Manager,'EXPANDING',0) );

if(isempty(e))
  if(isa(h,'matlab.ui.container.Tree'))
    node=h.SelectedNodes;
  else
    node=h;
  end
elseif(~isempty(e))
  if(isprop(e,'Node'))
    node=e.Node;
  elseif(isprop(e,'SelectedNodes')) % BUFIX
    node=e.SelectedNodes;
    %node=e.PreviousSelectedNodes;
  end
end

% if(isempty(getappdata(node,'HasExpanded')))
%   setappdata(node,'HasExpanded',0);
% end

% if(~getappdata(node,'HasExpanded'))
  NodeExpandLocalFun(node,1);
% end

% cnodes=node.Children;
% if(~isempty(cnodes))
%   for i=1:length(cnodes)
%     %if(~getappdata(cnodes(i),'HasExpanded'))
%       NodeExpandLocalFun(cnodes(i),1);
%     %end
%   end
% end
%fprintf('Done.\n');

% function NodeExpandLocalFun2(node,option)
% % 树节点展开算法
% 
% setappdata(node,'HasExpanded',1);
% stone=node.NodeData;
% children=stone.children;
% L=length(children);
% if(L==0), return; end
% 
% layer=0;
% node0=node;
% while(~isa(node0,'matlab.ui.container.Tree'))
%   layer=layer+1;
%   node0=node0.Parent;
% end
% 
% if(rem(layer,2)==0)
%   %node1=node;
%   stone1=stone;
%   while(1)
%     node1=uitreenode(node);
%     setappdata(node1,'HasExpanded',0);
%     stone1=stone1.children(1);
%     %str=displaySGFInfo(stone1);
%     %node1.Text=str(1:min(length(str),10));
%     node1.NodeData=stone1;
%     stone1.ShownInTreeNode=1;
%     updateNodeInfo(node1);
%     if(isempty(stone1.children))
%       break
%     end
%   end
% elseif(rem(layer,2)==1)
%   for idx=2:L % 2:L
%     stone1=stone.children(idx);
%     %if(~stone1.ShownInTreeNode)
%       node1=uitreenode(node);
%       setappdata(node1,'HasExpanded',0);
%       %str=displaySGFInfo(stone1);
%       %node1.Text=str(1:min(length(str),10));
%       node1.NodeData=stone1;
%       stone1.ShownInTreeNode=1;
%       updateNodeInfo(node1);
%     %end
%   end
% end
% 
% % 展开子节点
% if(option)
%   cnodes=node.Children;
%   for i=1:length(cnodes)
%     NodeExpandLocalFun(cnodes(i),0);
%   end
% end