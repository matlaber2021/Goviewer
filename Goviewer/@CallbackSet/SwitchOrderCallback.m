function SwitchOrderCallback(h,e)

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
option=getPropValCONFIG(Manager,'STONE_ORDER_OPTION');

if isempty(option)
  option=1;
elseif option==1
  option=2;
elseif option==2
  option=3;
elseif option==3
  option=4;
elseif option==4
  option=1;
end

setPropValCONFIG(Manager,'STONE_ORDER_OPTION',option);
CallbackSet.StoneOrderCallback(h,[],option);