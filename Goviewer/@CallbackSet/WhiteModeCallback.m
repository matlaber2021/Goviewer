function WMoveModeCallback(h,e) %#ok
% 白棋落子模式回调函数

% 调整棋盘图形对象的回调函数属性
hList = findAllGobjects(h);

s = get(h,'state');
if strcmp(s,'off')
  
  o = onCleanup(@() ...
    set(hList,'ButtonDownFcn', @CallbackSet.DefaultCallback) );
elseif strcmp(s,'on')
  
  % 重置其他按钮的状态属性
  resetToolButtonState(h);
  
  o = onCleanup(@() ...
    set(hList,'ButtonDownFcn', @CallbackSet.WhiteAddCallback) );
end

end