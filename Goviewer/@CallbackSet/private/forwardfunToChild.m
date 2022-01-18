function out=forwardfunToChild(fig,idx)
% forwardfunToChild is another local sub-function of ForwardCallback 
% function. Unlike the forwardfun function, this function resolves the
% second case of the forwarding step. The <idx> input argument means go to
% the {idx}th of the current stone, this function don't need to follow the
% preorder-traversal strictly.

Manager = get(fig,'UserData');
stone0 = Manager.DATA.CURRENT_STONE;
state0 = Manager.DATA.CURRENT_STATE;
[m,n] = size(state0); %#ok
state1 = state0;
pToMove=NaN([0,2]);
pToBeRemoved=NaN([0,2]);

if(isempty(stone0.children))
  stone1=[];
else
  stone1=stone0.children(idx);
end

if(isempty(stone1))
  out=struct();
  out.pToMove=pToMove;
  out.pToBeRemoved=pToBeRemoved;
  out.state0=state0;
  out.stone0=stone0;
  out.state1=state0;
  out.stone1=stone0;
  return
end

% Moving in normal way, not considering of branch case.
if(~isempty(stone1))
  updateStoneAndState;
end

Manager.DATA.CURRENT_STATE=state1;
Manager.DATA.CURRENT_STONE=stone1;

out=struct();
out.pToMove=pToMove;
out.pToBeRemoved=pToBeRemoved;
out.state0=state0;
out.stone0=stone0;
out.state1=state1;
out.stone1=stone1;

  function updateStoneAndState
    
    % BUGFIX
    if(~stone1.HasBeenPlayedOnBoard)
      SGFInfoSyncFun(stone1,-1);
    end
    
    % AE
    if(stone1.status==2)
      if(stone1.side==0)
        p=stone1.pClearedStone;
        ss=stone1.sClearedStone;
        N=size(p,1);
        for i=1:N
          ss(i,1)=state1(p(i,1),p(i,2));
          state1(p(i,1),p(i,2))=0;
        end
        stone1.sClearedStone=ss;
      end
    end
    
    % AB-AW
    if(stone1.status==2)
      if(stone1.side>0)
        pToMove = stone1.position;
        for i=1:size(pToMove,1)
          x=pToMove(i,1);
          y=pToMove(i,2);
          if(state1(x,y)~=0)
            fprintf('Overlapping the original point[status=2].\n');
            
            % BUGFIX
            stone1.pClearedStone=[x,y];
            stone1.sClearedStone=state1(x,y);
          end
          state1(x,y)=stone1.side;
        end
      end
    end
    
    % Moved Stones
    if(stone1.status==1)
      if(stone1.side>0)
        if(~stone1.HasBeenPlayedOnBoard)
          result=tryMove(state1,stone1.side,stone1.position);
          if(result.code~=0 && result.code~=-1)
            error('The wrong move happens[errcode=%d].\n',result.code);
          elseif(result.code==-1)
            fprintf(2, 'Overlapping the original point[errcode=-1].\n');
            stone1.pRemovedStone=[];
            x=stone1.position(1);
            y=stone1.position(2);
            
            % Overlapping does not means the error, we can put the replaced
            % stone inside the exclusive property. And we will restore it
            % correctly by using backwardfun function.
            stone1.pClearedStone=[x,y];
            stone1.sClearedStone=state1(x,y);
            state1(x,y)=stone1.side;
            
          else
            stone1.pRemovedStone=result.totake;
            state1=result.state1;
          end
          
        elseif(stone1.HasBeenPlayedOnBoard)
          pToMove = stone1.position;
          pToBeRemoved = stone1.pRemovedStone;
          
          for i=1:size(pToMove,1)
            x=pToMove(i,1);
            y=pToMove(i,2);
            state1(x,y)=stone1.side;
          end
          
          for i=1:size(pToBeRemoved)
            x=pToBeRemoved(i,1);
            y=pToBeRemoved(i,2);
            state1(x,y)=0;
          end
        end
      end
    end
    
  end% updateStoneAndState

end
