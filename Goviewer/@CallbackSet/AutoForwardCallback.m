function AutoForwardCallback(h,e)
% Auto-replay callback function
%
% Hint:
% When the stone is playing, if the pausing seconds sets too low (less than
% 0.1 seconds, then the forward process feels too slow, so maybe after the
% auto-replay has done, we start to update the tree node if any.
%
% Actually if the pausing seconds is large enough (i.e. 1,2,...), then we
% can update tree node within the forward callback function.
%
% Performance
% The node expands widely (nodes > 3000), slow! So could we abandon the
% tree-node skip mode?

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
Manager.SKIP_TREENODE=1;

while strcmp(get(h,'State'),'on')
  CallbackSet.ForwardCallback(h,e);
  pause(0.2);
end
Manager.SKIP_TREENODE=0;
updateStoneNode(fig);

end