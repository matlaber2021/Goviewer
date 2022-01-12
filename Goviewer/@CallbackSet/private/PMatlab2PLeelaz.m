function out = PMatlab2PLeelaz(in)
% 将Matlab矩阵的索引坐标转成将Leelaz引擎的坐标

CordChars19 = 'ABCDEFGHJKLMNOPQRST';
CordChars21 = 'ABCDEFGHJKLMNOPQRSTUV'; %#ok
CordChars09 = 'ABCDEFGHJ';             %#ok
CordChars13 = 'ABCDEFGHJKLMNO';        %#ok

row=in(1);
col=in(2);
m=19;
n=19; %#ok
x=m+1-col;
y=row;
out = [CordChars19(x),num2str(y)];

end