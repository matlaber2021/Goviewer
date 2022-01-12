function DefaultModeCallback(h,e) %#ok
% 黑白轮流落子模式

% 重置其他按钮的状态属性
resetToolButtonState(h);

hList = findAllGobjects(h);

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
s=getPropValDATA(Manager,'NEXTSIDE');
setPropValDATA(Manager,'NEXTSIDE',s-(-1)^s);

set(hList,'ButtonDownFcn', @CallbackSet.DefaultCallback);

end