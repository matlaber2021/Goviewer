function CommentEditCallback(h,e) %#ok
% the comment edit button in the comment function

ufig=ancestor(h,'figure');
textarea=findobj(ufig,'type','uitextarea');

if strcmp(h.State,'on')
  set(textarea,'Editable','on');
elseif(strcmp(h.State,'off'))
  set(textarea,'Editable','off');
end