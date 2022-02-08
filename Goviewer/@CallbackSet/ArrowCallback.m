function ArrowCallback(h,e,action) %#ok
% callback functions of arrow, inspired by interpgui.m in nmp package.
%
% ArrowCallback(handle,eventdata,'button')  when click the uitogglebutton.
% ArrowCallback(handle,eventdata,'down')    when mouse down, save the anchor of
%                                           the arrow.
% ArrowCallback(handle,eventdata,'motion')  mouse moving, the contour
%                                           profile of the arrow.
% ArrowCallback(handle,eventdata,'up')      determine the arrow finally
% ArrowCallback(handle,eventdata,'delete')  delete the arrow group objects

if(nargin<3)
  action='button';
end

fig=ancestor(h,'figure');
ax=findobj(fig,'type','axes');
manager=get(fig,'UserData');
stone=manager.DATA.CURRENT_STONE;
state=manager.DATA.CURRENT_STATE;
[m,n]=size(state);%#ok

% When clicking the toggle buttton
if(strcmp(action,'button'))
  
  if(strcmp(h.State,'on'))
    
    obj=findobj(ax,'-not','tag','arrow');
    set(obj,'ButtonDownFcn',[]);
    
    set(fig,'windowbuttondown',{@CallbackSet.ArrowCallback,'down'});
    set(fig,'windowbuttonmotion',{@CallbackSet.ArrowCallback,'motion'});
    set(fig,'windowbuttonup',{@CallbackSet.ArrowCallback,'up'});
    
  elseif(strcmp(h.State,'off'))
    
    obj=findall(ax);
    set(obj,'ButtonDownFcn',@CallbackSet.DefaultCallback);
    set(fig,'windowbuttondown',[]);
    set(fig,'windowbuttonmotion',[]);
    set(fig,'windowbuttonup',[]);
    
  end
  
end

% start to plot arrow
if(strcmp(action,'down'))
  p=round(get(ax,'currentpoint'));
  p=p(2,[1,2]);
  if any(p<1)||any(p>19)
    return
  end
  setappdata(ax,'start',p);
end

% plotting arrow
if(strcmp(action,'motion'))
  
  delete(findobj(ax,'tag','arrow_'));
  e=round(get(ax,'currentpoint'));
  e=e(2,[1,2]);
  if any(e<1)||any(e>19)
    return
  end
  s=getappdata(ax,'start');
  if(isequal(s,e)), return; end
  if(isempty(s)), return; end
  x=[s(1),e(1)];
  y=[s(2),e(2)];
  h=arrow(ax,x,y,0.3);
  setappdata(ax,'end',e);
  
  % Because cannot make a transparent line, so consider drawing a dashed
  % line instead.
  set(h(1),'linestyle',':');
  set(h(2),'edgealpha',0.3,'facealpha',0.3);
  set(h,'tag','arrow_');
end

% finishing the arrow
if(strcmp(action,'up'))
  o1=onCleanup(@() setappdata(ax,'start',[]));
  o2=onCleanup(@() setappdata(ax,'end',[]));
  p=findobj(ax,'tag','arrow_','type','patch');
  l=findobj(ax,'tag','arrow_','type','line');
  set(l,'linestyle','-');
  set(p,'edgealpha',1,'facealpha',1);
  set([l;p],'tag','arrow');
  
  s=getappdata(ax,'start');
  e=getappdata(ax,'end');
  
  if(~stone.HasBeenPlayedOnBoard)
    SGFInfoSyncFun(stone,-1);
  end
  msg=stone.arrow;
  if(~isempty(s))
    if(~isempty(e))
      
      S=char([s(1),m+1-s(2)]+96);
      E=char([e(1),m+1-e(2)]+96);
      
      msg=[msg,sprintf('[%s:%s]',S,E)];
      stone.arrow=msg;
      SGFInfoSyncFun(stone,1);
      
    end
  end
  
end

% Delete the current arrow graphic objects
if(strcmp(action,'delete'))
  o=onCleanup(@() SGFInfoSyncFun(stone,1));
  
  group=getappdata(h,'group');
  hline=[];
  for i=1:numel(group)
    if isa(group(i),'matlab.graphics.primitive.Line')
      hline=group(i);
      break
    end
  end
  
  if(isempty(hline))
    warning('Cannot delete the arrow, not found the arrow group objects');
    return
  end
  
  x=get(hline,'xdata');
  y=get(hline,'ydata');
  s=[x(1),y(1)];
  e=[x(2),y(2)];
  
  msg=stone.arrow;
  S=char([s(1),m+1-s(2)]+96);
  E=char([e(1),m+1-e(2)]+96);
  pattern=sprintf('\\[%s:%s\\]',S,E);
  [ss,ee]=regexpi(msg,pattern,'start','end');
  
  for idx=length(ss):-1:1
    msg(ss(idx):ee(idx))=[];
  end
  stone.arrow=msg;
  delete(group);
  
end