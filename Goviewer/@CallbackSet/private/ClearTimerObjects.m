function ClearTimerObjects(tagName)
% 清理有特定<tagName>的Timer对象

hTimerLeelaz = timerfind('tag',tagName);
if ~isempty(hTimerLeelaz)
  delete(hTimerLeelaz);
end

end