object FCreateNewMaze: TFCreateNewMaze
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1086#1079#1076#1072#1090#1100' '#1083#1072#1073#1080#1088#1080#1085#1090
  ClientHeight = 272
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lbHead: TLabel
    Left = 64
    Top = 16
    Width = 261
    Height = 24
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1083#1072#1073#1080#1088#1080#1085#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbAlgGenText: TLabel
    Left = 127
    Top = 66
    Width = 139
    Height = 17
    Caption = #1040#1083#1075#1086#1088#1080#1090#1084' '#1075#1077#1085#1077#1088#1072#1094#1080#1080':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbMazeSizeText: TLabel
    Left = 133
    Top = 128
    Width = 124
    Height = 17
    Caption = #1056#1072#1079#1084#1077#1088' '#1083#1072#1073#1080#1088#1080#1085#1090#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object cbAlgGen: TComboBox
    Left = 125
    Top = 89
    Width = 145
    Height = 21
    HelpType = htKeyword
    Style = csDropDownList
    DoubleBuffered = False
    ItemIndex = 0
    ParentDoubleBuffered = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    Text = #1042#1099#1073#1088#1072#1090#1100'...'
    OnChange = cbAlgGenChange
    OnClick = cbDelLbClick
    Items.Strings = (
      #1042#1099#1073#1088#1072#1090#1100'...'
      'Hunt-and-Kill'
      'Recursive backtracker'
      #1040#1083#1075#1086#1088#1080#1090#1084' '#1055#1088#1080#1084#1072)
  end
  object cbMazeSize: TComboBox
    Left = 125
    Top = 151
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 1
    Text = #1042#1099#1073#1088#1072#1090#1100'...'
    OnChange = cbMazeSizeChange
    OnClick = cbDelLbClick
    Items.Strings = (
      #1042#1099#1073#1088#1072#1090#1100'...'
      #1052#1072#1083#1099#1081
      #1057#1088#1077#1076#1085#1080#1081
      #1054#1075#1088#1086#1084#1085#1099#1081)
  end
  object btnCreateMaze: TButton
    Left = 125
    Top = 209
    Width = 145
    Height = 39
    Caption = #1057#1086#1079#1076#1072#1090#1100
    Enabled = False
    ModalResult = 6
    TabOrder = 2
    OnClick = btnCreateMazeClick
  end
end
