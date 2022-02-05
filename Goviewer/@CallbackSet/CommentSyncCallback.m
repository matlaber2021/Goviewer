function CommentSyncCallback(h,e) %#ok
% push the stone comment infomation onto the comment window

fig=ancestor(h,'figure');
manager=get(fig,'UserData');
stone=manager.DATA.CURRENT_STONE;
if(isfield(manager.CONFIG,'SHOW_COMMENT'))
  if(manager.CONFIG.SHOW_COMMENT)
    ufig=manager.WINDOW.COMMENT_WINDOW;
    hh=findobj(ufig,'type','uitextarea');
    if(~isempty(hh))
      hh.Value=stone.comment;
    end
  end
end