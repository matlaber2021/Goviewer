function SaveFileCallback(h,e) %#ok
% 保存SGF文件的回调函数

fig=ancestor(h,'figure');
obj=GoPrinter(fig);

filter = {'*.sgf';'*.ibf';'*.gib'};
[file, path] = uiputfile(filter);

if(isequal(file,0)||isequal(path,0))
  return
end

filename=fullfile(path,file);
[~,~,ext]=fileparts(filename);

switch(ext)
  case {'.sgf','.SGF'}
    PrintSGF(obj);
    WriteSGF(obj,filename);
end
