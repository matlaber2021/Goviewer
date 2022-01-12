function WhiteMoveCallback(h,e)
% 白棋落子（与悔棋）回调函数

iPoint = e.Button;
if iPoint==1
  CallbackSet.AddStoneCallback(h,e,2);
elseif iPoint==3
  CallbackSet.RetractStoneCallback(h,e);
end

end