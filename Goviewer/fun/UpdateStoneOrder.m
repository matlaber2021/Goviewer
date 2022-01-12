function UpdateStoneOrder(h)
% 更新落子顺序

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
option=getPropValCONFIG(Manager,'STONE_ORDER_OPTION');
CallbackSet.StoneOrderCallback(h,[],option);
