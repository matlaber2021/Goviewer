function BlackMoveCallback(h,e)
% 黑棋落子（与悔棋）回调函数

iPoint = e.Button;
if iPoint==1
  CallbackSet.AddStoneCallback(h,e,1);
elseif iPoint==3
  CallbackSet.RetractStoneCallback(h,e);
end

end