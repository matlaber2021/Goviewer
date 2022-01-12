function result = surroundedBy(state,block)
% 判断空白区域被谁包围以及包围区域


result = struct();
result.isSurrounded = 0;
result.surroundedBy = [];


B = block;
for i = 1:size(B,1)
  [side,~] = touchBoundary(state,B(i,:));
  if all(side==1)
    S=1;
  elseif all(side==2)
    S=2;
  else
    result.isSurrounded = 0;
    result.surroundedBy = [];
    return
  end
  if i == 1
    S0=S;
  elseif i>1
    if S~=S0
      result.isSurrounded = 0;
      result.surroundedBy = [];
      return
    end
  end
end

result.isSurrounded = 1;
result.surroundedBy = S0;




