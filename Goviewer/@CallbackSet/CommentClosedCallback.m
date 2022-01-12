function CommentClosedCallback(h,e) %#ok
% 评论弹窗关闭前的回调函数

fig=get(h,'UserData');
Manager=get(fig,'UserData');
Manager.CONFIG.SHOW_COMMENT=0;
delete(h);