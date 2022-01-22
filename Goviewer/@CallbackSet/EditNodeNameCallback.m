function EditNodeNameCallback(h,e)

node=e.Node;
stone=node.NodeData;
note1=regexprep(node.Text,'(^\[\w\d{1,2}\]\s)','');
note0=stone.note;
if(isequal(note1,note0))
  return
end
SGFInfoSyncFun(stone,1);

