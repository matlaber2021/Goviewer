function BlackAddCallback(h,e)
% callback function of the added black stone button.

iPoint = e.Button;
if iPoint==1
  CallbackSet.AddStoneCallback(h,e,1);
elseif iPoint==3
  CallbackSet.RetractStoneCallback(h,e);
end

end