function [n,p0] = getLiberty(state,block)
% 计算一块棋的气

L = size(block,1);
p0 = NaN(0,2);
n = 0;
[M,N] = size(state);

for i = 1:L
  x=block(i,1);
  y=block(i,2);
  
  if x>1
    p = [x-1,y];
    if state(p(1),p(2))==0
      pNum = size(p0,1);
      FLAG = 1;
      for j = 1:pNum
        if x-1==p0(j,1) && y==p0(j,2)
          FLAG = 0;
          break
        end
      end
      if (FLAG)
        n=n+1;
        p0 = [p0; p];
      end
    end
  end
  
  if x<M
    p = [x+1,y];
    if state(p(1),p(2))==0
      pNum = size(p0,1);
      FLAG = 1;
      for j = 1:pNum
        if x+1==p0(j,1) && y==p0(j,2)
          FLAG = 0;
          break
        end
      end
      if (FLAG)
        n=n+1;
        p0 = [p0; p];
      end
    end
  end
  
  if y>1
    p = [x,y-1];
    if state(p(1),p(2))==0
      pNum = size(p0,1);
      FLAG = 1;
      for j = 1:pNum
        if x==p0(j,1) && y-1==p0(j,2)
          FLAG = 0;
          break
        end
      end
      if (FLAG)
        n=n+1;
        p0 = [p0; p];
      end
    end
  end
  
  if y<N
    p = [x,y+1];
    if state(p(1),p(2))==0
      pNum = size(p0,1);
      FLAG = 1;
      for j = 1:pNum
        if x==p0(j,1) && y+1==p0(j,2)
          FLAG = 0;
          break
        end
      end
      if (FLAG)
        n=n+1;
        p0 = [p0; p];
      end
    end
  end
  
end