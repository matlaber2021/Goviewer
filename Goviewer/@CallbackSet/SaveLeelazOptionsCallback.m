function SaveLeelazOptionsCallback(h,e) %#ok
% 保存leelaz的对局参数的回调函数
%
% WARN: 需要在该回调触发后才能向里拉引擎执行默认指令

fig0 = h.Parent;
hKOMI = findobj(fig0,'tag','komi');
KOMI = get(hKOMI,'Value');
hHSIDE = findobj(fig0,'tag','human_side');

switch get(hHSIDE,'Value')
  case {'黑','Black','b','B','BLACK',1}
    HUMAN_SIDE  = 1;
    LEELAZ_SIDE = 2;
  case {'白','White','w','W','WHITE',2}
    HUMAN_SIDE  = 2;
    LEELAZ_SIDE = 1;
  otherwise
    error('里拉对局参数中对弈双方无法正常识别.');
end

hHANDICAP = findobj(fig0,'tag','handicap');
HANDICAP = get(hHANDICAP,'Value');
if ischar(HANDICAP)
  HANDICAP = str2double(HANDICAP);
elseif iscell(HANDICAP)
  HANDICAP = str2double(HANDICAP);
end

fig = get(fig0,'UserData');
Manager = get(fig,'UserData');
setPropValPrivFcn(Manager,'LEELAZERO','HANDICAP',HANDICAP)
setPropValPrivFcn(Manager,'LEELAZERO','OPTIONSET',1)
Manager.OPTIONSET_LEELAZERO = 1;
setPropValPrivFcn(Manager,'LEELAZERO','HUMAN_SIDE',HUMAN_SIDE)
setPropValPrivFcn(Manager,'LEELAZERO','LEELAZ_SIDE',LEELAZ_SIDE)
setPropValPrivFcn(Manager,'LEELAZERO','KOMI',KOMI)

% 关闭弹窗
close(fig0);
delete(fig0);

end