function updateStoneOrder(h)
% update the stone move number, calling StoneOrderCallback function.

fig=ancestor(h,'figure');
manager=get(fig,'UserData');
option=manager.CONFIG.STONE_ORDER_OPTION;
CallbackSet.StoneOrderCallback(h,[],option);
