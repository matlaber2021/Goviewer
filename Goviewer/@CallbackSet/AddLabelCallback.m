function AddLabelCallback(h,e)
% callback of adding labels

% Check for the current Stone, to get the last label letter. Similarly,
% depulicating from the orginal SGF infomation is both conservative way.
fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
stone=Manager.DATA.CURRENT_STONE;
if(~stone.HasBeenPlayedOnBoard)
  SGFInfoSyncFun(stone,-1);
end
lb=stone.label;
if(~isempty(lb))
  letter=regexp(strtrim(lb),'\[\w\w:(\w*?)\]$','tokens');
  letter=letter{1}{1};
  s=char(letter+1);
elseif(isempty(lb))
  letter=96;
  s=char(letter+1);
end

% Getting the current cordinate, then begin to modify the label property
% and finally refresh the SGF infomation. Don't forget to update the new
% stone labels before doing clean up the function as well.
o1 = onCleanup(@() SGFInfoSyncFun(stone,1));
o2 = onCleanup(@() updateStoneLabels(fig));
p0=round(e.IntersectionPoint);
state=Manager.DATA.CURRENT_STATE;
[m,n]=size(state); %#ok
p=char([p0(1),m+1-p0(2)]+96);
PROPVAL1=sprintf('[%s:%s]',p,s);
stone.label=[stone.label,PROPVAL1];

