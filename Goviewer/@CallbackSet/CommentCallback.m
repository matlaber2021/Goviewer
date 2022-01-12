function CommentCallback(h,e)

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
stone=Manager.DATA.CURRENT_STONE;

if(~isfield(Manager.CONFIG,'SHOW_COMMENT'))
  Manager.CONFIG.SHOW_COMMENT=0;
end

if(~Manager.CONFIG.SHOW_COMMENT)
  Manager.CONFIG.SHOW_COMMENT=1;
  GoViewer.CreateCommentWindow(fig);
end