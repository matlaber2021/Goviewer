classdef EngineInterface < handle
% LEELAZERO.ENGINEINTERFACE 建立与引擎之间的通信
%
% 功能
% [1] 和LEELAZ引擎交互
% [2] 交互记录同步至日志

  properties
    EngineName    char
    EngineFolder  char
    WeightFile    char
    LogFolder     char
    Environment   char
  end
  
  properties(Hidden=false)
    jProcessBuilder
    jProcess
    jBufferedReader
    jPrintWriter
  end
  
  properties(Hidden=true)
    LogFileID
    LogName = 'log_leelaz.log';
  end
  
  methods
    function obj = EngineInterface()
      
      obj.EngineName = 'Leela Zero';
      obj.EngineFolder = ...
        'D:\GoViewer\Leelaz Engine';
      obj.LogFolder = 'D:\GoViewer\Leelaz Engine\log';
      obj.WeightFile = fullfile(obj.EngineFolder, ...
        'weight\leelaz-model-swa-16-128000_quantized.txt');
      
      % 打开CMD进程
      CallCmdProgress(obj);
      
      % 切换路径
      doChangeFolder(obj);
      
      % 打开Leelaz进程
      CallEngine(obj);
      
    end
  end
  
  methods
    
    function CallCmdProgress(obj)
      % 创建cmd进程 
      
      import java.lang.ProcessBuilder
      import java.io.InputStreamReader
      import java.io.BufferedReader
      import java.io.PrintWriter
      
      Builder = ProcessBuilder('cmd');
      Builder.redirectErrorStream(1);
      Process = Builder.start();
      
      % 创建输入流和输出流
      iStream = Process.getInputStream();
      iStreamReader = InputStreamReader(iStream);
      in = java.io.BufferedReader(iStreamReader);
      oStream = Process.getOutputStream();
      out = java.io.PrintWriter(oStream,1);
      
      obj.jProcessBuilder = Builder;
      obj.jProcess = Process;
      obj.jBufferedReader = in;
      obj.jPrintWriter = out;
      
      % CMD回应信息，但该信息无用
      getCommand(obj);
      obj.Environment = 'cmd';
      
      % 切换

    end
    
    function CallEngine(obj)
      % 调用Leela Zero引擎
      
      if strcmp(obj.Environment,'leelaz')
        return
      end
      
      if strcmp(obj.Environment,'cmd')
        
        command = sprintf('leelaz.exe -q -w "%s"',...
          obj.WeightFile);
        
        sendCommand(obj,command);
        %sendCommand(obj,'');
        WaitForCommands(obj); % waiting...
        obj.Environment = 'leelaz';
        
      end
      
    end
    
    function quitEngine(obj)
      % 终止程序运行
      
      if strcmp(obj.Environment,'cmd')
        sendCommand(obj,'exit');
        obj.Environment='';
      end
      
      if strcmp(obj.Environment,'leelaz')
        sendCommand(obj,'quit');
        obj.Environment='cmd';
        quitEngine(obj);
      end
      
      % BUGFIX
      try obj.jBufferedReader.close(); end %#ok
      try obj.jPrintWriter.close(); end %#ok
      try obj.jProcess.destroy(); end %#ok
      
      delete(handle(obj.jBufferedReader));
      delete(handle(obj.jPrintWriter));
      delete(handle(obj.jProcess));
      delete(handle(obj.jProcessBuilder));
      
    end
    
    function msg = getCommand(obj)
      % 从应用程序获取响应信息
      % Hint: 该函数不能保证响应信息完全结束
      
      in = obj.jBufferedReader;
      msg = '';
      while in.ready
        
        resp = char(in.read());
        if strcmp(resp,'\')
          resp = '\\';
        end
        msg = [msg, resp]; %#ok
        pause(0);
        
      end
      o = onCleanup(@() updateLogRecord(obj,msg,2) );
      
    end
    
    function sendCommand(obj,msg)
      % 向应用程序传送指令(cmd/leelaz/...)
      
      o = onCleanup(@() updateLogRecord(obj,msg,1) );
      out = obj.jPrintWriter;
      out.println(msg);
      
    end
    
    function msg = WaitForCommands(obj)
      % 非异步方式等待完整的Leela Zero回应信息
      
      msg = '';
      num = 0;
      while 1
        newmsg = getCommand(obj);
        msg = [msg, newmsg]; %#ok
        pause(0.1);
        
       suffix='Leela: ';
        if endsWith(msg,suffix)
          break
        end
        
        % 如果多次无法读取到数据，说明发生堵塞，可向应用程序发送空指令让数据
        % 喷涌出来
        if num>=5
          fprintf(2,'发生数据堵塞，向应用程序发送空指令...\n');
          sendCommand(obj,'');
          pause(1);
          continue;
        end
        
        if isempty(newmsg)
          num=num+1;
          continue;
        end
        
      end
      
    end
    
    function msg = WaitForMove(obj)
      % 等待引擎得出下一步
      
      msg = '';
      while 1
        newmsg = getCommand(obj);
        msg = [msg, newmsg]; %#ok
        
        pattern='=';
        
        if contains(msg,pattern)
          
          sendCommand(obj,'');
          newmsg=WaitForCommands(obj); %?
          msg = [msg, newmsg]; %#ok
          
          break
          
        end

        pause(0.1);
      end
      
      
    end
    
    function doChangeFolder(obj)
      % CMD切换文件路径
      
      command = LeelaZero.EngineInterface.getDiskName(obj.EngineFolder);
      sendCommand(obj,command);
      getCommand(obj);
      
      command = sprintf('cd "%s"',obj.EngineFolder);
      sendCommand(obj,command);
      getCommand(obj); 

      
    end
    
    function updateLogRecord(obj,msg,option)
      % 更新引擎交互的内部日志程序
      
      msg = regexprep(msg,{'Leela: ','\\','%'},{'','\\\\','%%'});
      msg = strtrim(msg);
      if isempty(msg)
        return
      end
      
      filename = fullfile(obj.LogFolder,obj.LogName);
      obj.LogFileID = fopen(filename,'a+');
      o = onCleanup(@() fclose(obj.LogFileID) );
      
      CURRENT_TIME = datestr(now,'yyyy-mm-dd HH:MM:SS');
      if option==1
        prefix = sprintf(...
          '[%s] [SENDING MESSAGE]', CURRENT_TIME);
      elseif option==2
        prefix = sprintf(...
          '[%s] [RECEIVING MESSAGE]', CURRENT_TIME);
      end
      fprintf(obj.LogFileID, [prefix,'\n']);
      fprintf(obj.LogFileID, [msg,'\n']);
      fprintf(obj.LogFileID, '\n');
      
    end
    
  end
  
  methods(Static)
    function pathstr = getDiskName(str)
      % 获取盘符名称
      
      pathstr = str;
      while 1
        pathstr_new = fileparts(pathstr);
        if strcmp(pathstr,pathstr_new)
          pathstr = regexprep(pathstr,'\\','');
          break
        end
        pathstr = pathstr_new;
      end
    end
  end
end
