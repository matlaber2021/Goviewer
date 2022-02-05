classdef Stone < handle
% Stone object is the core data structure in the Goviewer. However, it can
% not only record the moved or added stone states, but also record
% non-stone states (the game info, and even the object has no substanive
% meaning as well). The object is designed from Smart-Go-Format Rule.
% 
% Stone object is handle class having parent and children properties. And 
% it has also some basic SGF properties which can parsed by SGFParser 
% method from SGFReader handle object.
%
% To initalize the Stone, type "obj = Stone();" Remember that obj is the
% root object with no parents.
%
% Example
% % Add the child from the obj
% obj = Stone();
% newstone = addChild(obj);
%
% % DO-NOT use this !
% obj.children = Stone();
%
% Notice
% The Stone object data structure may be quite complex to read when reading
% from some huge *.sgf files.

  properties(AbortSet,SetObservable)
    parent          % the only parent stone
    children        % the children stones
    status = 0;     % 0:none 1:moved-stone 2:added-stone
    side = [];      % 1:black 2:white []|0: none
    position = [];  % the position[s] of the stone, 
    order = 0;      % the order of stone, giving priority to MN SGF property
  end
    
  % properties from SGF infomation
  properties(Hidden=true)
    comment char    % C[*]
    move_number     % MN[*]
    note = [];      % N[*]
    label = '';     % LB[*]
    dim             % DD[*]
    view            % VM[*]
    triangle        % TR[*]
    circle          % CR[*]
    selected        % SL[*]
    mark            % MR[*]  
    square          % SR[*]
    arrow           % AR[*] 
    line            % LN[*]
    territory_black % TB[*]
    territory_white % TW[*] 
  end
  
  properties(Hidden=true,AbortSet,SetObservable)
    pRemovedStone               % the pos of prisoner
    pClearedStone               % the pos of cleared stone
    sClearedStone               % the side of cleared stone
    SGFPROPS                    % SGF props
    SGFPROPVAL                  % SGF property values
    SGFEXCEPTION                % the unparsed SGF infomation
    HasBeenPlayedOnBoard = 0;   % has been played on board
    ShownInTreeNode = 0;        % be shown in the treenode
    TreeNode                    % treenode of which
  end
  
  methods(Static)
    function obj = init()
      % The initial state of the stone tree structure is the root tree
      % contains one gameinfo Stone data.
      
      obj = Stone();
      addStone(obj,[],[]);
      obj.children.status=0;
      setDefaultGameInfo(obj);
      obj=obj.children(1);
      
    end
  end
  
  methods
    function obj = Stone(sz)
      % build an intial Stone object
      
      if nargin==0
        return
      end
      
      if isscalar(sz)
        sz = [sz,sz];
      end
      
      m=sz(1);
      n=sz(2);
      
      if m==0||n==0
        obj = repmat(Stone(),[m,n]);
        return
      end
      
      for i = 1:m
        for j = 1:n
          obj(i,j) = Stone(); %#ok
        end
      end
      
    end
  end
  
  
  methods
    
    function newstone = addChild(obj)
      % add the child stone of the current stone
      
      newstone = moveStone(obj,0,[]);
      
    end
    
    function newstone = addStone(obj,s,p)
      % add an added initial stone of the current stone.
      
      newstone = Stone();
      setPropVal(newstone,'status',2); % 1:move 2:add
      setPropVal(newstone,'side',s);
      setPropVal(newstone,'position',p);
      setPropVal(newstone,'parent',obj);
      setPropVal(newstone,'order',newstone.parent.order);
      
    end
    
    
    function newstone = moveStone(obj,s,p)
      % move from the current stone
      
      % record the new moved stone, but with no visiual effect.
      newstone = Stone();
      setPropVal(newstone,'status',1); % 1:move 2:add
      setPropVal(newstone,'side',s);
      setPropVal(newstone,'position',p);
      setPropVal(newstone,'parent',obj);
      
    end
    
  end
  
  methods
    function setPropVal(obj,varargin)
      for i = 1:2:length(varargin)
        obj.(varargin{i}) = varargin{i+1};
        if strcmp(varargin{i},'parent')
          if isa(varargin{i+1},'Stone')
            obj.parent.children = [obj.parent.children; obj];
          end
        elseif strcmp(varargin{i},'children')
          if isa(varargin{i+1},'Stone')
            obj.children(end).parent = obj;
          end
        end
      end
    end
    
    function root = findAncestor(obj)
      % find out the root Stone.
      
      root = obj;
      while ~isempty(root.parent)
        root = root.parent;
      end
    end% findAncestor
    
    function [branch,idx,L] = findLastBranch(obj)
      % Find the last branch, not contains self.
      %
      % Output
      % branch: the last branch
      % L: the distance between the branch and the object self.
      % idx: obj is in the <idx>th branch.
      
      idx=1; % initialize index
      L = 0;
      branch=obj;
      while(1)
        branch0=branch;
        branch=branch.parent;
        if(isempty(branch))
          L=0;
          branch=[];
          return
        end
        L=L+1;
        N = length(branch.children);
        if(N>1)
          for i=1:N
            if(isequal(branch.children(i),branch0))
              idx=i;
              break
            end
          end
          break
        end
      end
      
    end % findLastBranch
    
    function deleteStone(obj)
      % Delete the Stone and its offspring.
      
      % destory the offspring of object.
      son = findall(obj);
      for i = 1:length(son)
        delete(son(i).TreeNode);
        delete(son(i));
      end
      
      % destory itself
      o1 = onCleanup(@() delete(obj.TreeNode));
      o2 = onCleanup(@() delete(obj));
      
      % cut off the membership of it
      if ~isempty(obj.parent)
        c = obj.parent.children;
        N = numel(c);
        for i = N:-1:1
          if isequal(c(i),obj)
            c(i) = [];
          end
        end
        obj.parent.children = c;
        obj.parent = [];
      end
    end% deleteStone
    
    function [newstone,down] = findNextStone(obj)
      % Find the next stone, using preorder-traversal way.
      
      down=0;
      if ~isempty(obj.children)
        newstone=obj.children(1);
        return
      end
      
      [branch,idx,L]=findLastBranch(obj); %#ok
      
      if isempty(obj.children)
        if isempty(branch)
          newstone=[];
          return
        end
      end
      
      num=length(branch.children);
      if isempty(obj.children)
        if ~isempty(branch)
          
          down=down+1;
          
          if(idx==num)
            
            branch0=branch;
            
            while(1)
              [branch0,idx0,L0]=findLastBranch(branch0); %#ok
              if(isempty(branch0))
                newstone=[];
                break
              end
              
              if(~isempty(branch0))
                down=down+1;
                num0=length(branch0.children);
                if(idx0==num0)
                  continue;
                elseif(idx0<num0)
                  newstone=branch0.children(idx0+1);
                  break
                end
              end
              
            end
            
          elseif(idx<num)
            newstone=branch.children(idx+1);
          end
        end
      end
      
    end% findNextStone
    
    function h = findall(obj)
      % findall, like allchild function used on the graphic object. 
      % Display all the descendant of the current object.
      
      % BUGFIX
      h = [];
      c = obj.children;
      h = [h; obj.children];
      if isempty(c), return; end
      for i = 1:length(c)
        if isa(c(i),'Stone')
          
          add = findall(c(i)); % BUGFIX
          h = [h; add]; %#ok
        end
      end
    end % findall
    
    function ok = isDirectLine(A,B)
      % Decide if A and B are on the same direct line.
      
      ok=0;
      O=A;
      while ~isempty(O)
        O=O.parent;
        if isequal(O,B)
          ok=1;
          return
        end
        
      end
    end% isDirectLine
    
    function showSGFInfo(obj)
      % show the SGF infomation
      
      if(~isempty(obj.SGFPROPS))
        args=[obj.SGFPROPS;obj.SGFPROPVAL];
        fprintf(1,'%s%s',args{:});
        fprintf(1,'\n');
      end
      
    end % showSGFInfo
    
    function str = displaySGFInfo(obj)
      % display the SGF infomation
      
      if(~isempty(obj.SGFPROPS))
        args=[obj.SGFPROPS;obj.SGFPROPVAL];
        str = sprintf('%s%s',args{:});
      else
        str = '';
      end
      
    end% displaySGFInfo
    
    function refreshOrderProp(obj)
      % update the Stone order property value.
      
      if(~isempty(obj.move_number))
        if(~isnan(obj.move_number))
          obj.order=obj.move_number;
          return
        end
      end
      [~,idx,L] = findLastBranch(obj);
      
      if(obj.status==1)
        if(obj.side>0)
          if(idx==1)
            obj.order=obj.parent.order+1;
          elseif(idx>1)
            if(L==1)
              obj.order=1;
            elseif(L>1)
              obj.order=obj.parent.order+1;
            end
          end
        end
      end
      
      if (obj.status==2)||(isequal(obj.side,0))
        if(idx==1)
          obj.order=obj.parent.order; % BUGFIX
        elseif(idx>1)
          obj.order=0;
        end
      end
      
      % BUGFIX: AE=0
      if(obj.status==2)
        if(obj.side==0)
          obj.order=0;
        end
      end
      
    end % refreshOrderProp
    
    function SGFInfoSyncFun(obj,option)
      % SGF information synchronous function
      %
      % option
      % =============
      % +1: side,position,status,...=>SGFInfo
      % -1: SGFPROP/SGFPROPVAL => side,position,status,order...
      
      % Update log
      % 2022/1/10       Add "AE" props.
      % 2022/1/12       Add "N" props.
      % 2022/1/22       Rearrange the function.
      
      o = onCleanup(@() handleInvalidPositionProp(obj) );
      
      if(option==-1)
        importSGFInfo(obj);
        reserveSGFException(obj);
      end
      
      if(option==1)
        if(isempty(obj.SGFPROPS))
          createSGFInfo(obj);
        end
      end
      
      if(option==1)
        if(~isempty(obj.SGFPROPS))
          updateSGFInfo(obj);
        end
      end
      
    end % SGFInfoSyncFun
    
    function handleInvalidPositionProp(obj)
      % For historical reason, maybe the pass position for moved stone is
      % [tt], so it is invalid for the 19x19 board size, so delete the
      % position property, or exception occured.
      
      if(~isempty(obj.position))
        for i=1:size(obj.position,1)
          if(obj.position(i,1)>19||obj.position(i,1)<1)
            fprintf(2,'Found invalid moves.\n');
            fprintf(2,'SGF message shows: "%s".\n', obj.displaySGFInfo());
            obj.position=[];
            break
          end
          if(obj.position(i,2)>19||obj.position(i,2)<1)
            fprintf(2,'Found invalid moves.\n');
            fprintf(2,'SGF message shows: "%s".\n', obj.displaySGFInfo());
            obj.position=[];
            break
          end
        end
      end
    end % handleInvalidPositionProp
    
    function importSGFInfo(obj)
      % Import SGF file, parse the original SGF infomation to the MATLAB
      % acceptable property in order to do moves or adds step.
      
      if(~isempty(obj.SGFPROPS))
        obj.SGFPROPS=strtrim(obj.SGFPROPS); % BUGFIX
        if(~isempty(obj.SGFPROPVAL))
          for idx=1:length(obj.SGFPROPS)
            switch(obj.SGFPROPS{idx})
              case {'B'}
                obj.status=1;
                obj.side=1;
                obj.position=lower(obj.SGFPROPVAL{idx}(end-1:-1:2))-96;
              case {'W'}
                obj.status=1;
                obj.side=2;
                obj.position=lower(obj.SGFPROPVAL{idx}(end-1:-1:2))-96;
                
              case {'AE'}
                obj.status=2;
                obj.side=0;
                obj.pClearedStone=[];
                P=lower(obj.SGFPROPVAL{idx});
                P=regexprep(P,'\s','');
                match=regexp(P,'\[[\w|:]*?\]','match');
                obj.position=[];
                for jj=1:length(match)
                  if(~contains(match{jj},':'))
                    obj.pClearedStone(end+1,:)=match{jj}(end-1:-1:2)-96;
                  else
                    for k=(match{jj}(2)-96):(match{jj}(5)-96)
                      for l=(match{jj}(3)-96):(match{jj}(6)-96)
                        obj.pClearedStone(end+1,:)=[l,k];
                      end
                    end
                  end
                end
                
                % We don't know the color of the cleared stone, so set
                % sClearedStone to save data and restore when triggering
                % backwardfun function.
                obj.sClearedStone=[];
                
              case {'AB'}
                obj.status=2;
                obj.side=1;
                P=lower(obj.SGFPROPVAL{idx});
                P=regexprep(P,'\s','');
                match=regexp(P,'\[[\w|:]*?\]','match');
                obj.position=[];
                for jj=1:length(match)
                  if(~contains(match{jj},':'))
                    obj.position(end+1,:)=match{jj}(end-1:-1:2)-96;
                  else
                    for k=(match{jj}(2)-96):(match{jj}(5)-96)
                      for l=(match{jj}(3)-96):(match{jj}(6)-96)
                        obj.position(end+1,:)=[l,k];
                      end
                    end
                  end
                end
              case {'AW'}
                obj.status=2;
                obj.side=2;
                P=lower(obj.SGFPROPVAL{idx});
                P=regexprep(P,'\s','');
                match=regexp(P,'\[[\w|:]*?\]','match');
                obj.position=[];
                for jj=1:length(match)
                  if(~contains(match{jj},':'))
                    obj.position(end+1,:)=match{jj}(end-1:-1:2)-96;
                  else
                    for k=(match{jj}(2)-96):(match{jj}(5)-96)
                      for l=(match{jj}(3)-96):(match{jj}(6)-96)
                        obj.position(end+1,:)=[l,k];
                      end
                    end
                  end
                end
              case {'C'}
                obj.comment=obj.SGFPROPVAL{idx}(2:end-1);
              case {'MN'}
                obj.move_number=str2double(obj.SGFPROPVAL{idx}(2:end-1));
              case {'N'}
                obj.note=obj.SGFPROPVAL{idx}(2:end-1);
              case {'LB'}
                % LB[nb:A][pb:B]
                obj.label = obj.SGFPROPVAL{idx};
              case {'DD'}
                obj.dim = obj.SGFPROPVAL{idx};
              case {'TR'}
                obj.triangle = obj.SGFPROPVAL{idx};
              case {'CR'}
                obj.circle = obj.SGFPROPVAL{idx};
              case {'SQ'}
                obj.square = obj.SGFPROPVAL{idx};
              case {'SL'}
                obj.selected = obj.SGFPROPVAL{idx};
              case {'MA'}
                obj.mark = obj.SGFPROPVAL{idx};
              case {'AR'}
                obj.arrow = obj.SGFPROPVAL{idx};
              case {'LN'}
                obj.line = obj.SGFPROPVAL{idx};
              case {'TB'}
                obj.territory_black = obj.SGFPROPVAL{idx};
              case {'TW'}
                obj.territory_white = obj.SGFPROPVAL{idx};
            end
          end
          refreshOrderProp(obj); %
        end
      end
    end % importSGFInfo
    
    function reserveSGFException(obj)
      % Reserve the unparsed SGF markers.
      
      if(~isempty(obj.SGFPROPS))
        
        SGFPROPS=strtrim(obj.SGFPROPS); %#ok
        [~,p1,p2] = intersect(SGFPROPS,...
          {'B','W','AE','AB','C','MN','N','LB','DD',...
          'TR','CR','SQ','SL','MA','AR','LN','TW','TB'},'stable');%#ok
        data=[obj.SGFPROPS;obj.SGFPROPVAL];
        data(:,p1)=[];
        obj.SGFEXCEPTION=[data{:}];
        
      end
      
    end% reserveSGFException
    
    function createSGFInfo(obj)
      % When the SGFPROPS is empty, build new SGFPROPS and SGFPROPVAL.
      
      o = onCleanup(@() cleanupSGFInfo(obj));
      if(isempty(obj.SGFPROPS))
        if(isempty(obj.SGFPROPVAL))
          
          if(obj.status==1) % moved stone
            if(obj.side==1)
              obj.SGFPROPS={'B'};
              obj.SGFPROPVAL={sprintf('[%s]',char(obj.position(2:-1:1)+96))};
              obj.SGFPROPVAL=lower(obj.SGFPROPVAL);
            elseif(obj.side==2)
              obj.SGFPROPS={'W'};
              obj.SGFPROPVAL={sprintf('[%s]',char(obj.position(2:-1:1)+96))};
              obj.SGFPROPVAL=lower(obj.SGFPROPVAL);
            end
          elseif(obj.status==2) % added stone
            if(~isempty(obj.position))
              if(obj.side==1)
                obj.SGFPROPS={'AB'};
                format=repmat('[%s]',[1,size(obj.position,1)]);
                args=num2cell(obj.position,2);
                args=cellfun(@(x)char(x(2:-1:1)+96),args,'UniformOutput',0);
                %args=lower(args); %BUGFIX
                obj.SGFPROPVAL={sprintf(format,args{:})};
              elseif(obj.side==2)
                obj.SGFPROPS={'AW'};
                format=repmat('[%s]',[1,size(obj.position,1)]);
                args=num2cell(obj.position,2);
                args=cellfun(@(x)char(x(2:-1:1)+96),args,'UniformOutput',0);
                %args=lower(args);
                obj.SGFPROPVAL={sprintf(format,args{:})};
              elseif(obj.side==0) % AE
                obj.SGFPROPS={'AE'};
                format=repmat('[%s]',[1,size(obj.pClearedStone,1)]);
                args=num2cell(obj.pClearedStone,2);
                %args=lower(args);
                args=cellfun(@(x)char(x(2:-1:1)+96),args,'UniformOutput',0);
                obj.SGFPROPVAL={sprintf(format,args{:})};
              end
            end
          end
          
          if(~isempty(obj.comment))
            if(ischar(obj.comment))
              obj.SGFPROPS{end+1}={'C'};
              obj.SGFPROPVAL{end+1}=sprintf('[%s]',obj.comment);
            end
          end
          
        end
      end
      
    end % createSGFInfo
    
    
    function updateSGFInfo(obj)
      % The SGFPROPS exists, if you change the property of Stone, SGFPROPS
      % and SGFPROPVAL need to make an adjustment.
      
      o = onCleanup(@() cleanupSGFInfo(obj));
      if(~isempty(obj.SGFPROPS))
        if(~isempty(obj.SGFPROPVAL))
          
          SGFPROPS = strtrim(obj.SGFPROPS); %#ok
          
          % Move Stone
          if(obj.status==1)
            if(obj.side==1)
              pos=strcmp(SGFPROPS,'B'); %#ok
            elseif(obj.side==2)
              pos=strcmp(SGFPROPS,'W'); %#ok
            elseif(obj.side==0)
              pos=[]; % Nothing to do.
            end
            
            if(any(pos))
              PROPVAL0=obj.SGFPROPVAL{pos};
              X=char(obj.position(2)+96);
              Y=char(obj.position(1)+96);
              PROPVAL1=sprintf('[%s%s]',X,Y);
              if(~isequal(strtrim(PROPVAL0),PROPVAL1))
                obj.SGFPROPVAL{pos}=PROPVAL1;
              end
            end
            
            % If not having SGFPROPS, it means that the black stone is
            % replaced by the white stone, which is not allowed, thus throw
            % exception.
            if(~any(pos) && ~isempty(pos))
              error('Error for updating SGF information on moved stone.');
            end
            
          end
          
          % AB
          if(obj.status==2)
            if(obj.side==1)
              pos=strcmp(SGFPROPS,'AB'); %#ok
              if(any(pos))
                N=size(obj.position,1);
                
                % In AB or AW case, position property must not empty,
                % otherwise error out.
                if(N==0)
                  error('In AB/AW case, position is empty.');
                end
                
                PROPVAL0=obj.SGFPROPVAL{pos};
                PROPVAL1='';
                for idx=1:N
                  X=char(obj.position(idx,2)+96);
                  Y=char(obj.position(idx,1)+96);
                  temp=sprintf('[%s%s]',X,Y);
                  PROPVAL1=[PROPVAL1, temp]; %#ok
                end
                
                % Maybe the position dont change but order changed, still
                % be considered as modification.
                if(~isequal(PROPVAL0,PROPVAL1))
                  obj.SGFPROPVAL{pos}=PROPVAL1;
                end
                
              end
            end
          end
          
          % AW
          if(obj.status==2)
            if(obj.side==2)
              pos=strcmp(SGFPROPS,'AW'); %#ok
              if(any(pos))
                N=size(obj.position,1);
                
                % In AB or AW case, position property must not empty,
                % otherwise error out.
                if(N==0)
                  error('In AB/AW case, position is empty.');
                end
                
                PROPVAL0=obj.SGFPROPVAL{pos};
                PROPVAL1='';
                for idx=1:N
                  X=char(obj.position(idx,2)+96);
                  Y=char(obj.position(idx,1)+96);
                  temp=sprintf('[%s%s]',X,Y);
                  PROPVAL1=[PROPVAL1, temp]; %#ok
                end
                
                % Maybe the position dont change but order changed, still
                % be considered as modification.
                if(~isequal(PROPVAL0,PROPVAL1))
                  obj.SGFPROPVAL{pos}=PROPVAL1;
                end
                
              end
            end
          end
          
          % AE
          if(obj.status==2)
            if(obj.side==0)
              pos=strcmp(SGFPROPS,'AE'); %#ok
              if(any(pos))
                N=size(obj.position,1);
                
                PROPVAL0=obj.SGFPROPVAL{pos};
                PROPVAL1='';
                for idx=1:N
                  X=char(obj.position(idx,2)+96);
                  Y=char(obj.position(idx,1)+96);
                  temp=sprintf('[%s%s]',X,Y);
                  PROPVAL1=[PROPVAL1, temp]; %#ok
                end
                
                % For AE stone, maybe there is no stones to be cleared, so
                % the default PROPVAL is [].
                if(~isempty(PROPVAL1))
                  PROPVAL1='[]';
                end
                
                if(~isequal(PROPVAL0,PROPVAL1))
                  obj.SGFPROPVAL{pos}=PROPVAL1;
                end
                
              end
            end
          end
          
          %%% General PROPS %%%
          
          % Move Number
          PROPVAL1=sprintf('[%d]',obj.move_number);
          pos=strcmp(SGFPROPS,'MN'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='MN';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % Comment
          PROPVAL1=sprintf('[%s]',obj.comment);
          pos=strcmp(SGFPROPS,'C'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='C';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % Note
          PROPVAL1=sprintf('[%s]',obj.note);
          pos=strcmp(SGFPROPS,'N'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='N';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % Label: Because label has multi bracket pairs, so the label
          % property is exactly the PROPVAL for LB.
          PROPVAL1=deal(obj.label);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'LB'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='LB';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % Dim
          PROPVAL1=deal(obj.dim);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'DD'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='DD';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % triangle
          PROPVAL1=deal(obj.triangle);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'TR'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='TR';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % circle
          PROPVAL1=deal(obj.circle);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'CR'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='CR';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % square
          PROPVAL1=deal(obj.square);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'SQ'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='SQ';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % selected points
          PROPVAL1=deal(obj.selected);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'SL'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='SL';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % triangle
          PROPVAL1=deal(obj.triangle);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'TR'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='TR';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % MARK
          PROPVAL1=deal(obj.mark);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'MA'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='MA';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % ARROW
          PROPVAL1=deal(obj.arrow);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'AR'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='AR';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
          % Line
          PROPVAL1=deal(obj.line);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'LN'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='LN';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end

          % Black territory
          PROPVAL1=deal(obj.line);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'TB'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='TB';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end

          % White territory
          PROPVAL1=deal(obj.line);
          if(isempty(PROPVAL1)), PROPVAL1='[]'; end
          pos=strcmp(SGFPROPS,'TW'); %#ok
          if(any(pos))
            obj.SGFPROPVAL{pos}=PROPVAL1;
          elseif(~any(pos))
            obj.SGFPROPS{end+1}='TW';
            obj.SGFPROPVAL{end+1}=PROPVAL1;
          end
          
        end
      end
      
    end % updateSGFInfo
    
    function cleanupSGFInfo(obj)
      % Clean up the SGF infomation
      
      if(~isempty(obj.SGFPROPS))
        N=numel(obj.SGFPROPS);
        for idx=N:-1:1
          switch strtrim(obj.SGFPROPS{idx})
            case {'B','W'}
              % [] means pass, can not remove
            case {'AB','AW','AE'}
              PROPVAL=regexprep(obj.SGFPROPVAL{idx},'\s','');
              if(isequal(PROPVAL,'[]'))
                obj.SGFPROPS(idx)=[];
                obj.SGFPROPVAL(idx)=[];
              end
            case {'LB','MN','TR','CR','SQ','SL','MA','TB','TW',...
                'DD','VW','AR','LN'}
              PROPVAL=regexprep(obj.SGFPROPVAL{idx},'\s','');
              if(isequal(PROPVAL,'[]'))
                obj.SGFPROPS(idx)=[];
                obj.SGFPROPVAL(idx)=[];
              end
              % In the note and comment symbol, leaving a blank space can
              % also work, so deleting the space outside the bracket pair.
            case {'C','N'}
              PROPVAL=strtrim(obj.SGFPROPVAL{idx});
              if(isequal(PROPVAL,'[]'))
                obj.SGFPROPS(idx)=[];
                obj.SGFPROPVAL(idx)=[];
              end
            otherwise
              PROPVAL=regexprep(obj.SGFPROPVAL{idx},'\s','');
              if(isequal(PROPVAL,'[]'))
                obj.SGFPROPS(idx)=[];
                obj.SGFPROPVAL(idx)=[];
              end
          end
        end
        
      end
      
    end% cleanupSGFInfo
    
    function [p,nth] = getParent(obj)
      % Find the parent object and also find-out the nth children of it.
      % The submethod for getStoneRoute.
      %
      % Output
      % p: the parent Stone object of obj
      % nth: obj is the nth children of p, default as 1 even if p is empty
      
      p=obj.parent;
      nth=1;
      
      if(~isempty(p))
        c=p.children;
        for idx=1:length(c)
          if(isequal(obj,c(idx)))
            nth=idx;
            break
          end
        end
      end
      
    end
    
    
    function route=getStoneRoute(origin,destination)
      % Find the route from the origin point to the target point, build
      % this function in order to prepare for moving back and forth from
      % two different tree-nodes, the route algorithm is low-efficient,
      % maybe optimized in the future, which based on the pratical results.
      %
      % Input and Output
      % origin: the origin Stone
      % destination: the target Stone
      % route: is a route struct with fields of direction and index.
      
      direction1=[];
      index1=[];
      node=origin;
      while(1)
        if isempty(node.parent)
          break
        end
        [node,nth]=getParent(node);
        direction1(end+1,1)=-1; %#ok
        index1(end+1,1)=nth; %#ok
      end
      
      direction2=[];
      index2=[];
      node=destination;
      while(1)
        if isempty(node.parent)
          break
        end
        [node,nth]=getParent(node);
        direction2(end+1,1)=+1; %#ok
        index2(end+1,1)=nth; %#ok
      end
      
      route.direction=[direction1;direction2(end:-1:1)];
      route.index=[index1;index2(end:-1:1)];
      
    end
    
    function setDefaultGameInfo(obj)
      % Set the default sgf game info on the root.
      %
      % CA[utf8]
      % AP[Goviewer]
      % SZ[19]
      % PB[]
      % PW[]
      % RE[]
      % KM[]
      % C[]
      % N[]
      
      obj=findAncestor(obj);
      o=onCleanup(@() cleanupSGFInfo(obj.children(1)));
      if(~isempty(obj))
        obj.children(1).SGFPROPS={'CA','AP','SZ','PB','PW','RE','KM','C','N'};
        obj.children(1).SGFPROPVAL={'[utf8]','[Goviewer]','[19]','[]',...
          '[]','[]','[]','[]','[]'};
      end
    end
    
  end
  
end