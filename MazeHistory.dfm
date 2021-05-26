object FHistory: TFHistory
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1048#1089#1090#1086#1088#1080#1103
  ClientHeight = 521
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtnos: TPanel
    Left = 0
    Top = 0
    Width = 201
    Height = 521
    Align = alLeft
    TabOrder = 0
    object btnExit: TButton
      Left = 24
      Top = 424
      Width = 153
      Height = 41
      Action = actRetBack
      TabOrder = 0
    end
    object btnOpenMaze: TButton
      Left = 24
      Top = 80
      Width = 153
      Height = 33
      Action = actOpen
      TabOrder = 1
    end
    object btnDeleteRecord: TButton
      Left = 24
      Top = 135
      Width = 153
      Height = 34
      Action = actDelRecord
      TabOrder = 2
    end
    object btnDeleteAllRecords: TButton
      Left = 24
      Top = 191
      Width = 153
      Height = 34
      Action = actDelAllRecords
      TabOrder = 3
    end
  end
  object pnlHistory: TPanel
    Left = 201
    Top = 0
    Width = 543
    Height = 521
    Align = alClient
    TabOrder = 1
    object lvHistory: TListView
      Left = 40
      Top = 48
      Width = 481
      Height = 417
      ParentCustomHint = False
      Align = alCustom
      Columns = <
        item
          Caption = #1048#1084#1103' '#1083#1072#1073#1080#1088#1080#1085#1090#1072
          Width = 98
        end
        item
          Caption = #1040#1083#1075'. '#1075#1077#1085#1077#1088#1072#1094#1080#1080
          Width = 95
        end
        item
          Caption = #1040#1083#1075'. '#1087#1088#1086#1093#1086#1078#1076#1077#1085#1080#1103
          Width = 106
        end
        item
          Alignment = taCenter
          Caption = #1056#1072#1079#1084#1077#1088
          Width = 57
        end
        item
          Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
          Width = -2
          WidthType = (
            -2)
        end>
      ColumnClick = False
      DoubleBuffered = True
      GridLines = True
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      ParentColor = True
      ParentDoubleBuffered = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      ViewStyle = vsReport
      OnCustomDrawItem = lvHistoryCustomDrawItem
      OnDblClick = actOpenExecute
    end
  end
  object actlBtns: TActionList
    OnUpdate = actlBtnsUpdate
    Left = 24
    Top = 16
    object actOpen: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100
      OnExecute = actOpenExecute
    end
    object actDelRecord: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      OnExecute = actDelRecordExecute
    end
    object actDelAllRecords: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1105
      OnExecute = actDelAllRecordsExecute
    end
    object actRetBack: TAction
      Caption = #1042' '#1075#1083#1072#1074#1085#1086#1077' '#1084#1077#1085#1102
      OnExecute = actRetBackExecute
    end
  end
end
