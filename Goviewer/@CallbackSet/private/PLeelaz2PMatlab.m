function out = PLeelaz2PMatlab(in)
% 将Leelaz引擎的坐标转成Matlab矩阵的索引坐标

CordChars19 = 'ABCDEFGHJKLMNOPQRST';
CordChars21 = 'ABCDEFGHJKLMNOPQRSTUV'; %#ok
CordChars09 = 'ABCDEFGHJ';             %#ok
CordChars13 = 'ABCDEFGHJKLMNO';        %#ok

m=19;
n=19; %#ok
x=find(CordChars19==in(1));
y=str2double(in(2:end));
row = m+1-y;
col = x;
out = [row,col];


end