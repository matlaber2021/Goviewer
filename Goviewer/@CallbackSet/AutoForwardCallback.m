function AutoForwardCallback(h,e)
% 自动进行的回调函数

while strcmp(get(h,'State'),'on')
  CallbackSet.ForwardCallback(h,e);
  pause(0.01);
end

end

