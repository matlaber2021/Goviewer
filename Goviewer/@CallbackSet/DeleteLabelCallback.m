function DeleteLabelCallback(h,e)
% callback of deleting the label

fig=ancestor(h,'figure');
manager=get(fig,'UserData');
state=manager.DATA.CURRENT_STATE;
[m,n]=size(state); %#ok

%o = onCleanup(@() delete@handle(h));
o = onCleanup(@() delete(h));
position=round(e.IntersectionPoint);
p(1)=char(position(1)+96);
p(2)=char(m+1-position(2)+96);
s=get(h,'String');
PROPVAL1=sprintf('[%s:%s]',p,s);

stone=manager.DATA.CURRENT_STONE;
SGFPROPS=strtrim(stone.SGFPROPS);
pos=strcmp(SGFPROPS,'LB');
SGFPROPVAL=stone.SGFPROPVAL;

if(any(pos))
  PROPVAL0=regexprep(SGFPROPVAL{pos},'\s','');
  PROPVAL0=strrep(PROPVAL0,PROPVAL1,'');
  
  if(isempty(PROPVAL0))
    stone.SGFPROPS(pos)=[];
    stone.SGFPROPVAL(pos)=[];
    stone.label=[];
  elseif(~isempty(PROPVAL0))
    stone.SGFPROPVAL{pos}=PROPVAL0;
    stone.label=stone.SGFPROPVAL{pos};
  end
  
end
