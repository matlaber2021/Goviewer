function ResignCallback(h,e)
% 棋局投降回调函数

fig = ancestor(h,'figure');
Manager = get(fig,'UserData');

if ~isfield(Manager.LEELAZERO,'ENGINE')
  return
elseif isempty(Manager.LEELAZERO.ENGINE)
  return
end

Engine = Manager.LEELAZERO.ENGINE;

% 如果棋局并未进行，用户发出投降请求也无济于事
if isstruct(Manager.GAMERESULT)
  if isfield(Manager.GAMERESULT,'CONTINUE')
    if ~Manager.GAMERESULT.CONTINUE
      return
    end
  end
end

if isstruct(Manager.GAMERESULT)
  if isfield(Manager.GAMERESULT,'CONTINUE')
    if Manager.GAMERESULT.CONTINUE
      
      fprintf(2,'您已投子，LeelaZero获胜...\n');
      quitEngine(Engine);
      Manager.GAMERESULT.WINNER = Manager.LEELAZERO.LEELAZ_SIDE;
      Manager.OPTIONSET_LEELAZERO = 0;
      Manager.GAMERESULT.ISOVER = 1;
      Manager.GAMERESULT.CONTINUE = 0;
      
    end
  end
end