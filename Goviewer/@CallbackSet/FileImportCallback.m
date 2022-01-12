function FileImportCallback(h,e)
% 导入文件的回调函数

fig=ancestor(h,'figure');
Manager=get(fig,'UserData');

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
    obj=SGFReader(fullname,'gbk');
    obj.Encoding='gbk';
    SGFParser(obj);
    Manager.DATA.CURRENT_STONE=obj.CURRENT_STONE;
  case {'.gib'}
    ReaderObj=GIBReader();
  otherwise
    
end

assignin('base','stone',obj.CURRENT_STONE);


