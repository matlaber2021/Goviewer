function out=backwardfun(fig)
% The local sub-function of BackwardCallback function. The backwardfun will
% change the board data after doing backward step.

Manager = get(fig,'UserData');
stone0 = Manager.DATA.CURRENT_STONE;
state0 = Manager.DATA.CURRENT_STATE;
[m,n] = size(state0); %#ok

state1=state0;
stone1=stone0.parent;
s=stone0.side;
if(isempty(stone1)), return, end

pToBeRestored=stone0.pRemovedStone;
pToBeDeleted=stone0.position;

pToRecover=stone0.pClearedStone;
sToRecover=stone0.sClearedStone;

if(~isempty(pToBeRestored))
  for idx=1:size(pToBeRestored,1)
    x=pToBeRestored(idx,1);
    y=pToBeRestored(idx,2);
    state1(x,y)=s-(-1)^s;
  end
end

if(~isempty(pToBeDeleted))
  for idx=1:size(pToBeDeleted,1)
    x=pToBeDeleted(idx,1);
    y=pToBeDeleted(idx,2);
    state1(x,y)=0;
  end
end

if(~isempty(pToRecover))
  for idx=1:size(pToRecover,1)
    x=pToRecover(idx,1);
    y=pToRecover(idx,2);
    s=sToRecover(idx);
    state1(x,y)=s;
  end
end

Manager.DATA.CURRENT_STONE=stone1;
Manager.DATA.CURRENT_STATE=state1;

out=struct();
out.pToBeRestored=pToBeRestored;
out.pToBeDeleted=pToBeDeleted;
out.state0=state0;
out.stone0=stone0;
out.state1=state1;
out.stone1=stone1;