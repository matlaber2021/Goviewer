function result = findTerritory(state,p)
% 找到某块区域的领地

result.territory = NaN([0,2]);
result.code = -1;
result.belongto = [];

[m,n]=size(state);
x=p(1);
y=p(2);

belongto = state(x,y);
if belongto==0
  result.belongto=0;
  return
end

if belongto==1
  oppo=2;
elseif belongto==2
  oppo=1;
end

block=findBlock(state,p);

t = NaN([0,2]);

x0=x;
y0=y;
while 1
  step=1;
  x0=x0-step;
  if x0<1
    break
  end
  
  if state(x0,y0)==0
    
  



