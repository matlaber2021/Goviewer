classdef GoPrinter < handle
  
  properties(Hidden)
    Figure
    SGFData
    FileOut
  end
  
  properties(Hidden)
    jRobot
    jRectangle
  end
  
  
  methods
    
    function obj = GoPrinter(fig)
      
      obj.Figure=fig;
      
    end
    
    function CaptureScreen(obj)
      % A simple java method to capture a screenshot.
      
      obj.jRobot = java.awt.Robot();
      obj.jRectangle = java.awt.Rectangle();
      
      fig=obj.Figure;
      pos=get(fig,'Position');
      screensize=get(0,'ScreenSize');
      width=screensize(3);
      height=screensize(4);
      
      obj.jRectangle.x=pos(1)+0;
      obj.jRectangle.y=height-pos(4)-pos(2)+0;
      obj.jRectangle.width=pos(3)-1;
      obj.jRectangle.height=pos(4)-1;
      
      image = obj.jRobot.createScreenCapture(obj.jRectangle);
      w = image.getWidth();
      h = image.getHeight();
      raster = image.getData();
      
      I=zeros(w*h*3,1);
      I=raster.getPixels(0,0,w,h,I);
      I=uint8(I);
      I1=I(1:3:length(I));
      I1=reshape(I1,[w,h]);
      I2=I(2:3:length(I));
      I2=reshape(I2,[w,h]);      
      I3=I(3:3:length(I));
      I3=reshape(I3,[w,h]);
      I=uint8(zeros(w,h,3));
      I(1:w,1:h,1)=I1;
      I(1:w,1:h,2)=I2;
      I(1:w,1:h,3)=I3;
      I=imrotate(I,-90,'nearest');
      I=flipdim(I,2); %#ok
      
      newfig=uifigure();
      newax=axes(newfig);
      imshow(I,'Parent',newax);
      set(newax,'LooseInset',[0,0,0,0]);
      
    end
    
    function GenerateGIF(obj)
      
    end
    
    function MakeMovie(obj)
      
    end
    
    function o = PrintSGF(obj)
      % Print out as SGF data.
      
      fig=obj.Figure;
      Manager=get(fig,'UserData');
      stone=Manager.DATA.CURRENT_STONE;
      root=findAncestor(stone);
      
      o = '(';
      Node = root;
      %setDefaultGameInfo(Node);
      
      while(1)
        %Node0=Node; % DEBUG
        if isempty(Node)
          break
        end
        add = displaySGFInfo(Node);
        if(~isempty(add))
          o = addString(o,[';',add]);
          
          % Taking line breaks to beautify the output.
          num=getLastLineStrLength(o);
          if(num>20)
            o = addString(o,newline);
          end
        end
        cNode=Node.children;
        
        % DOWN parameter is the layer of return, down=1 means that wen can
        % only trace back to the last branch object.
        [Node0,down]=findNextStone(Node);
        
        if(isempty(cNode))
          if(~isempty(Node0))
            suffix=repmat(')',[1,down]);
            o=addString(o,suffix);
            o=addString(o,newline);
            o=addString(o,[newline,'(']); % BUGFIX
          else
            % Here is the last stone object being recognized, and after
            % that the print preocedure finishs.
            suffix=repmat(')',[1,down]);
            o=addString(o,suffix);
            o=addString(o,newline);
            o=addString(o,')');
            obj.SGFData=o;
            return
          end
        elseif(length(cNode)>1)
          o = addString(o,[newline,'(']);
        end
        
        %obj.SGFData=o;
        Node=Node0;
        
      end
    end% PrintSGF
    
    function WriteSGF(obj,filename)
      % Write SGF data to a file with ".sgf" suffix.
      
      if(isempty(obj.SGFData)), return; end
      [~,~,ext] = fileparts(filename);
      if(strcmpi(ext,'.sgf'))
        writematrix(obj.SGFData,filename,'FileType','text');
        obj.FileOut=filename;
      end
      
    end
    
    function PrintImage(obj)
      
    end
    
    function PrintWORDReport(obj)
      
    end
    
    function PrintPDFReport(obj)
      
    end
  end
  
  
end

function in=addString(in,add)

N=length(add);
in(end+1:end+N)=add;

end

function num=getLastLineStrLength(str)

num=0;
N=length(str);
while(1)
  if num==N || isequal(str(end-num),newline)
    break
  else
    num=num+1;
  end
  
end

end