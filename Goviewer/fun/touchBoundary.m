function [side,boundary] = touchBoundary(state,p)
% 触碰边界

x0=p(1);
y0=p(2);
[m,n]=size(state);
side=NaN([0,1]);
boundary=NaN([0,2]);

if state(x0,y0)~=0
  return
end

x1=x0;
y1=y0;
while 1
  if x1>1
    x1=x1-1;
    if state(x1,y1)~=0
      side(end+1,1)=state(x1,y1);
      boundary(end+1,:)=[x1,y1];
      break
    end
  else
    break
  end
end

x1=x0;
y1=y0;
while 1
  if x1<m
    x1=x1+1;
    if state(x1,y1)~=0
      side(end+1,1)=state(x1,y1);
      boundary(end+1,:)=[x1,y1];
      break
    end
  else
    break
  end
end

x1=x0;
y1=y0;
while 1
  if y1<n
    y1=y1+1;
    if state(x1,y1)~=0
      side(end+1,1)=state(x1,y1);
      boundary(end+1,:)=[x1,y1];
      break
    end
  else
    break
  end
end

x1=x0;
y1=y0;
while 1
  if y1>1
    y1=y1-1;
    if state(x1,y1)~=0
      side(end+1,1)=state(x1,y1);
      boundary(end+1,:)=[x1,y1];
      break
    end
  else
    break
  end
end