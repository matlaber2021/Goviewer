function EditNodeNameCallback(h,e) %#ok
% callback of editing node names

node=e.Node;
stone=node.NodeData;
note1=regexprep(node.Text,'(^\[\w\d{1,2}\]\s)','');
stone.note=note1;
SGFInfoSyncFun(stone,1);
updateNodeInfo(node);

