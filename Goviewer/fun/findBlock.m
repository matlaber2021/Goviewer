function out = findBlock(state,p)
% 找到某个点所在的块状区域

out = p;
p0 = p;
FLAG = state(p(1),p(2));
[m,n] = size(state);
out1 = findNextNestFcn(p);
out = [out; out1];

  function out = findNextNestFcn(p)
    out = NaN(0,2);
    out0 = NaN(0,2);
    x=p(1);
    y=p(2);
    if x-1>0
      if state(x-1,y)==FLAG
        out0 = [out0; [x-1,y] ];
      end
    end
    if x<m
      if state(x+1,y)==FLAG
        out0 = [out0; [x+1,y] ];
      end
    end
    if y-1>0
      if state(x,y-1)==FLAG
        out0 = [out0; [x,y-1] ];
      end
    end
    if y<n
      if state(x,y+1)==FLAG
        out0 = [out0; [x,y+1] ];
      end
    end
    
    out_loop = setdiff(out0,p0,'rows');
    if ~isempty(out_loop)
      out = [out; out_loop];
      L = size(out_loop,1);
      p0 = [p0; out_loop];
      for i = 1:L
        out_tmp = findNextNestFcn(out_loop(i,:));
        out = [out; out_tmp];
      end
    end
    
  end

end