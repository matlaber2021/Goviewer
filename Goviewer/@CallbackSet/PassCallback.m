function PassCallback(h,e)
% Pass is the Stone object with no position, however the pass move belongs
% to move stone, so the status property is 1. You can add comments and
% notes on it.
%
% Pass move has no influence on the board. But the stone marker will
% disappear. Pass move has its own move number like other normal moved
% stone, and it has own treenode if necessary to show the tree chart.
%
% The pass move may be black or white, they take place by turn. The SGF
% infomation of black for example is B[] or B[tt](old rule). We choose the  
% former pattern.

fig=ancestor(h,'figure');
manager=get(fig,'UserData');
stone=manager.DATA.CURRENT_STONE;
o1 = onCleanup(@() CallbackSet.CommentSyncCallback(h,e) );
o2 = onCleanup(@() updateStoneMarkup(fig) );
o3 = onCleanup(@() updateStoneOrder(fig) );
o4 = onCleanup(@() updateStonePath(fig));
o5 = onCleanup(@() updateStoneLabels(fig) );
o6 = onCleanup(@() updateStoneNode(fig) );
o7 = onCleanup(@() updateStoneMarker(fig) );
s=manager.DATA.NEXTSIDE;
if(isempty(s)), s=1; end
manager.DATA.CURRENT_STONE=moveStone(stone,s,[]);
manager.DATA.ISKOLOCKED=0;
manager.DATA.NEXTSIDE=s-(-1)^s;