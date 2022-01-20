function StoneNodeExpandCallback(h,e)
% tree node expanding callback
%
% StoneNodeExpandCallback(node); % expand the node
% StoneNodeExpandCallback(handle,event); % normal callback function

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

%setappdata(node,'expand',1);
NodeExpandLocalFun(node,1);

