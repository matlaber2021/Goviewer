function RotateCallback(h,e) %#ok
% 旋转90°回调函数

fig = ancestor(h,'figure');
ax = findobj(fig,'type','axes');
vi = get(ax,'view');
vi(1) = vi(1)-90;
set(ax,'view',vi);

end