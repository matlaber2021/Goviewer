function result=GIBParser(filename)
% This simple function is to parse file with .gib suffix. The parser is
% quite simple.

if exist(filename,'file')==0
  error('Could not find the target file "%s".',filename);
end

% Reading sgf data...
fid=fopen(filename,'r');
o = onCleanup(@() fclose(fid));
gibData = '';
while 1
  tline = fgets(fid);
  if ~ischar(tline), break, end
  gibData = [gibData, tline]; %#ok
end

config=struct;
stone=Stone();
stone=addChild(stone);

header=regexp(gibData,'\\HS.+?\\HE','match');
header=header{1};
game=regexp(gibData,'\\GS.+?\\GE','match');
game=game{1};

piece=regexp(header,'\\\[(.+?)\\\]','tokens');
piece=vertcat(piece{:});
for i=1:length(piece)
  out=strsplit(piece{i},'=');
  config.(out{1})=out{2};
end

piece=strsplit(game,newline());
for i=1:length(piece)
  data=strsplit(piece{i});
  switch data{1}
    case {'INI'} % handicap
      handicap=str2double(data{4});
      
      if(handicap>0)
        stone=addChild(stone);
        stone.status=2;
        stone.side=1;
      end
      
      %%% TODO %%%
      switch handicap
        case {2}
          stone.position=[16,4;4,16];
        case {3}
          stone.position=[16,4;4,4;4,16];
        case {4}
          stone.position=[4,4;16,16;4,16;16,4];
        case {5}
          stone.position=[4,4;16,16;4,16;16,4;10,10];
        case {6}
          stone.position=[4,4;16,16;4,16;16,4;4,10;16,10];
        case {7}
          stone.position=[4,4;16,16;4,16;16,4;10,4;10,16;10,10];
        case {8}
          stone.position=[4,4;16,16;4,16;16,4;4,10;16,10;10,4;10,16];
        case {9}
          stone.position=[4,4;16,16;4,16;16,4;4,10;16,10;10,4;10,16;10,10];
      end
      SGFInfoSyncFun(stone,1);
      
    case {'STO'} % stone
      stone=addChild(stone);
      stone.status=1;
      stone.side=str2double(data{4});
      p=str2double(data(5:6)')'+1;
      x=p(2);
      y=p(1);
      stone.position=[x,y];
      SGFInfoSyncFun(stone,1);
      
  end
end

result.config=config;
result.stone=stone;