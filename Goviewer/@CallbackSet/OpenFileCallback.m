function OpenFileCallback(h,e) %#ok
% open file callback

fig=ancestor(h,'figure');
manager=get(fig,'UserData');

[filename,pathname]=uigetfile({'*.sgf'});
if(isnumeric(filename))
  if(filename==0)
    return
  end
end

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
    ReaderObj=GIBReader();
  otherwise
    
end

assignin('base','stone',obj.CURRENT_STONE);
assignin('base','manager',manager);

