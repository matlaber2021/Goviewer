function CommentValueChangedCallback(h,e) %#ok
% callback of the comment ValueChangedFcn property

ufig=ancestor(h,'figure');
fig=get(ufig,'UserData');
manager=get(fig,'UserData');
stone=manager.DATA.CURRENT_STONE;
if(~isequal(stone.comment,h.Value))
  stone.comment=h.Value;
end
SGFInfoSyncFun(stone,1);