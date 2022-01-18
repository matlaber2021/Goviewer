classdef UserDataManager < handle
  
  properties
    CONFIG      % 棋盘配置信息
    DATA        % 棋盘数据
    WINDOW      % 弹窗信息
    JUDGMENT    % 棋局胜负判断数据
    LEELAZERO   % LeelaZero数据
    GAMERESULT  % LeelaZero对局胜负
  end
  
  properties(Hidden)
    OPTIONSET_LEELAZERO % LeelaZero设置
    SKIP_TREENODE = 0;
  end
  
  methods
    
    function obj = UserDataManager(S)
      % 生成用户数据管理对象
      %
      % obj = UserDataManager()  % 新建用户数据管理对象
      % obj = UserDataManager(S) % 将结构体S转换成数据管理对象
      
      if nargin>0
        if isstruct(S)
          obj = UserDataManager();
          props = properties(obj);
          f = fieldnames(S);
          for i = 1:length(f)
            if any(strcmp(f{i},props))
              prop = f{i};
              obj.(prop) = S.(f{i});
            end
          end
        end
      end
      
    end
    
    function setPropValDATA(obj,prop,val)
      % 设置用户信息的属性值
      
      setPropValPrivFcn(obj,'DATA',prop,val);
    end
    
    function addPropDATA(obj,prop)
      % 添加用户属性信息
      
      addPropPrivateFcn(obj,'DATA',prop);
    end
    
    function delPropDATA(obj,prop)
      % 删除用户数据的属性
      
      delPropPrivateFcn(obj,'DATA',prop);
    end
    
    function setPropValCONFIG(obj,prop,val)
      % 设置用户信息的属性值
      
      setPropValPrivFcn(obj,'CONFIG',prop,val);
    end
    
    function addPropCONFIG(obj,prop)
      % 添加用户属性信息
      
      addPropPrivateFcn(obj,'CONFIG',prop);
    end
    
    function delPropCONFIG(obj,prop)
      % 删除用户数据的属性
      
      delPropPrivateFcn(obj,'CONFIG',prop);
    end
    
    function out = outputUserData(obj)
      % 导出用户数据
      
      out = struct;
      props = properties(obj);
      for i = 1:length(props)
        out.(props{i}) = obj.(props{i});
      end
      
    end
    
    function val = getPropValDATA(obj,prop)
      % 获取用户数据属性值
      
      val = getPropValPrivFcn(obj,'DATA',prop);
    end
    
    function val = getPropValCONFIG(obj,prop)
      % 获取用户数据属性值
      
      val = getPropValPrivFcn(obj,'CONFIG',prop);
    end
    
    function deleteManager(obj)
      % 删除用户管理对象
      
      % 删除LEELAZERO引擎对象
      if ~isempty(obj.LEELAZERO)
        if isfield(obj.LEELAZERO,'ENGINE')
          Engine = obj.LEELAZERO;
          quitEngine(Engine);
          delete(Engine);
        end
      end
      
      % 删除所有Stone对象
      delStone
      
    end
    
  end
  methods(Hidden)
    
    function setPropValPrivFcn(obj,item,prop,val)
      % 设置用户子属性
      
      if isempty(obj.(item))
        obj.(item) = struct;
        obj.(item).(prop) = val;
      elseif isstruct(obj.(item))
        if isfield(obj.(item),prop)
          obj.(item).(prop) = val;
        else
          obj.(item) = setfield(obj.(item),prop,val); %#ok
        end
      else
        error('未知类型的"obj.%s"类型.',item);
      end
      
      
    end
    
    function addPropPrivateFcn(obj,item,prop)
      % 添加用户子属性
      
      if isempty(obj.(item))
        obj.(item) = struct;
        obj.(item).(prop) = [];
      elseif isstruct(obj.(item))
        if ~isfield(obj.(item),prop)
          obj.(item).(prop) = [];
        end
      else
        obj.(item) = struct;
        obj.(item).(prop) = [];
        
      end
      
    end
    
    function val = getPropValPrivFcn(obj,item,prop)
      % 获取用户子信息
      
      if isempty(obj.(item))
        val = [];
      elseif isstruct(obj.(item))
        if isfield(obj.(item),prop)
          val = obj.(item).(prop);
        else
          val = [];
        end
      end
      
    end
    
    function delPropPrivateFcn(obj,item,prop)
      % 删除用户子信息
      
      if ~isempty(obj.(item))
        if isstruct(obj.(item))
          if isfield(obj.(item), prop)
            obj.(item) = rmfield(obj.(item),prop);
          end
        end
      end
      
      if isstruct(obj.(item))
        if isempty(fieldnames(obj.(item)))
          obj.(item) = [];
        end
      end
      
    end
    
  end
  
end