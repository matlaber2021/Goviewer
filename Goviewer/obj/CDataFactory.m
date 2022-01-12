classdef CDataFactory < handle
  
  properties
    
    Black   % 黑棋
    White   % 白棋
    Rotate  % 旋转
    Delete  % 删除
    Resign  % 认输
    Forward % 前进
    Back    % 返回
    ByTurn  % 黑白轮流
    BPass   % 黑棋弃权
    WPass   % 白棋弃权
    TaiChi  % 太极
    Eraser  % 橡皮擦
    Bot     % AI
    Analyze % 形式判断
    Book    % 背诵
    One     % 数字
    Eye     % 眼睛
    HandTalk% 手谈
    Chess   % 棋盘
    GoGame  % 围棋
    NoSound % 静音
    Sound   % 声音
    Print   % 打印
    Save    % 保存
    File    % 文档
    Switch  % 切换（黑白）
    Judgment % 确认死子
    Edit    % 编辑
    ScanShot% 截图
    Comment % 评论
    Tree    % 树
    
  end
  
  methods
    
    function obj = CDataFactory()
      
      o=NaN; w=2; k=1;
      
      obj.Rotate.cdata = [...
        o o o o o k o o o o o o o o o o
        o o o o k k k k k k k o o o o o
        o o o k k k k k k k k k k o o o
        o o k k k k k k o o o k k k o o
        o o k k k k k o o o o o k k o o
        o o o o o o o o o o o o k k o o
        o o o o o o o o o o o o o k k o
        o o o o o o o o o o o o o k k o
        o o o o o o o o o o o o o k k o
        o o k k o o o o o o o o o k k o
        o o k k o o o o o o o o k k o o
        o o o k k o o o o o o o k k o o
        o o o o k k k o o o k k k o o o
        o o o o o k k k k k k k o o o o
        o o o o o o o k k k o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Black.cdata = [...
        o o o o o k k k k k k o o o o o
        o o o k k k k k k k k k k o o o
        o o k k k k k k k k k k k k o o
        o k k k k k k k k k k k k k k o
        o k k k k k k k k k k k k k k o
        k k k k k k k k k k k k k k k k
        k k k k k k k k k k k k k k k k
        k k k k k k k k k k k k k k k k
        k k k k k k k k k k k k k k k k
        k k k k k k k k k k k k k k k k
        k k k k k k k k k k k k k k k k
        o k k k k k k k k k k k k k k o
        o k k k k k k k k k k k k k k o
        o o k k k k k k k k k k k k o o
        o o o k k k k k k k k k k o o o
        o o o o o k k k k k k o o o o o
        ];
      
      obj.White.cdata = [...
        o o o o o k k k k k k o o o o o
        o o o k k k o o o o k k k o o o
        o o k k o o o o o o o o k k o o
        o k k o o o o o o o o o o k k o
        o k o o o o o o o o o o o o k o
        k k o o o o o o o o o o o o k k
        k o o o o o o o o o o o o o o k
        k o o o o o o o o o o o o o o k
        k o o o o o o o o o o o o o o k
        k o o o o o o o o o o o o o o k
        k k o o o o o o o o o o o o k k
        o k o o o o o o o o o o o o k o
        o k k o o o o o o o o o o k k o
        o o k k o o o o o o o o k k o o
        o o o k k k o o o o k k k o o o
        o o o o o k k k k k k o o o o o
        ];
      
      obj.Delete.cdata = [...
        o o o o o o o o o o o o o o o o
        o w k k o o o o o o o o k k w o
        o k k k k o o o o o o k k k k o
        o k k k k k o o o o k k k k k o
        o o k k k k k o o k k k k k o o
        o o o k k k k k k k k k k o o o
        o o o o k k k k k k k k o o o o
        o o o o o k k k k k k o o o o o
        o o o o o k k k k k k o o o o o
        o o o o k k k k k k k k o o o o
        o o o k k k k k k k k k k o o o
        o o k k k k k o o k k k k k o o
        o k k k k k o o o o k k k k k o
        o k k k k o o o o o o k k k k o
        o w k k o o o o o o o o k k w o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.TaiChi.cdata = [...
        o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o k k k k o o o o o o o o o o o o o o
        o o o o o o o o o o o k k k k k k k k k k o o o o o o o o o o o
        o o o o o o o o o k k k k k k k k w w k k k k o o o o o o o o o
        o o o o o o o o k k k k k k k w w w w w w w w k o o o o o o o o
        o o o o o o o k k k k k k k k w w w w w w w w w k o o o o o o o
        o o o o o o k k k k k k k k w w w w w w w w w w w k o o o o o o
        o o o o o o k k k k k k k k w w w w w w w w w w w k o o o o o o
        o o o o o k k k k k k k k k w w w w w w k k w w w w k o o o o o
        o o o o o k k k k k k k k k k w w w w k k k k w w w k o o o o o
        o o o o o k k k k k k k k k k w w w w k k k k w w w k o o o o o
        o o o o k k k k k k k k k k k k w w w w k k w w w w w k o o o o
        o o o o k k k k k k k k k k k k w w w w w w w w w w w k o o o o
        o o o o k k k k k k k k k k k k k w w w w w w w w w w k o o o o
        o o o o k k k k k k k k k k k k k k w w w w w w w w w k o o o o
        o o o o o k k k k k w w k k k k k k w w w w w w w w k o o o o o
        o o o o o k k k k w w w w k k k k k w w w w w w w w k o o o o o
        o o o o o k k k k w w w w k k k k k k w w w w w w w k o o o o o
        o o o o o o k k k k w w k k k k k k k w w w w w w k o o o o o o
        o o o o o o k k k k k k k k k k k k w w w w w w w k o o o o o o
        o o o o o o o k k k k k k k k k k k w w w w w w k o o o o o o o
        o o o o o o o o k k k k k k k k k k w w w w w k o o o o o o o o
        o o o o o o o o o k k k k k k k k w w w w k k o o o o o o o o o
        o o o o o o o o o o o k k k k w w w k k k o o o o o o o o o o o
        o o o o o o o o o o o o o o k k k k o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
        ];
      
      obj.ByTurn.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o k k k k k o o o o o o o o
        o o k k o o o k k o o o o o o o
        o k k o o o o o k k o o o o o o
        o k o o o o o o o k o o o o o o
        o k o o o o o o o k o o o o o o
        o k o o o o o o k k k k k o o o
        o k k o o o o k k k k k k k o o
        o o k k o o k k k k k k k k k o
        o o o k k k k k k k k k k k k o
        o o o o o o k k k k k k k k k o
        o o o o o o k k k k k k k k k o
        o o o o o o k k k k k k k k k o
        o o o o o o o k k k k k k k o o
        o o o o o o o o k k k k k o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Eraser.cdata = [...
        o o o o o o o o o o o o o o o o
        k k k k k k k o o o o o o o o o
        k k w w w w w k o o o o o o o o
        k w k w w w w w k o o o o o o o
        k w w k w w w w w k o o o o o o
        o k w w k w w w w w k o o o o o
        o o k w w k w w w w w k o o o o
        o o o k w w k w w w w w k o o o
        o o o o k w w k w w w w w k o o
        o o o o o k w w k w w w w w k o
        o o o o o o k w w k k k k k k k
        o o o o o o o k w k w w w w w k
        o o o o o o o o k k k k k k k k
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Back.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o k k o o o o o o o o
        o o o o o k k k o o o o o o o o
        o o o o k k k k o o o o o o o o
        o o o k k k k k k k k k k k o o
        o o k k k k k k k k k k k k o o
        o o o k k k k k k k k k k k o o
        o o o o k k k k o o o o o o o o
        o o o o o k k k o o o o o o o o
        o o o o o o k k o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Forward.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o k k o o o o o o
        o o o o o o o o k k k o o o o o
        o o o o o o o o k k k k o o o o
        o o k k k k k k k k k k k o o o
        o o k k k k k k k k k k k k o o
        o o k k k k k k k k k k k o o o
        o o o o o o o o k k k k o o o o
        o o o o o o o o k k k o o o o o
        o o o o o o o o k k o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Bot.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o k k o o o o o o o
        o o o o o o o k k o o o o o o o
        o o o o o k k k k k k o o o o o
        o o o o k k k k k k k k o o o o
        o o k o k k o k k o k k o k o o
        o k k o k k o k k o k k o k k o
        o k k o k k k k k k k k o k k o
        o k k o k k k k k k k k o k k o
        o o k o k k o o o o k k o k o o
        o o o o k k k k k k k k o o o o
        o o o o o k k k k k k o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Analyze.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o k o o o o o o o o o o o o o
        o k k k o o o o o o o o o o o o
        o o k o o o o o o o o o o o o o
        o o k o o o o o o o k o o o o o
        o o k o o o o o o k o k o o o o
        o o k o k o o o k o o o k o o o
        o o k o o k o k o o o o o o o o
        o o k o o o k o o o o o o o o o
        o o k o o o o o o o o o o o o o
        o o k o o o o o o o o o o o o o
        o o k o o o o o o o o o k o o o
        o o k k k k k k k k k k k k o o
        o o o o o o o o o o o o k o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Resign.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o k k o o o o o o
        o o o o o o k k o k k k o o o o
        o o o o o k o k o k o k k o o o
        o o o o o k o k o k o k o k o o
        o o o k k k o k o k o k o k o o
        o o k o k k o k o k o k o k o o
        o o k o k k o k o k o k o k o o
        o o k o o k o o o o o o o k o o
        o o k o o o o o o o o o o k o o
        o o o k o o o o o o o o o k o o
        o o o k o o o o o o o o o k o o
        o o o o k o o o o o o o k o o o
        o o o o o k o o o o o k o o o o
        o o o o o o k k k k k o o o o o
        o o o o o o k k k k k o o o o o
        ];
      
      obj.WPass.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o k k k k k k o o o o o o o o o
        o k k k k k k k o o o o o o o o
        o k k o o o k k o o o o o o o o
        o k k o o o k k o o o o o o o o
        o k k k k k k k o o o o o o o o
        o k k k k k k o o o o o o o o o
        o k k o o o o o o k k k o o o o
        o k k o o o o o k o o o k o o o
        o k k o o o o k o o o o o k o o
        o k k o o o o k o o o o o k o o
        o o o o o o o k o o o o o k o o
        o o o o o o o o k o o o k o o o
        o o o o o o o o o k k k o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.BPass.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o k k k k k k o o o o o o o o o
        o k k k k k k k o o o o o o o o
        o k k o o o k k o o o o o o o o
        o k k o o o k k o o o o o o o o
        o k k k k k k k o o o o o o o o
        o k k k k k k o o o o o o o o o
        o k k o o o o o o k k k o o o o
        o k k o o o o o k k k k k o o o
        o k k o o o o k k k k k k k o o
        o k k o o o o k k k k k k k o o
        o o o o o o o k k k k k k k o o
        o o o o o o o o k k k k k o o o
        o o o o o o o o o k k k o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Book.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o k k k k o o
        o o k k k o o o k k k k k k o o
        o o k o o k k k k k o o k k o o
        o o k o o o o k o o o o k k o o
        o o k o o o o k o o o o k k o o
        o o k o o o o k o o o o k k o o
        o o k o o o o k o o o o k k o o
        o o k o o o o k o o o o k k o o
        o o k o o o o k o o o o k k o o
        o o k k k o o k o o k k k o o o
        o o o o o k k k k k o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.One.cdata = [...
        o o o o o k k k k k k o o o o o
        o o o k k k k k k k k k k o o o
        o o k k k k k k k k k k k k o o
        o k k k k k o o o k k k k k k o
        o k k k k o o o o k k k k k k o
        k k k k k o k o o k k k k k k k
        k k k k k k k o o k k k k k k k
        k k k k k k k o o k k k k k k k
        k k k k k k k o o k k k k k k k
        k k k k k k k o o k k k k k k k
        k k k k k o o o o o o k k k k k
        o k k k k o o o o o o k k k k o
        o k k k k k k k k k k k k k k o
        o o k k k k k k k k k k k k o o
        o o o k k k k k k k k k k o o o
        o o o o o k k k k k k o o o o o
        ];
      
      obj.Eye.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o k k k k k k o o o o o
        o o o k k o o k k o o k k o o o
        o o k o o o k k k k o o o k o o
        o k o o o o k k k k o o o o k o
        o k o o o o k k k k o o o o k o
        o o k o o o k k k k o o o k o o
        o o o k k o o k k o o k k o o o
        o o o o o k k k k k k o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.HandTalk.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o k k k o o o o o o o o o
        o o o k o o o k o o o o o o o o
        o o k o o o o o k o o o o o o o
        k k o o o o o o o k o o o o o o
        k k o o k o o k o o k o o o o o
        k k o o k k o o k o o k o o o o
        k k o o k o k o o k o o k o o o
        k k o o o o k k o o k o o k o o
        o o k o o o k o k o o k o o k o
        o o o k k k o o o k k o k k o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Chess.cdata = [...
        o o o o o o o o o o o o o o o o
        o k k k k k k k k k k k k k k o
        o k o o k k o o k k o o k k k o
        o k o o k k o o k k o o k k k o
        o k k k o o k k o o k k o o k o
        o k k k o o k k o o k k o o k o
        o k o o k k o o k k o o k k k o
        o k o o k k o o k k o o k k k o
        o k k k o o k k o o k k o o k o
        o k k k o o k k o o k k o o k o
        o k o o k k o o k k o o k k k o
        o k o o k k o o k k o o k k k o
        o k k k o o k k o o k k o o k o
        o k k k o o k k o o k k o o k o
        o k k k k k k k k k k k k k k o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.GoGame.cdata = [...
        o k k k k k k k k k k k k k k k
        o k k k k k k k k k k k k k k k
        o k k o o o k o o o k o o o k k
        o k k o o o k o o k k k o o k k
        o k k o o o k o k o o o k o k k
        o k k k k k k k k o o o k k k k
        o k k o o o k o k o o o k o k k
        o k k o o k k k o k k k o o k k
        o k k o k k k k k o k o o o k k
        o k k k k k k k k k k k k k k k
        o k k o k k k k k o k o o o k k
        o k k o o k k k o o k o o o k k
        o k k o o o k o o o k o o o k k
        o k k k k k k k k k k k k k k k
        o k k k k k k k k k k k k k k k
        o o o o o o o o o o o o o o o o
        ];
      
      obj.NoSound.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o k k o o o o o o o o
        o o o o o k k k o o o o o o o o
        o o o o k k k k o k k o o k k o
        o k k k k k k k o k k k k k k o
        o k k k k k k k o o k k k k o o
        o k k k k k k k o o k k k k o o
        o k k k k k k k o k k k k k k o
        o o o o k k k k o k k o o k k o
        o o o o o k k k o o o o o o o o
        o o o o o o k k o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Sound.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o k k o o o o o o o o
        o o o o o k k k o o o k o o o o
        o o o o k k k k o o o o k o o o
        o k k k k k k k o o k o o k o o
        o k k k k k k k o o o k o k o o
        o k k k k k k k o o o k o k o o
        o k k k k k k k o o k o o k o o
        o o o o k k k k o o o o k o o o
        o o o o o k k k o o o k o o o o
        o o o o o o k k o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Print.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o k k k k k k k o o o o o
        o o o o k o o o o o k k o o o o
        o o o o k o o o o o o k o o o o
        o o k k k o o o o o o k k k o o
        o k k k k k k k k k k k k k k o
        o k k k k k k k k k k k o k k o
        o k k k k k k k k k k k k k k o
        o k k k k k k k k k k k k k k o
        o k k k k o o o o o o k k k k o
        o k k k k o k k k k o k k k k o
        o o o o k o o o o o o k o o o o
        o o o o k o o o o o o k o o o o
        o o o o k k k k k k k k o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Save.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o k k k k k k k o o o o o o
        o o o k o o o o o k k o o o o o
        o o o k o o o o o k k k o o o o
        o o o k k k k k k k k k k o o o
        o o o k k k k k k k k k k o o o
        o o o k k k k o o k k k k o o o
        o o o k k k o o o o k k k o o o
        o o o k k k o o o o k k k o o o
        o o o k k k k o o k k k k o o o
        o o o k k k k k k k k k k o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.File.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o k k k k k k k o o o o o o
        o o o k k k k k k k k o o o o o
        o o o k k k k k k k k k o o o o
        o o o k k k k o o k k k k o o o
        o o o k k k k o o k k k k o o o
        o o o k k o o o o o o k k o o o
        o o o k k o o o o o o k k o o o
        o o o k k k k o o k k k k o o o
        o o o k k k k o o k k k k o o o
        o o o k k k k k k k k k k o o o
        o o o k k k k k k k k k k o o o
        o o o k k k k k k k k k k o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Switch.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o k o o o o o o o o o o o
        o o o k k o o o o o o o o o o o
        o o k k k k k k k k o o o o o o
        o o k k k k k k k k o o o o o o
        o o o k k o o o o o o o o o o o
        o o o o k o o o o o o o o o o o
        o o o o o o o o o o o k o o o o
        o o o o o o o o o o o k k o o o
        o o o o o o k k k k k k k k o o
        o o o o o o k k k k k k k k o o
        o o o o o o o o o o o k k o o o
        o o o o o o o o o o o k o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Judgment.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o k k k k k k k k k k o o o
        o o o k k k k k k k k k k o o o
        o o o k o o o k k o o o k o o o
        o o k k k o o k k o o k k k o o
        o k k o k k o k k o k k k k k o
        o k o o o k o k k o k k k k k o
        o k k k k k o k k o k k k k k o
        o o o o o o o k k o o o o o o o
        o o o o o o o k k o o o o o o o
        o o o o o o o k k o o o o o o o
        o o o o o k k k k k k o o o o o
        o o o o o k k k k k k o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Edit.cdata = [...
        o o o o o o o o o o o o o o o o
        o k k k k k k k k o o o k o o o
        o k k k k k k k k o o k k k o o
        o k k o o o o o o o k k k k k o
        o k k o o o o o o k k k k k o o
        o k k o o o o o k k k k k o o o
        o k k o o o o k k k k k o o o o
        o k k o o k o o k k k o o k k o
        o k k o o k k o o k o o o k k o
        o k k o o k k k o o o o o k k o
        o k k o o k k k k o o o o k k o
        o k k o o o o o o o o o o k k o
        o k k o o o o o o o o o o k k o
        o k k k k k k k k k k k k k k o
        o k k k k k k k k k k k k k k o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.ScanShot.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o k o o o o o o o o o o k o
        o o o k o o o o o o o o o k o o
        o k k k k k k k k k k k k o o o
        o o o k o o o o o o o k k o o o
        o o o k o o o o o o k o k o o o
        o o o k o o o o o k o o k o o o
        o o o k o o o o k o o o k o o o
        o o o k o o o k o o o o k o o o
        o o o k o o k o o o o o k o o o
        o o o k o k o o o o o o k o o o
        o o o k k o o o o o o o k o o o
        o o o k k k k k k k k k k k k o
        o o o o o o o o o o o o k o o o
        o o o o o o o o o o o o k o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Comment.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o k k k k k k k k k k o o o
        o o k k k k k k k k k k k k o o
        o o k k k k k k k k k k k k o o
        o o k k o o k o o k o o k k o o
        o o k k o o k o o k o o k k o o
        o o k k k k k k k k k k k k o o
        o o k k k k k k k k k k k k o o
        o o o k k k k k k k k k k o o o
        o o o o o o k k k k o o o o o o
        o o o o o o o k k o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Tree.cdata = [...
        o o o o o o o o o o o o o o o o
        o o o o o o k k k k o o o o o o
        o o o o o k k k k k k o o o o o
        o o o o k k k k k k k k o o o o
        o o o o k k k k k k k k o o o o
        o o o k k k k k k k k k k o o o
        o o o k k k k k k k k k k o o o
        o o o k k k k k k k k k k o o o
        o o o k k k k k k k k k k o o o
        o o o o k k k k k k k k o o o o
        o o o o o k k k k k k o o o o o
        o o o o o o o k k o o o o o o o
        o o o o o o o k k o o o o o o o
        o o o o o o o k k o o o o o o o
        o o o o o o o k k o o o o o o o
        o o o o o o o o o o o o o o o o
        ];
      
      obj.Black.hotspot = [8,8];
      obj.White.hotspot = [8,8];
      obj.Rotate.hotspot = [8,8];
      obj.TaiChi.hotspot = [16,16];
      obj.Delete.hotspot = [8,8];
      obj.ByTurn.hotspot = [8,8];
      obj.Eraser.hotspot = [2,1];
      obj.Back.hotspot = [8,5];
      obj.Forward.hotspot = [8,12];
      obj.Bot.hotspot = [8,8];
      obj.Analyze.hotspot = [8,8];
      obj.Resign.hotspot = [8,8];
      obj.WPass.hotspot = [8,8];
      obj.BPass.hotspot = [8,8];
      obj.Book.hotspot = [8,8];
      obj.One.hotspot = [8,8];
      obj.Eye.hotspot = [8,8];
      obj.HandTalk.hotspot = [14,13];
      obj.Chess.hotspot = [8,8];
      obj.GoGame.hotspot = [8,8];
      obj.NoSound.hotspot = [8,8];
      obj.Sound.hotspot = [8,8];
      obj.Print.hotspot = [8,8];
      obj.Save.hotspot = [8,8];
      obj.File.hotspot = [8,8];
      obj.Switch.hotspot = [8,8];
      obj.Judgment.hotspot = [8,8];
      obj.Edit.hotspot = [6,6];
      obj.ScanShot.hotspot = [8,8];
      obj.Comment.hotspot = [8,8];
      obj.Tree.hotspot = [8,8];
      
    end
    
    
  end
end