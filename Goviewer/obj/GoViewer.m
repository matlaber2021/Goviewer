classdef GoViewer < handle
  
  properties
    
  end
  
  
  methods(Static)
    
    function fig = start()
      % 启动围棋软件的图形界面
      
      GoViewer.addpath()
      
      % 初始化图形界面
      fig = GoViewer.initGoViwerFigure();
      
      % 启动工具栏
      GoViewer.initToolbar(fig)
      
      % 初始化用户信息
      GoViewer.initUserDataManager(fig);
      
      % 图形元素布局
      %h = GoViewer.DrawLayout(fig);
      
      % 绘制棋盘元素
      ax = GoViewer.DrawComponentsOnBoard(fig);
      
      %GoViewer.CreateButtons(h(2));
      
      % 激活棋盘回调函数
      GoViewer.initCallbackOnBoard(ax);
      
    end
    
    function fig = initGoViwerFigure()
      % 初始化围棋软件的图形界面
      
      fig = figure(...
        'NumberTitle' ,'off', ...
        'MenuBar'     ,'none', ...
        'ToolBar'     ,'none', ...
        'Resize'      ,'on', ...
        'Name'        ,'GoViewer');
      
      % 图像对象长宽像素：750x600
      moveFigureCenter(fig,[750,600]);
      
    end
    
    function h = DrawLayout(fig)
      
      h(1) = uipanel(...
        'Parent', fig, ...
        'Units' , 'pixels', ...
        'Position', [30,120,450,450]);
      
      h(2) = uibuttongroup(...
        'Parent', fig, ...
        'Units',  'pixels', ...
        'Position', [30,20,450,70],...
        'BackgroundColor','w');
    end
    
    function DeleteLayout(fig)
      
      delete(findobj(fig,'type','uipanel'));
      delete(findobj(fig,'type','uibuttongroup'));
      
    end
    
    function CreateButtons(h)
      
      uicontrol('Parent',h,'Style','pushbutton',...
        'Tooltip','试下','String','试走',...
        'Units','pixels','Position',[8,39,64,23],...
        'FontName','黑体','ForegroundColor','k',...
        'FontWeight','normal');
      
      uicontrol('Parent',h,'Style','pushbutton',...
        'Tooltip','清除死子','String','清除死子',...
        'Units','pixels','Position',[86,39,64,23],...
        'FontName','黑体','ForegroundColor','k',...
        'FontWeight','normal');
      
      uicontrol('Parent',h,'Style','pushbutton',...
        'Tooltip','认输','String','认输',...
        'Units','pixels','Position',[158,39,64,23],...
        'FontName','黑体','ForegroundColor','k',...
        'FontWeight','normal');
      
      uicontrol('Parent',h,'Style','pushbutton',...
        'Tooltip','申请和棋','String','申请和棋',...
        'Units','pixels','Position',[230,39,64,23],...
        'FontName','黑体','ForegroundColor','k',...
        'FontWeight','normal');
      
      uicontrol('Parent',h,'Style','pushbutton',...
        'Tooltip','显示手数','String','显示手数',...
        'Units','pixels','Position',[302,39,64,23],...
        'FontName','黑体','ForegroundColor','k',...
        'FontWeight','normal');
      
      uicontrol('Parent',h,'Style','pushbutton',...
        'Tooltip','旋转棋盘','String','旋转棋盘',...
        'Units','pixels','Position',[374,39,64,23],...
        'FontName','黑体','ForegroundColor','k',...
        'FontWeight','normal');
      
    end
    
    function initToolbar(fig)
      % 初始化工具栏图标
      
      obj = CDataFactory;
      
      hTBar1 = uitoolbar(fig);
      hTBar2 = uitoolbar(fig);
      
      hButton_File=uipushtool(hTBar1,'CData',CData2RGB(obj.File.cdata) );
      set(hButton_File,'ClickedCallback',@CallbackSet.FileImportCallback);
      set(hButton_File,'Tooltip','open');
      
      hButton_Save=uipushtool(hTBar1,'CData',CData2RGB(obj.Save.cdata) );
      set(hButton_Save,'ClickedCallback',@CallbackSet.SaveFileCallback);
      set(hButton_Save,'Tooltip','save');
      
      hButton_New=uipushtool(hTBar1,'CData',CData2RGB(obj.GoGame.cdata) );
      set(hButton_New,'ClickedCallback',@CallbackSet.NewBoardCallback);
      set(hButton_New,'Tooltip','new board');
      
      hButton_BMove = uitoggletool(hTBar1,'CData',CData2RGB(obj.Black.cdata) );
      set(hButton_BMove,'ClickedCallback',@CallbackSet.BlackModeCallback);
      set(hButton_BMove,'Tooltip','black add');
      
      hButton_WMove = uitoggletool(hTBar1,'CData',CData2RGB(obj.White.cdata) );
      set(hButton_WMove,'ClickedCallback',@CallbackSet.WhiteModeCallback);
      set(hButton_WMove,'Tooltip','white add');
      
      hButton_Turn  = uipushtool(hTBar1,'CData',CData2RGB(obj.ByTurn.cdata) );
      set(hButton_Turn,'ClickedCallback',@CallbackSet.DefaultModeCallback);
      set(hButton_Turn,'Tooltip','default move');
      
      hButton_BPass = uipushtool  (hTBar1,'CData',CData2RGB(obj.BPass.cdata) );
      set(hButton_BPass,'ClickedCallback',@CallbackSet.BlackPassCallback);
      set(hButton_BPass,'Tooltip','black pass');
      
      hButton_WPass = uipushtool  (hTBar1,'CData',CData2RGB(obj.WPass.cdata) );
      set(hButton_WPass,'ClickedCallback',@CallbackSet.WhitePassCallback);
      set(hButton_WPass,'Tooltip','white pass');
      
      hButton_Delete = uipushtool (hTBar1,'CData',CData2RGB(obj.Delete.cdata, [1,0,0]) );
      set(hButton_Delete,'ClickedCallback',@CallbackSet.RetractStoneCallback );
      set(hButton_Delete,'Tooltip','delete');
      
      hButton_Resign = uipushtool (hTBar1,'CData',CData2RGB(obj.Resign.cdata) );
      set(hButton_Resign,'ClickedCallback',@CallbackSet.ResignCallback );
      set(hButton_Resign,'Tooltip','resign');
      set(hButton_Resign,'Enable','off');
      
      hButton_Rotate = uipushtool(hTBar2,'CData',CData2RGB(obj.Rotate.cdata) );
      set(hButton_Rotate,'ClickedCallback',@CallbackSet.RotateCallback)
      set(hButton_Rotate,'Tooltip','rotate');
      
      hButton_Order = uipushtool(hTBar2,'CData',CData2RGB(obj.One.cdata) );
      set(hButton_Order,'ClickedCallback',@CallbackSet.SwitchOrderCallback);
      set(hButton_Order,'Tooltip','stone number');
      
      hButton_Back = uipushtool(hTBar2,'CData',CData2RGB(obj.Back.cdata) );
      set(hButton_Back,'ClickedCallback',@CallbackSet.BackwardCallback);
      set(hButton_Back,'Tooltip','backward');
      
      hButton_Forward = uipushtool(hTBar2,'CData',CData2RGB(obj.Forward.cdata) );
      set(hButton_Forward,'ClickedCallback',@CallbackSet.ForwardCallback);
      set(hButton_Forward,'Tooltip','forward');
      
      hButton_Bot = uipushtool(hTBar2,'CData',CData2RGB(obj.Bot.cdata) );
      set(hButton_Bot,'ClickedCallback',@CallbackSet.LeelazGameCallback);
      set(hButton_Bot,'Tooltip','leela zero');
      
      hButton_Auto = uitoggletool(hTBar2,'CData',CData2RGB(obj.HandTalk.cdata) );
      set(hButton_Auto,'ClickedCallback',@CallbackSet.AutoForwardCallback);
      set(hButton_Auto,'Tooltip','auto forward');
      
      hButton_Shot = uipushtool(hTBar2,'CData',CData2RGB(obj.ScanShot.cdata) );
      set(hButton_Shot,'ClickedCallback',@CallbackSet.ScanShotCallback);
      set(hButton_Shot,'Tooltip','scanshot');
      
      hButton_Comment = uipushtool(hTBar2,'CData',CData2RGB(obj.Comment.cdata) );
      set(hButton_Comment,'ClickedCallback',@CallbackSet.CommentCallback);
      set(hButton_Comment,'Tooltip','comment');
      
      hButton_Tree = uipushtool(hTBar2,'CData',CData2RGB(obj.Tree.cdata) );
      set(hButton_Tree,'ClickedCallback',@CallbackSet.TreeNodeCallback);
      set(hButton_Tree,'Tooltip','tree node');
      
    end
    
    function initUserDataManager(fig)
      % 初始化用户数据参数
      
      Manager = UserDataManager();
      set(fig,'UserData',Manager);
      
      labelorder = {...
        'a','b','c','d','e',...
        'f','g','h','j','k',...
        'l','m','n','o','p',...
        'q','r','s','t'};
      
      % 初始化棋盘配置参数
      setPropValCONFIG(Manager,'BOARDSIZE',[19,19]);
      setPropValCONFIG(Manager,'BOARDCOLOR',[249 214 91]/255);
      setPropValCONFIG(Manager,'LABELORDER',labelorder);
      setPropValCONFIG(Manager,'NEWSTONE_VISIBLE',1);
      %setPropValCONFIG(Manager);
      setPropValCONFIG(Manager,'STONE_ORDER_OPTION',2);
      setPropValCONFIG(Manager,'STARPOINTS',[4 4;4 10;4 16;10 4;...
        10 10;10 16;16 4;16 10;16 16]);
      setPropValCONFIG(Manager,'STARRADIUS',0.15);
      setPropValCONFIG(Manager,'STONERADIUS',0.45);
      setPropValCONFIG(Manager,'THETAFORCIRCLE',linspace(0,2*pi,20));
      
      % 初始化棋盘数据参数
      setPropValDATA(Manager,'CURRENT_STATE',zeros([19,19]));
      setPropValDATA(Manager,'CURRENT_STONE',Stone() );
      setPropValDATA(Manager,'HANDICAP',0);
      setPropValDATA(Manager,'ISKOLOCKED',0);
      setPropValDATA(Manager,'NEXTSIDE',1);
      
    end
    
    function ax = DrawComponentsOnBoard(h)
      % 在棋盘上绘制元素
      
      ax  = axes(h);
      o = onCleanup(@() set(ax,'LooseInset',[0,0,0,0]));
      fig = ancestor(h,'figure');
      Manager = get(fig,'UserData');
      BoardSize = getPropValCONFIG(Manager,'BOARDSIZE');
      M = BoardSize(1);
      N = BoardSize(2);
      set(ax,'DataAspectRatio',[1,1,1]);
      set(ax,'Color',[249 214 91]/255);
      set(ax,'XLim',[0,N+1]);
      
      set(ax,'YLim',[0,M+1]);
      set(ax,'XTick',1:N);
      set(ax,'YTick',1:M);
      xa = ax.XAxis;
      ya = ax.YAxis;
      set(xa,'TickLength',[0,0]);
      set(ya,'TickLength',[0,0]);
      set(ax,'Box','on');
      set(ax,'LineWidth',1);
      
      LabelOrder = getPropValCONFIG(Manager,'LABELORDER');
      set(ax,'XTickLabel',upper(LabelOrder));
      
      % 绘制边缘
      hEdge = [];
      hEdge = [hEdge; line('Parent',ax,'XData',[0 0],'YData',[0 N+1])];
      hEdge = [hEdge; line('Parent',ax,'XData',[0 0],'YData',[0 M+1])];
      hEdge = [hEdge; line('Parent',ax,'XData',[N+1 0],'YData',[N+1 M+1])];
      hEdge = [hEdge; line('Parent',ax,'XData',[0 M+1],'YData',[N+1 M+1])];
      
      % 绘制星位
      r = getPropValCONFIG(Manager,'STARRADIUS');
      o = getPropValCONFIG(Manager,'STARPOINTS');
      theta = getPropValCONFIG(Manager,'THETAFORCIRCLE');
      hStars = [];
      for i = 1:size(o,1)
        oo = o(i,:);
        x = oo(1)+r*cos(theta);
        y = oo(2)+r*sin(theta);
        hStarsTemp = patch('parent',ax,'XData',x,'YData',y,'FaceColor','k');
        hStars = [hStars; hStarsTemp]; %#ok
      end
      
      % 绘制网格
      hGrids = [];
      for i = 1:N
        hGridsTemp = line('Parent',ax,'XData',[i,i],'YData',[1,M]);
        hGrids = [hGrids; hGridsTemp];
      end
      
      for j = 1:M
        hGridsTemp = line('parent',ax,'XData',[1,N],'YData',[j,j]);
        hGrids = [hGrids; hGridsTemp];
      end
      
    end
    
    function h = getComponentsOnBoard(ax)
      % 获取部署在棋盘上的所有图形元素（包括棋盘本身）
      
      fig = ancestor(ax,'figure');
      ax  = findobj(fig,'type','axes');
      P = findobj(ax,'type','patch');
      L = findobj(ax,'type','line');
      h = [ax;P;L];
      
    end
    
    function initCallbackOnBoard(ax)
      % 初始化棋盘回调函数
      
      h = GoViewer.getComponentsOnBoard(ax);
      set(h,'ButtonDownFcn',@CallbackSet.DefaultCallback);
      
    end
    
    function LeelazOptionsWindow(h)
      % 创建里拉引擎选项弹窗
      %
      % 您选择执：黑/白
      % 贴目：
      % 让子：
      %
      % 确定/取消
      
      fo = uifigure(...
        'Position'    ,[400,250,250,300], ...
        'UserData'    ,h, ...
        'Name'        ,'对局选项', ...
        'Resize'      ,'off');
      
      Panel = uipanel(...
        'parent'      ,fo, ...
        'Title'       ,'Leela Zero 对局选项', ...
        'Position'    ,[10,50,230,240], ...
        'BorderType', 'line');
      
      uilabel(...
        'Parent'      , Panel, ...
        'Position'    , [10,180,80,26], ...
        'Text'      , '您选择执：', ...
        'FontName'    , 'Microsoft YaHei', ...
        'FontSize'    , 12, ...
        'FontWeight'  , 'normal', ...
        'VerticalAlignment', 'center', ...
        'HorizontalAlignment', 'right');
      
      uidropdown(...
        'Parent'      , Panel, ...
        'Items'       , {'黑','白'}, ...
        'Position'    , [110,180,80,26], ...
        'FontName'    , 'Microsoft YaHei', ...
        'FontSize'    , 12, ...
        'FontWeight'  , 'normal', ...
        'Tag'         , 'human_side');
      
      uilabel(...
        'Parent'      , Panel, ...
        'Position'    , [10,140,80,26], ...
        'Text'      , '贴目：', ...
        'FontName'    , 'Microsoft YaHei', ...
        'FontSize'    , 12, ...
        'FontWeight'  , 'normal', ...
        'VerticalAlignment', 'center', ...
        'HorizontalAlignment', 'right');
      
      uitextarea(...
        'Parent'      , Panel, ...
        'Value'       , '7.5', ...
        'Position'    , [110,140,80,26], ...
        'FontName'    , 'Microsoft YaHei', ...
        'FontSize'    , 12, ...
        'FontWeight'  , 'normal', ...
        'tag'         , 'komi');
      
      uilabel(...
        'Parent'      , Panel, ...
        'Position'    , [10,100,80,26], ...
        'Text'      , '让子数：', ...
        'FontName'    , 'Microsoft YaHei', ...
        'FontSize'    , 12, ...
        'FontWeight'  , 'normal', ...
        'VerticalAlignment', 'center', ...
        'HorizontalAlignment', 'right');
      
      uidropdown(...
        'Parent'      , Panel, ...
        'Items'       , {'0','2','3','4','5','6','7','8','9'}, ...
        'Position'    , [110,100,80,26], ...
        'FontName'    , 'Microsoft YaHei', ...
        'FontSize'    , 12, ...
        'FontWeight'  , 'normal', ...
        'tag'         , 'handicap');
      
      uibutton(...
        'Parent'      , fo, ...
        'Position'    , [60,10,80,32], ...
        'Text'      , '确定', ...
        'FontName'    , 'Microsoft YaHei', ...
        'FontSize'    , 12, ...
        'FontWeight'  , 'normal',...
        'ButtonPushedFcn', @CallbackSet.SaveLeelazOptionsCallback);
      
      uibutton(...
        'Parent'      , fo, ...
        'Position'    , [160,10,80,32], ...
        'Text'      , '返回', ...
        'FontName'    , 'Microsoft YaHei', ...
        'FontSize'    , 12, ...
        'FontWeight'  , 'normal',...
        'ButtonPushedFcn', 'delete(gcbf)');
      
    end
    
    function ufig = CreateCommentWindow(fig)
      % 生成评论弹窗
      
      ufig=uifigure('Name','Comment',...
        'CloseRequestFcn',@CallbackSet.CommentClosedCallback);
      set(ufig,'UserData',fig);
      gap=24;
      if(strcmpi(fig.Units,'pixels'))
        p0=get(fig,'Position');
        %p1=get(fig,'OuterPosition');
      end
      obj=CDataFactory;
      ufig.Position=[p0(1)+p0(3)+gap,p0(2)+p0(4)-200,300,200];
      bar=uitoolbar(ufig);
      hedit=uitoggletool(bar,'CData',CData2RGB(obj.Edit.cdata) );
      set(hedit,'ClickedCallback',@CallbackSet.CommentEditCallback);
      
      textarea=uitextarea(ufig);
      textarea.Position=[12,12,276,176];
      textarea.Editable='off';
      
      Manager=get(fig,'UserData');
      Manager.WINDOW.COMMENT_WINDOW=ufig;
      stone=Manager.DATA.CURRENT_STONE;
      textarea.Value=stone.comment;
      
    end
    
    function ufig = CreateTreeWindow(fig)
      % 生成树弹窗
      
      Manager=get(fig,'UserData');
      stone=Manager.DATA.CURRENT_STONE;
      if(~isempty(stone))
        stone=findAncestor(stone);
      else
        return
      end
      
      ufig = uifigure('Name','Stone Tree','Visible','off',...
        'CloseRequestFcn',@CallbackSet.TreeClosedCallback);
      ufig.Position(3)=750;
      ufig.Position(4)=600;
      movegui(ufig,'center');
      set(ufig,'UserData',fig);
      o = onCleanup(@() set(ufig, 'Visible','on'));
      
      tree = uitree(ufig);
      tree.UserData=stone;
      tree.Position=[16,16,750-32,600-32];
      tree.BackgroundColor=[0.94 0.94 0.94];
      tree.SelectionChangedFcn=@CallbackSet.StoneNodeSelectedCallback;
      tree.NodeExpandedFcn=@CallbackSet.StoneNodeExpandCallback;
      NodeExpandLocalFun(tree,1);
      Manager.WINDOW.TREE_WINDOW=ufig;
      
      assignin('base','tree',tree);
      
    end
    
    function addpath()
      
      Root=fileparts(fileparts(mfilename('fullpath')));
      %addpath(fullfile(Root,'@CallbackSet'));
      addpath(fullfile(Root));
      addpath(fullfile(Root,'obj'));
      addpath(fullfile(Root,'fun'));
      
    end
    
  end
  
end


function moveFigureCenter(fig,lw)
% 将图像对象移动至屏幕中央

set(fig,'Visible','off');
set(fig,'Units','pixels');
o = onCleanup(@() set(fig,'Visible','on') );

ScreenSize=get(0,'ScreenSize');
ScreenLength=ScreenSize(3);
ScreenWidth=ScreenSize(4);
if nargin>1
  L=lw(1);
  W=lw(2);
else
  p=get(fig,'Position');
  L=p(3);
  W=p(4);
end

left=(ScreenLength-L)/2;
bottom=(ScreenWidth-W)/2;
len=L;
width=W;

set(fig,'Position',[left,bottom,len,width]);

end