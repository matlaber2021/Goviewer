function CommentCallback(h,e) %#ok
% callback function for showing the comment window.

fig=ancestor(h,'figure');
manager=get(fig,'UserData');
%stone=manager.DATA.CURRENT_STONE;

if(~isfield(manager.CONFIG,'SHOW_COMMENT'))
  manager.CONFIG.SHOW_COMMENT=0;
end

if(~manager.CONFIG.SHOW_COMMENT)
  manager.CONFIG.SHOW_COMMENT=1;
  GoViewer.CreateCommentWindow(fig);
end