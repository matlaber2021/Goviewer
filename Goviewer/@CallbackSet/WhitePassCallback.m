function WhitePassCallback(h,e) %#ok
% 白棋弃权回调函数

fig = ancestor(h,'figure');
Manager = get(fig,'UserData');

CURRENT_STONE = getPropValDATA(Manager,'CURRENT_STONE');
setPropValDATA(Manager,'CURRENT_STONE', moveStone(CURRENT_STONE,2,[]) );
setPropValDATA(Manager,'ISKOLOCKED'   ,0);

% ...
if(isstruct(Manager.GAMERESULT))
  if(isfield(Manager.GAMERESULT,'CONTINUE'))
    if(Manager.GAMERESULT.CONTINUE)
      if(isfield(Manager.DATA,'ENGINE'))
        if(~isempty(Manager.DATA.ENGINE))
          if(isvalid(Manager.DATA.ENGINE))
            Engine=Manager.DATA.ENGINE;
            command = 'play w pass';
            fprintf('向引擎传送指令[%s]...\n',command);
            Engine.sendCommand(command);
            WaitForCommands(Engine);
            Manager.GAMERESULT.HUMAN_PASS=1;
            if(Manager.GAMERESULT.LEELAZ_PASS)
              fprintf('由于leelaz也选择弃权，棋局终止.\n');
              Manager.OPTIONSET_LEELAZERO = 0;
              Manager.GAMERESULT.ISOVER = 1;
              Manager.GAMERESULT.CONTINUE = 0;
              return
            end
            Manager.GAMERESULT.LEELAZ_PASS=0;
          end
        end
      end
    end
  end
end

end