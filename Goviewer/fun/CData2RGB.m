function out = CData2RGB(cdata,rgb)

if nargin==1
  rgb=[0,0,0];
end

r=rgb(1);
g=rgb(2);
b=rgb(3);
[m,n]=size(cdata);
out=NaN([m,n,3]);
for i=1:m
  for j=1:n
    if cdata(i,j)==1
      out(i,j,1)=r;
      out(i,j,2)=g;
      out(i,j,3)=b;
    elseif cdata(i,j)==2
      out(i,j,:)=1;
    end
  end
end