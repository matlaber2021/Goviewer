function BlackMoveCallback(h,e) %#ok
% the callback function of moving black stone

% adjust the callback property of all the graphics on the board
fig=ancestor(h,'figure');
ax=findobj(fig,'type','axes');
children = findall(ax);

s = get(h,'state');
if strcmp(s,'off')
  set(children,'ButtonDownFcn', @CallbackSet.DefaultCallback);
elseif strcmp(s,'on')
  
  % reset the other tool button state
  resetToolButtonState(h);
  
  set(children,'ButtonDownFcn', @CallbackSet.BlackAddCallback);
end