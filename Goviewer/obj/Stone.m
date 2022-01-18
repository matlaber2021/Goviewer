classdef Stone < handle
  
  properties(AbortSet,SetObservable)
    parent          % 前落子
    children        % 后落子
    status = 0;     % ?
    side = [];      % 落子方
    position = [];  % 落子位置
    order = 0;      % 落子序号（初始化0）
    comment         char
    move_number     % MN属性
    note = [];      % 
    label = '';     % 
  end
  
  properties(Hidden=false,AbortSet,SetObservable)
    pRemovedStone   % 提子位置
    pClearedStone   % 清子位置 UPDATE
    sClearedStone   % 清子方   UPDATE
    SGFPROPS        %
    SGFPROPVAL      %
    HasBeenPlayedOnBoard = 0;  % 是否棋盘上摆过
    ShownInTreeNode = 0;
    TreeNode
  end
  
  methods(Static) 
    function obj = init()
      
      obj = Stone();
      addStone(obj,[],[]);
      obj.children.status=0;
      setDefaultGameInfo(obj);
      obj=obj.children(1);
      
    end
  end
  
  methods
    function obj = Stone(sz)
      % 创建初始棋子对象
      
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
      % 添加obj.children对象
      
      newstone = moveStone(obj,0,[]);
      
    end
    
    function newstone = addStone(obj,s,p)
      % 创建新棋子对象
      
      newstone = Stone();
      setPropVal(newstone,'status',2); % 1:move 2:place
      setPropVal(newstone,'side',s);
      setPropVal(newstone,'position',p);
      setPropVal(newstone,'parent',obj);
      setPropVal(newstone,'order',newstone.parent.order);
      
    end
    
    
    function newstone = moveStone(obj,s,p)
      % 创建新落子对象
      
      % 记录落子对象，该函数并不起视觉效果
      newstone = Stone();
      setPropVal(newstone,'status',1); % 1:move 2:place
      setPropVal(newstone,'side',s);
      setPropVal(newstone,'position',p);
      setPropVal(newstone,'parent',obj);
      
      % 如果刚开始创建新建分支，新分支的序号重新设定为1
      % 如果单一承接上一棋子，则序号递增
      %if s~=0
      %  if ~isempty(obj.children)
      %    if length(obj.children)>1
      %      setPropVal(newstone,'order',1);
      %    else
      %      setPropVal(newstone,'order',obj.order+1);
      %    end
      %  end
      %end
      
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
      %branch = obj.parent;
      %branch0 = [];
      %if isempty(branch), return, end
      %L=1;
      %while isscalar(branch.children) && ~isempty(branch.parent)
      %  branch0 = branch;
      %  branch = branch.parent;
      %  L = L+1;
      %end
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
        delete(son(i));
      end
      
      % destory itself
      o = onCleanup(@() delete(obj));
      
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
    
    % % 如果找到第i个直系，则定义下一棋子对象是分支
    % % 的第i+1个children
    % for i = 1:num
    %  comp=branch.children(i);
    %  ok = isDirectLine(obj,comp);
    %  if ok==1
    %    if(i==num)
    %      newstone=[];
    %      return
    %    elseif(i<num)
    %      newstone=branch.children(i+1);
    %      return
    %    end
    %  end
    %end
    
    function h = findall(obj)
      % 找到所有子节点（不包括本身）
      
      % BUG(多分支)
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
      % 判断是否是直系亲属
      
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
      % 展示SGF信息
      
      if(~isempty(obj.SGFPROPS))
        args=[obj.SGFPROPS;obj.SGFPROPVAL];
        fprintf(1,'%s%s',args{:});
        fprintf(1,'\n');
      end
      
    end % showSGFInfo
    
    function str = displaySGFInfo(obj)
      %
      
      if(~isempty(obj.SGFPROPS))
        args=[obj.SGFPROPS;obj.SGFPROPVAL];
        str = sprintf('%s%s',args{:});
      else
        str = '';
      end
      
    end% displaySGFInfo
    
    %function updateOrderProp(obj)
    %  % 更新棋子的顺序
    %  
    %  if isempty(obj.children)
    %    return
    %  end
    %  
    %  if isscalar(obj.children)
    %    obj.children.order=obj.order+1;
    %    updateOrderProp(obj.children);
    %    return
    %  end
    %  
    %  for i = 1:length(obj.children)
    %    if i==1
    %      obj.children(1).order=obj.order+1;
    %      updateOrderProp(obj.children(1));
    %      return
    %    elseif i>1
    %      obj.children(i).order=1;
    %      updateOrderProp(obj.children(i));
    %    end
    %  end
    %  
    %end
    
    function refreshOrderProp(obj)
      % 更新棋子的顺序
      
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
      % SGFInfo同步函数
      %
      % option
      % =============
      % +1: side,position,status,...=>SGFInfo
      % -1: SGFPROP/SGFPROPVAL => side,position,status,order...
      
      % Update log
      % 2022/1/10       Add "AE" props. 
      % 2022/1/12       Add "N" props.
      
      if(option==-1)
        if(~isempty(obj.SGFPROPS))
          obj.SGFPROPS=strtrim(obj.SGFPROPS); % BUGFIX
          if(~isempty(obj.SGFPROPVAL))
            for idx=1:length(obj.SGFPROPS)
              switch(obj.SGFPROPS{idx})
                case {'B'}
                  obj.status=1;
                  obj.side=1;
                  obj.position=[upper(obj.SGFPROPVAL{idx}(end-1))-64,...
                    upper(obj.SGFPROPVAL{idx}(2))-64];
                case {'W'}
                  obj.status=1;
                  obj.side=2;
                  obj.position=[upper(obj.SGFPROPVAL{idx}(end-1))-64,...
                    upper(obj.SGFPROPVAL{idx}(2))-64];
                  
                % 
                case {'AE'}
                  obj.status=2;
                  obj.side=0;
                  obj.pClearedStone=[];
                  P=upper(obj.SGFPROPVAL{idx});
                  P=regexprep(P,'\s','');
                  match=regexp(P,'\[\w*?\]','match');
                  obj.position=[];
                  for jj=1:length(match)
                    obj.pClearedStone(end+1,:)=flip(match{jj}(2:end-1)-64);
                  end
                  
                  % 因为不知道清除的落子颜色，用该属性进行存储与恢复
                  obj.sClearedStone=[];
                  
                case {'AB'}
                  obj.status=2;
                  obj.side=1;
                  P=upper(obj.SGFPROPVAL{idx});
                  P=regexprep(P,'\s','');
                  match=regexp(P,'\[\w*?\]','match');
                  obj.position=[];
                  for jj=1:length(match)
                    obj.position(end+1,:)=flip(match{jj}(2:end-1)-64);
                  end
                case {'AW'}
                  obj.status=2;
                  obj.side=2;
                  P=upper(obj.SGFPROPVAL{idx});
                  P=regexprep(P,'\s','');
                  match=regexp(P,'\[\w*?\]','match');
                  obj.position=[];
                  for jj=1:length(match)
                    obj.position(end+1,:)=flip(match{jj}(2:end-1)-64);
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
              end
            end
            refreshOrderProp(obj); %
          end
        end
      end
      
      if(option==1)
        if(isempty(obj.SGFPROPS))
          if(isempty(obj.SGFPROPVAL))
            
            if(obj.status==1) % moved stone
              if(obj.side==1)
                obj.SGFPROPS={'B'};
                obj.SGFPROPVAL={sprintf('[%s]',char(obj.position(end:-1:1)+64))};
                obj.SGFPROPVAL=lower(obj.SGFPROPVAL);
              elseif(obj.side==2)
                obj.SGFPROPS={'W'};
                obj.SGFPROPVAL={sprintf('[%s]',char(obj.position(end:-1:1)+64))};
                obj.SGFPROPVAL=lower(obj.SGFPROPVAL);
              end
            elseif(obj.status==2) % added stone
              if(~isempty(obj.position))
                if(obj.side==1)
                  obj.SGFPROPS={'AB'};
                  format=repmat('[%s]',[1,size(obj.position,1)]);
                  args=num2cell(obj.position,2);
                  args=cellfun(@(x)char(x(end:-1:1)+64),args,'UniformOutput',0);
                  args=lower(args); %BUGFIX
                  obj.SGFPROPVAL={sprintf(format,args{:})};
                elseif(obj.side==2)
                  obj.SGFPROPS={'AW'};
                  format=repmat('[%s]',[1,size(obj.position,1)]);
                  args=num2cell(obj.position,2);
                  args=cellfun(@(x)char(x(end:-1:1)+64),args,'UniformOutput',0);
                  args=lower(args);
                  obj.SGFPROPVAL={sprintf(format,args{:})};
                elseif(obj.side==0) % AE
                  obj.SGFPROPS={'AE'};
                  format=repmat('[%s]',[1,size(obj.pClearedStone,1)]);
                  args=num2cell(obj.pClearedStone,2);
                  args=lower(args);
                  args=cellfun(@(x)char(x(end:-1:1)+64),args,'UniformOutput',0);
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
      end
      
      % BUGFIX
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
      
    end % SGFInfoSyncFun
    
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
      if(~isempty(obj))
        obj.children(1).SGFPROPS={'CA','AP','SZ','PB','PW','RE','KM','C','N'};
        obj.children(1).SGFPROPVAL={'[utf8]','[Goviewer]','[19]','[]',...
          '[]','[]','[]','[]','[]'};
      end
    end
    
  end
  
end