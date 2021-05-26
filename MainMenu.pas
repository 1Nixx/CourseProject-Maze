unit MainMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, CreateNewMaze, MazeView, MazeHistory, MazeStat, About,
  System.Actions, Vcl.ActnList;

type
  TMainMenuForm = class(TForm)
    pnButtons: TPanel;
    btnGenMaze: TButton;
    btnHistory: TButton;
    btnStat: TButton;
    btnExit: TButton;
    lbAbout: TLabel;
    alBtns: TActionList;
    actGen: TAction;
    actHistory: TAction;
    actStat: TAction;
    actExit: TAction;
    actAbout: TAction;
    stProgName: TStaticText;
    procedure lbAboutClick(Sender: TObject);
    procedure actGenExecute(Sender: TObject);
    procedure actHistoryExecute(Sender: TObject);
    procedure actStatExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainMenuForm: TMainMenuForm;

implementation

{$R *.dfm}

procedure TMainMenuForm.actExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

/////////////////////
//Events of buttons//
//Show others forms//
/////////////////////

procedure TMainMenuForm.actGenExecute(Sender: TObject);
var
  GenForm: TFCreateNewMaze;
  R: TModalResult;
begin
  GenForm := TFCreateNewMaze.Create(Self);
  GenForm.Position := poOwnerFormCenter;
  R := GenForm.ShowModal;
  FreeAndNil(GenForm);

  if R = mrYes then
    Self.Hide;
end;

procedure TMainMenuForm.actHistoryExecute(Sender: TObject);
begin
  Self.Hide;
  FHistory.Position := poOwnerFormCenter;
  FHistory.Show;
end;

procedure TMainMenuForm.actStatExecute(Sender: TObject);
begin
  Self.Hide;
  FStat.Position := poOwnerFormCenter;
  FStat.Show;
end;

procedure TMainMenuForm.lbAboutClick(Sender: TObject);
var
  AboutForm: TfAbout;
begin
  AboutForm := TfAbout.Create(Self);
  AboutForm.Position := poOwnerFormCenter;
  AboutForm.ShowModal;
  FreeAndNil(AboutForm);
end;



end.
