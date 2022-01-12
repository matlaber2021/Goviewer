function hList = findAllGobjects(h)
% 找到所有的图形对象

fig = ancestor(h,'figure');
ax  = findobj(fig,'type','axes');
hLine = findobj(fig,'type','line');
hPatch = findobj(fig,'type','patch');
hList=[ax;hLine;hPatch];

end