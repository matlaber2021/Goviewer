function updateNodeInfo(node)
% Update tree node infomation.

obj=CDataFactory;

if(~isempty(node.NodeData))
  stone=node.NodeData;
  if(~stone.HasBeenPlayedOnBoard)
    SGFInfoSyncFun(stone,-1);
  end
  
  if(isempty(stone.side))
    ICON=CData2RGB(obj.BlackIcon.cdata,[0,1,0]); % green
    ICON(isnan(ICON))=1;
  elseif(stone.side==0)
    ICON=CData2RGB(obj.BlackIcon.cdata,[0,1,0]); % green
    ICON(isnan(ICON))=0.94;
  elseif(stone.side==1)
    ICON=CData2RGB(obj.BlackIcon.cdata);
    ICON(isnan(ICON))=0.94;
  elseif(stone.side==2)
    ICON=CData2RGB(obj.WhiteIcon.cdata);
    ICON(isnan(ICON))=0.94;
  end
  
  node.Icon=ICON;
  N=size(stone.position,1);
  %if(stone.side==1)
  %  nodetext='Black';
  %elseif(stone.side==2)
  %  nodetext='White';
  %elseif(stone.side==0)
  %  nodetext='None';
  %end
  nodetext='';
  for idx=1:N
    x=stone.position(idx,2);
    y=(19+1)-stone.position(idx,1);
    temp=sprintf('[%s]',char([x,y]+64));
    nodetext=[nodetext,temp]; %#ok
  end
  nodetext=[nodetext,' ',stone.note];
  node.Text=nodetext;
  
end