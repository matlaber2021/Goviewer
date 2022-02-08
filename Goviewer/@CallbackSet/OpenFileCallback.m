function OpenFileCallback(h,e)
% open file callback

[filename,pathname]=uigetfile({'*.sgf;*.gib'});
if(isnumeric(filename))
  if(filename==0)
    return
  end
end

CallbackSet.NewBoardCallback(h,e);
fig=ancestor(h,'figure');
manager=get(fig,'UserData');

if(ischar(filename))
  fullname=fullfile(pathname,filename);
end
[~,~,ext]=fileparts(fullname);

switch(ext)
  case {'.sgf','.SGF'}
    obj=SGFReader(fullname);
    obj.Encoding='gbk';
    SGFParser(obj);
    manager.DATA.CURRENT_STONE=obj.CURRENT_STONE;
  case {'.gib'}
    result=GIBParser(fullname);
    root=findAncestor(result.stone);
    manager.DATA.CURRENT_STONE=root.children(1);
  otherwise
    
end


assignin('base','stone',manager.DATA.CURRENT_STONE);
assignin('base','manager',manager);
