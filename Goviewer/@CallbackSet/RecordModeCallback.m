function RecordModeCallback(h,e,time) %#ok
% 打谱模式回调函数

flag = 1;
while flag
  flag = CallbackSet.ForwardCallback(h);
  pause(time);
end

end