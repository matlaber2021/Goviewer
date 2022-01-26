function LabelCallback(h,e) %#ok
% Label callback function
% 1.Delete label
% 2.Add label

fig=ancestor(h,'figure');
star=findobj(fig,'tag','star');
hstone=findobj(fig,'tag','stone');
marker=findobj(fig,'tag','marker');
path=findobj(fig,'tag','path');
label=findobj(fig,'tag','label');
board=findobj(fig,'type','axes');
cross=findobj(fig,'type','line');

if(strcmp(h.State,'on'))
  set(star,'ButtonDownFcn',@CallbackSet.AddLabelCallback);
  set(hstone,'ButtonDownFcn',@CallbackSet.AddLabelCallback);
  set(marker,'ButtonDownFcn',[]);
  set(path,'ButtonDownFcn',@CallbackSet.AddLabelCallback);
  set(label,'ButtonDownFcn',@CallbackSet.DeleteLabelCallback);
  set(board,'ButtonDownFcn',@CallbackSet.AddLabelCallback);
  set(cross,'ButtonDownFcn',@CallbackSet.AddLabelCallback);
elseif(strcmp(h.State,'off'))
  set(star,'ButtonDownFcn',@CallbackSet.DefaultCallback);
  set(hstone,'ButtonDownFcn',@CallbackSet.DefaultCallback);
  set(marker,'ButtonDownFcn',@CallbackSet.DefaultCallback);
  set(path,'ButtonDownFcn',@CallbackSet.DefaultCallback);
  set(label,'ButtonDownFcn',@CallbackSet.DefaultCallback);
  set(board,'ButtonDownFcn',@CallbackSet.DefaultCallback);
  set(cross,'ButtonDownFcn',@CallbackSet.DefaultCallback);
end