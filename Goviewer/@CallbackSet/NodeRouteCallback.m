function NodeRouteCallback(h,e) %#ok


f=ancestor(h,'figure');
if(strcmp(f.Name,'Stone Tree'))
  ufig=f;
  fig=get(ufig,'UserData');
  Manager=get(fig,'UserData');
  stone0=Manager.DATA.CURRENT_STONE;
else
  fig=f;
  Manager=get(fig,'UserData');
  stone0=Manager.DATA.CURRENT_STONE;
end