function CommentClosedCallback(h,e) %#ok
% callback function before closing the comment window.

fig=get(h,'UserData');
Manager=get(fig,'UserData');
Manager.CONFIG.SHOW_COMMENT=0;
delete(h);