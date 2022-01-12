function CommentEditCallback(h,e) %#ok
% 编辑评论框按钮回调函数

ufig=ancestor(h,'figure');
textarea=findobj(ufig,'type','uitextarea');

if strcmp(h.State,'on')
  set(textarea,'Editable','on');
elseif(strcmp(h.State,'off'))
  set(textarea,'Editable','off');
end