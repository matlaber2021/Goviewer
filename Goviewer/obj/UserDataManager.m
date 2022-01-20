classdef UserDataManager < handle
% USERDATAMANAGER is the management tool of Goviewer. It is designed as a
% handle class inside the UserData of Goviewer figure, plays the role of 
% global variable. 

  properties
    CONFIG      % Config data
    DATA        % Board data
    WINDOW      % Popup window
    JUDGMENT    % Game jugement info
    LEELAZERO   % Leelaz engine info
    GAMERESULT  % Game result data
  end
  
  properties(Hidden)
    OPTIONSET_LEELAZERO % 
    SKIP_TREENODE = 0;
  end
  
  methods
    
    function obj = UserDataManager(S)
      % generate the user data manager object
      %
      % obj = UserDataManager()  % building a new object
      % obj = UserDataManager(S) % force to convert to UserDataManager object 
      
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
      % set the property value of DATA property
      
      setPropValPrivFcn(obj,'DATA',prop,val);
    end
    
    function addPropDATA(obj,prop)
      % add the empty property of DATA property
      
      addPropPrivateFcn(obj,'DATA',prop);
    end
    
    function delPropDATA(obj,prop)
      % delete the empty of DATA property
      
      delPropPrivateFcn(obj,'DATA',prop);
    end
    
    function setPropValCONFIG(obj,prop,val)
      % set the property value of CONFIG property
      
      setPropValPrivFcn(obj,'CONFIG',prop,val);
    end
    
    function addPropCONFIG(obj,prop)
      % add the empty property of CONFIG property
      
      addPropPrivateFcn(obj,'CONFIG',prop);
    end
    
    function delPropCONFIG(obj,prop)
      % delete the property of CONFIG property
      
      delPropPrivateFcn(obj,'CONFIG',prop);
    end
    
    function out = outputUserData(obj)
      % force to convert to structure array
      
      out = struct;
      props = properties(obj);
      for i = 1:length(props)
        out.(props{i}) = obj.(props{i});
      end
      
    end
    
    function val = getPropValDATA(obj,prop)
      % get the property value of DATA property
      
      val = getPropValPrivFcn(obj,'DATA',prop);
    end
    
    function val = getPropValCONFIG(obj,prop)
      % get the property value of CONFIG property
      
      val = getPropValPrivFcn(obj,'CONFIG',prop);
    end
    
    function deleteManager(obj)
      % delete the manager object
      
      % remove the leelaz engine object
      if ~isempty(obj.LEELAZERO)
        if isfield(obj.LEELAZERO,'ENGINE')
          Engine = obj.LEELAZERO;
          quitEngine(Engine);
          delete(Engine);
        end
      end
      
      % delete all the stone object
      delStone
      
    end
    
  end
  methods(Hidden)
    
    function setPropValPrivFcn(obj,item,prop,val)
      % set the sub-property value
      
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
        error('Unknown type called "obj.%s".',item);
      end
      
      
    end
    
    function addPropPrivateFcn(obj,item,prop)
      % add property value of sub-property value
      
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
      % get the user sub-infomation
      
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
      % delete the sub-infomation
      
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