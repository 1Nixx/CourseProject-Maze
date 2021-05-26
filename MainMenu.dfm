object MainMenuForm: TMainMenuForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1043#1083#1072#1074#1085#1086#1077' '#1084#1077#1085#1102
  ClientHeight = 521
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object pnButtons: TPanel
    Left = 0
    Top = 0
    Width = 744
    Height = 521
    Align = alClient
    AutoSize = True
    TabOrder = 0
    object lbAbout: TLabel
      Left = 574
      Top = 494
      Width = 154
      Height = 17
      Align = alCustom
      Caption = 'Created by Nikita Hripach'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = lbAboutClick
    end
    object btnGenMaze: TButton
      Left = 288
      Top = 265
      Width = 201
      Height = 33
      Action = actGen
      Align = alCustom
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object btnHistory: TButton
      Left = 288
      Top = 312
      Width = 201
      Height = 33
      Action = actHistory
      Align = alCustom
      TabOrder = 1
    end
    object btnStat: TButton
      Left = 288
      Top = 361
      Width = 201
      Height = 33
      Action = actStat
      Align = alCustom
      TabOrder = 2
    end
    object btnExit: TButton
      Left = 288
      Top = 408
      Width = 201
      Height = 33
      Action = actExit
      Align = alCustom
      TabOrder = 3
    end
    object stProgName: TStaticText
      Left = 192
      Top = 0
      Width = 415
      Height = 264
      Align = alCustom
      Caption = 'Maze'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 260
      Font.Name = 'ISOCPEUR'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
  end
  object alBtns: TActionList
    Left = 16
    Top = 472
    object actGen: TAction
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1083#1072#1073#1080#1088#1080#1085#1090
      OnExecute = actGenExecute
    end
    object actHistory: TAction
      Caption = #1048#1089#1090#1086#1088#1080#1103
      OnExecute = actHistoryExecute
    end
    object actStat: TAction
      Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
      OnExecute = actStatExecute
    end
    object actExit: TAction
      Caption = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actAbout: TAction
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
    end
  end
end
