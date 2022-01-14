function TreeNodeCallback(h,e) %#ok
% Tree-Chart callback
%
% TODO: 加入交互功能

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');
stone=Manager.DATA.CURRENT_STONE;

if(~isempty(stone))
  stone=findAncestor(stone);
else
  return
end

ufig = uifigure('Name','Stone Tree','Visible','off');
ufig.Position(3)=750;
ufig.Position(4)=600;
movegui(ufig,'center');
set(ufig,'UserData',fig);
o = onCleanup(@() set(ufig, 'Visible','on'));

tree = uitree(ufig);
tree.UserData=stone;
tree.Position=[16,16,750-32,600-32];
tree.BackgroundColor=[0.94 0.94 0.94];

tree.SelectionChangedFcn=@CallbackSet.StoneNodeSelectedCallback;
tree.NodeExpandedFcn=@CallbackSet.StoneNodeExpandCallback;

NodeExpandLocalFun(tree,1);

% hh.SelectedNodes=tree;
% CallbackSet.StoneNodeExpandCallback(hh,[]);

%stone1=stone.children;
% while 1
%   if(isempty(s)), break; end
%   s=s(1);
%   node=uitreenode(tree);
%   %str=displaySGFInfo(s);
%   %node.Text=str(1:min(length(str),10));
%   node.NodeData=s;
%   s.ShownInTreeNode=1;
%   updateNodeInfo(node);
%   %CallbackSet.StoneNodeExpandCallback(node,[]);
%   s=s.children;
% end

assignin('base','tree',tree);