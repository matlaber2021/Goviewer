function resetToolButtonState(h)
% 重置除了UI对象h以外的其他ToggleTool对象的状态属性

tip0 = get(h,'Tooltip');
hBar = get(h,'parent');
hButtons = findobj(hBar,'type','uitoggletool');
for i = 1:numel(hButtons)
  tip1 = get(hButtons(i),'ToolTip');
  if ~strcmp(tip1,tip0)
    set(hButtons(i),'state','off');
  end
end

end