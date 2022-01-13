function TreeNodeCallback(h,e) %#ok
% Tree-Chart callback
%
% TODO: 加入交互功能

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
stone=Manager.DATA.CURRENT_STONE;

ufig = uifigure('Name','Stone Tree');
ufig.Position(3)=750;
ufig.Position(4)=600;
movegui(ufig,'center');

tree = uitree(ufig);
tree.Position=[16,16,750-32,600-32];
tree.BackgroundColor=[0.94 0.94 0.94];

tree.SelectionChangedFcn=@CallbackSet.StoneNodeExpandCallback;
tree.NodeExpandedFcn=@CallbackSet.StoneNodeExpandCallback;

s=stone.children;
while 1
  if(isempty(s)), break; end
  s=s(1);
  node=uitreenode(tree);
  %str=displaySGFInfo(s);
  %node.Text=str(1:min(length(str),10));
  node.NodeData=s;
  updateNodeInfo(node);
  CallbackSet.StoneNodeExpandCallback(node,[]);
  s=s.children;
end