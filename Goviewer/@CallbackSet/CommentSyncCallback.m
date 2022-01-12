function CommentSyncCallback(h,e) %#ok
% 落子后将评论推送至弹窗

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
stone=Manager.DATA.CURRENT_STONE;
if(isfield(Manager.CONFIG,'SHOW_COMMENT'))
  if(Manager.CONFIG.SHOW_COMMENT)
    ufig=Manager.WINDOW.COMMENT_WINDOW;
    hh=findobj(ufig,'type','uitextarea');
    if(~isempty(hh))
      hh.Value=stone.comment;
    end
  end
end