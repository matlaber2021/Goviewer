function DeleteLabelCallback(h,e)
% callback of deleting the label

%o = onCleanup(@() delete@handle(h));
o = onCleanup(@() delete(h));
position=round(e.IntersectionPoint);
p=char(position(2:-1:1)-96);
s=get(h,'String');
PROPVAL1=sprintf('[%s:%s]',p,s);

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
stone=Manager.DATA.CURRENT_STONE;

SGFPROPS=strtrim(stone.SGFPROPS);
pos=strcmp(SGFPROPS,'LB');
SGFPROPVAL=stone.SGFPROPVAL;

if(~any(pos))
  PROPVAL0=SGFPROPVAL{pos};
  PROPVAL0=strrep(PROPVAL0,PROPVAL1,'');
  
  if(isempty(PROPVAL0))
    stone.SGFPROPS(pos)=[];
    stone.SGFPROPVAL(pos)=[];
  elseif(~isempty(PROPVAL0))
    stone.SGFPROPVAL{pos}=PROPVAL0;
  end
  
end
