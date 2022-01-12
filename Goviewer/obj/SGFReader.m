classdef SGFReader < handle
  %SGFREADER 读取并解析SmartGoFormat格式的函数
  %
  % 提示
  % 该对象随时可能修改
  
  properties
    Filename
    Encoding    = []; % utf8
    FileID
    ShowProgressBar = 1;
  end
  
  properties(Hidden=false)
    TEXT
    TEXTLENGTH            = 0;
    CURRENT_DEPTH         = 0;  % 当前搜索深度
    PARSING_PROPS         = 0;  % 是否正在解析Properties
    PARSING_PROPVAL       = 0;  % 是否正在解析Property Value
    DEPTH                 = 0;  % 搜索深度
    CURRENT_PROPS         = ''; % 当前属性
    CURRENT_PROPVAL       = ''; % 当前属性值
    I                     = 1;  % 当前识别位置
  end
  
  properties(Hidden=false)
    CURRENT_STONE         = Stone(); % 当前节点
    BRANCH                = [];      % 所有分支节点
    CURRENT_ROOT          = [];      % 当前根节点（无实义）
    JustAddedBranch       = 0;       % 是否刚刚添加过分支节点
  end
  
  properties(Hidden)
    ProgressBar
    ProgressBarTimer
  end
  
  methods
    
    function obj = SGFReader(filename,encoding)
      % 读取SmartGoFormat格式的文件
      % SGFReader(filename)
      
      if exist(filename,'file')==0
        error('Could not find the target file "%s".',filename);
      end
      
      createProgressBar(obj);
      obj.Filename=filename;
      obj.CURRENT_STONE = Stone();
      
      MatlabEncodingCheck=0;
      if(nargin<2)
        autoEncodingCheck(obj);
        % If auto encoding check fails, using matlab checking.
        if(isempty(obj.Encoding))
          MatlabEncodingCheck=1;
        end
      elseif(nargin==3)
        if(isempty(encoding))
          MatlabEncodingCheck=1;
        elseif(~isempty(encoding))
          obj.Encoding=encoding;
        end
      end

      if(~MatlabEncodingCheck)
        fid=fopen(filename,'r','n',obj.Encoding);
      elseif(MatlabEncodingCheck)
        fid=fopen(filename,'r');
      end
      o = onCleanup(@()fclose(fid));  
        
      % Reading sgf data...
      sgfData = '';
      while 1
        tline = fgets(fid);
        if ~ischar(tline), break, end
        sgfData = [sgfData, tline]; %#ok
      end
      obj.TEXT = sgfData;
      obj.TEXTLENGTH = length(obj.TEXT);
    end
    
    function SGFParser(obj)
      % SGF prasing step.
      
      prepareForProgressBar(obj);
      o1 = onCleanup(@() cleanup(obj.ProgressBarTimer));
      o2 = onCleanup(@() delete(obj.ProgressBar));
      
      obj.CURRENT_ROOT=obj.CURRENT_STONE;
      
      while(obj.I<=numel(obj.TEXT))
        
        %obj.ProgressBar.Value=obj.I/numel(obj.TEXT);
        
        % Often at the begining, recognizing of the left paren which means
        % that the parsing depth will be increased by one level, also be
        % concluded that it may open the next branch. If the left paren
        % occurrs when parsing PROPVAL, it won't pass through the if-block.
        if ~obj.PARSING_PROPS
          if ~obj.PARSING_PROPVAL
            if obj.TEXT(obj.I)=='('
              obj.CURRENT_DEPTH=obj.CURRENT_DEPTH+1;
              obj.DEPTH = [obj.DEPTH; obj.CURRENT_DEPTH];
              obj.I=obj.I+1;
              
              % Opening up the new branch, however maybe the branch node
              % would possibly be changed.
              
              %obj.BRANCH = [obj.BRANCH; obj.CURRENT_STONE];
              %obj.BRANCH{end+1}=obj.CURRENT_STONE;
              if(length(obj.BRANCH)<obj.CURRENT_DEPTH)
                obj.BRANCH{obj.CURRENT_DEPTH}=[];
              end
              obj.BRANCH{obj.CURRENT_DEPTH}{end+1}=obj.CURRENT_STONE;
              obj.JustAddedBranch=1;
              continue;
            end
          end
        end
        
        % On the other hand, the right paren means that the parsing depth
        % will be decreased by one degree, and the new branch exits, then
        % back to the preceeding branch. if the right paren occurrs when
        % parsing PROPVAL, it won't pass through this if-block.
        if ~obj.PARSING_PROPS
          if ~obj.PARSING_PROPVAL
            if obj.TEXT(obj.I)==')'
              
              % Return the last target branch.
              if(obj.CURRENT_DEPTH>0)
                %obj.CURRENT_STONE = obj.BRANCH(obj.CURRENT_DEPTH);
                obj.CURRENT_STONE = obj.BRANCH{obj.CURRENT_DEPTH}{end};
              else
                obj.CURRENT_STONE = [];
              end
              
              % if meeting with multiple ")" symbol, it would traverse this
              % statement over and over, and the current depth will be
              % lower and lower.
              obj.CURRENT_DEPTH=obj.CURRENT_DEPTH-1;
              obj.DEPTH = [obj.DEPTH; obj.CURRENT_DEPTH];
              obj.I=obj.I+1;
              
              continue;
            end
          end
        end
        
        % Semicolon symbol may means the next string will be PROP. If
        % semicolon symbol occurs when parsing PROPVAL, it won't step into
        % the if-block.
        if ~obj.PARSING_PROPS
          if ~obj.PARSING_PROPVAL
            if obj.TEXT(obj.I)==';'
              obj.PARSING_PROPS=1;
              obj.CURRENT_PROPS = '';
              obj.I=obj.I+1;
              
              splitMultiPROPS(obj);
              
              % After spliting the props, set the <JustAddedBranch>
              % property false.
              if(obj.JustAddedBranch)
               obj.JustAddedBranch=0;
              end
              
              % Then adding the empty new stone
              obj.CURRENT_STONE = addChild(obj.CURRENT_STONE);
              continue;
            end
          end
        end
        
        % The following is the process of parsing PROPS. For example AB in
        % AB[pd] is PROPS, and [pd] is called PROPVAL. When parsing through
        % the left bracket, marking the end of parsing step, then parsing
        % PROPVAL immediately.
        if obj.PARSING_PROPS
          if ~obj.PARSING_PROPVAL
            while obj.TEXT(obj.I)~='['
              if ~isempty(obj.TEXT(obj.I))
                obj.CURRENT_PROPS=[obj.CURRENT_PROPS,obj.TEXT(obj.I)];
                obj.I=obj.I+1;
              end
            end
            obj.PARSING_PROPS=0;
            obj.PARSING_PROPVAL=1;
            obj.CURRENT_PROPVAL='';
            continue;
          end
        end
        
        % The process of parsing PROPVAL. Because the ending marker of
        % PROPVAL is ambiguous, using parsingPROPVAL internal method to
        % recognizing it auxiliarily.
        if ~obj.PARSING_PROPS
          if obj.PARSING_PROPVAL
            
            % Most to deal with the following two cases
            % (1) If ...LB[cc][pd])... occurs, detecting the PROPVAL of
            % [cc][pd]
            % (2) If ...C[好棋!]AP[... occurs, detecting the PROPVAL of [
            % 好棋!]
            parsingPROPVAL(obj);
            
            obj.I=obj.I+1;
            continue;
          end
          
        end
        
        % If meeting with the rest cases(e.g. Empty chars...), it won't affect
        % the parsing result, continuing the while-loop as usual.
        obj.I=obj.I+1;
        
      end % while
      
    end
    
  end
  
  methods(Access=private,Hidden)
    function parsingPROPVAL(obj)
      % method for parsing the PROPVAL
      
      % Maybe the usual PROPVAL is the infomation within the bracket [],
      % but unfortunately it's not. The PROPS LB(label) has multi-bracket
      % such as LB[...][...]..., so the right bracket symbol CANNOT be the
      % anchor of the ending.
      %
      % Two cases mean the end
      % [1] If you can find the next PROPS.
      % [2] If you can find the paren(left or right).
      while obj.I<=numel(obj.TEXT)
        
        if obj.TEXT(obj.I)~=']'
          obj.CURRENT_PROPVAL=[obj.CURRENT_PROPVAL,obj.TEXT(obj.I)];
          obj.I=obj.I+1;
          continue;
        else
          obj.CURRENT_PROPVAL=[obj.CURRENT_PROPVAL,']'];
          
          PROPS=findNextProps(obj);
          
          if ~isempty(PROPS)
            obj.CURRENT_STONE.SGFPROPS{end+1}=obj.CURRENT_PROPS;
            obj.CURRENT_STONE.SGFPROPVAL{end+1}=obj.CURRENT_PROPVAL;
            obj.PARSING_PROPVAL=0;
            
            obj.PARSING_PROPS=1;
            obj.CURRENT_PROPS=[];
            
            return
          elseif isNextSemicolon(obj)
            obj.CURRENT_STONE.SGFPROPS{end+1}=obj.CURRENT_PROPS;
            obj.CURRENT_STONE.SGFPROPVAL{end+1}=obj.CURRENT_PROPVAL;
            obj.PARSING_PROPVAL=0;
            
            return
          elseif isNextParen(obj)
            obj.CURRENT_STONE.SGFPROPS{end+1}=obj.CURRENT_PROPS;
            obj.CURRENT_STONE.SGFPROPVAL{end+1}=obj.CURRENT_PROPVAL;
            obj.PARSING_PROPVAL=0;
            return
          end
        end
        obj.I=obj.I+1;
        
      end
      
      
    end
    
    function PROPS = findNextProps(obj)
      % finding the next PROPS
      
      % PROPS must be A-Z chars, so it is easy to find the next PROPS.
      % And when parsing '[' symbol as I mentioned eariler, you can get the
      % completely PROPS, also considering of skipping the empty chars.
      PROPS='';
      if numel(obj.TEXT)==obj.I, return, end
      
      Idx=obj.I+1;
      while(Idx<=numel(obj.TEXT))
        
        if isspace(obj.TEXT(Idx))
          Idx=Idx+1;
          continue;
        elseif obj.TEXT(Idx)==';'
          return
        elseif obj.TEXT(Idx)==')'
          return
        elseif obj.TEXT(Idx)=='('
          return
        elseif (obj.TEXT(Idx)>='A') && (obj.TEXT(Idx)<='Z')
          PROPS=[PROPS,obj.TEXT(Idx)]; %#ok
          Idx=Idx+1;
        elseif obj.TEXT(Idx)=='['
          return
        else
          return
        end
      end
      
    end
    
    function L = isNextSemicolon(obj)
      % check if the next symbol is semicolon
      
      if numel(obj.TEXT)==obj.I
        L=0;
        return;
      end
      idx=obj.I+1;
      while 1
        if isspace(obj.TEXT(idx))
          idx=idx+1;
        elseif(obj.TEXT(idx)==';')
          L=1;
          return
        elseif(obj.TEXT(idx)~=';')
          L=0;
          return
        end
      end
    end
    
    function L = isNextParen(obj)
      % check if the next symbol is paren
      
      if numel(obj.TEXT)==obj.I
        L=0;
        return;
      end
      
      Idx=obj.I+1;
      while Idx<=numel(obj.TEXT)
        if isspace(obj.TEXT(Idx))
          Idx=Idx+1;
        elseif (obj.TEXT(Idx)==')')
          L=1;
          return
        elseif(obj.TEXT(Idx)=='(')
          L=1;
          return
        else
          L=0;
          return
        end
      end
    end
    
    function splitMultiPROPS(obj)
      % Considering that it may exists cases like "B[]AB[]...AW[]AE[]" 
      % informal content, we must split into B[],AB[],AW[]and AE[] four
      % nodes in a direct line.
      
      S=obj.CURRENT_STONE;
      if(isempty(S.SGFPROPS)), return, end
      S.SGFPROPS=strtrim(S.SGFPROPS);
      if length(S.SGFPROPS)>1
        
        DIV = 1;
        for ii=2:length(S.SGFPROPS)
          if strcmp(S.SGFPROPS{ii},'AB')
            DIV = [DIV, ii]; %#ok
          elseif strcmp(S.SGFPROPS{ii},'AW')
            DIV = [DIV, ii]; %#ok
          elseif strcmp(S.SGFPROPS{ii},'AE')
            DIV = [DIV, ii]; %#ok
          end
        end
        
        SGFPROPS=S.SGFPROPS;
        SGFPROPVAL=S.SGFPROPVAL;
        
        if(length(DIV)>1)
          S.SGFPROPS=S.SGFPROPS(1:DIV(2)-1);
          S.SGFPROPVAL=S.SGFPROPVAL(1:DIV(2)-1);
          for jj=2:length(DIV)
            if(jj==length(DIV))
              e=length(SGFPROPS);
            elseif(jj<length(DIV))
              e=(DIV(jj+1)-1);
            end
            obj.CURRENT_STONE=addChild(obj.CURRENT_STONE);
            obj.CURRENT_STONE.SGFPROPS=SGFPROPS(DIV(jj):e);
            obj.CURRENT_STONE.SGFPROPVAL=SGFPROPVAL(DIV(jj):e);
          end
          
          % Be careful, subsitute the origin ancestor node as the current
          % son-node.
          if(obj.JustAddedBranch)
            obj.BRANCH{obj.CURRENT_DEPTH}{end}=obj.CURRENT_STONE;
          end
          
        end
        

        
      end
      
    end
    
    function prepareForProgressBar(obj)
      
      if isempty(obj.ProgressBar) || ~isvalid(obj.ProgressBar)
        createProgressBar(obj);
      end
      
      if(~obj.ShowProgressBar)
        delete(obj.ProgressBar);
        delete(obj.ProgressBarTimer);
      elseif(obj.ShowProgressBar)
        set(obj.ProgressBar,'Visible','on');
        obj.ProgressBarTimer = timer();
        obj.ProgressBarTimer.TimerFcn = {@monitorProgressFcn,obj};
        obj.ProgressBarTimer.ExecutionMode ='fixedRate';
        obj.ProgressBarTimer.Period = 0.2;
        obj.ProgressBarTimer.start();
      end
    end
    
    function createProgressBar(obj)
      % initialize the new progress bar
      
      fig = waitbar(0, 'Parsing SGF data...','Visible','off');
      obj.ProgressBar=fig;
      
    end
    
    function autoEncodingCheck(obj)
      % Executing simple auto-encoding check for the SGF file, reading the
      % first line which contains 'utf8' or 'gbk', then we catch them as
      % the encoding character.
      
      if(ischar(obj.Filename))
        if(exist(obj.Filename,'file')~=0)
          ecoding_guess='utf8';
          fid=fopen(obj.Filename,'r','native',ecoding_guess);
          o = onCleanup(@() fclose(fid));
          line=fgetl(fid);
          e=regexp(line,'CA\[(.*?)\]','tokens');
          if(~isempty(e))
            e=e{1}{1};
            obj.Encoding=e;
          end
        end
      end
      
    end
    
  end
  
  methods(Static)
    function props = getTotalFF4Props()
      props = {'B','KO','MN','W',...
        'AB','AE','AW','PL',...
        'C','DM','GB','GW','HO','N','UC','V',...
        'BM','DO','IT','TE',...
        'AR','CR','DD','LB','LN','MA','SL','SQ','TR',...
        'AP','CA','FF','GM','ST','SZ',...
        'AN','BR','BT','CP','DT','EV','GN','GC','ON','OT','PB','PC','PW',...
        'RE','RO','RU','SO','TM','US','WR','WT',...
        'BL','OB','OW','WL','FG','PM','VW'};
    end
    
  end
end

function monitorProgressFcn(~,~,obj)

progress=obj.I/obj.TEXTLENGTH;

message=sprintf('Parsing SGF data(%.2f%%)...',progress*100);
waitbar(progress,obj.ProgressBar,message);

end

function cleanup(h)

try stop(h); end %#ok
delete(h);

end