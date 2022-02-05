function DefaultModeCallback(h,e) %#ok
% callback of move stone button

% reset the other buttons' state
resetToolButtonState(h);

fig=ancestor(h,'figure');
manager=get(fig,'UserData');
s=manager.DATA.NEXTSIDE;
manager.DATA.NEXTSIDE=s-(-1)^s;

obj=findall(findobj(fig,'type','axes'));
set(obj,'ButtonDownFcn', @CallbackSet.DefaultCallback);
