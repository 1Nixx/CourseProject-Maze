unit CreateNewMaze;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, MazeMain;

type
  TFCreateNewMaze = class(TForm)
    lbHead: TLabel;
    lbAlgGenText: TLabel;
    cbAlgGen: TComboBox;
    lbMazeSizeText: TLabel;
    cbMazeSize: TComboBox;
    btnCreateMaze: TButton;
    procedure btnCreateMazeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbAlgGenChange(Sender: TObject);
    procedure cbMazeSizeChange(Sender: TObject);
    procedure cbDelLbClick(Sender: TObject);
  private
    MazeAlgGen: TMazeGenAlg;
    MazeSize: TMazeSize;
    cbFlag1, cbFlag2: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses
  MainMenu, MazeView;

{$R *.dfm}

procedure TFCreateNewMaze.cbDelLbClick(Sender: TObject);
begin
   if (TComboBox(Sender).ItemIndex <> 0) and (TComboBox(Sender).Items[0] = 'Выбрать...') then
    TComboBox(Sender).Items.Delete(0);
end;

//Chose Generation Alg and SizeOf Maze
procedure TFCreateNewMaze.cbAlgGenChange(Sender: TObject);
begin
  if cbAlgGen.Items[0] = 'Выбрать...' then exit;

  MazeAlgGen := TMazeGenAlg(cbAlgGen.ItemIndex);
  cbFlag1 := True;
  if cbFlag2 = True then
  begin
    btnCreateMaze.Enabled := True;
    btnCreateMaze.SetFocus;
  end;
end;

procedure TFCreateNewMaze.cbMazeSizeChange(Sender: TObject);
begin
  if cbMazeSize.Items[0] = 'Выбрать...' then exit;

  MazeSize := TMazeSize(cbMazeSize.ItemIndex);
  cbFlag2 := True;
  if cbFlag1 = True then
  begin
    btnCreateMaze.Enabled := True;
    btnCreateMaze.SetFocus;
  end;
end;

//Show New Form
procedure TFCreateNewMaze.btnCreateMazeClick(Sender: TObject);
begin
  FMazeView.CreateFirstMaze(MazeSize, MazeAlgGen);
  FMazeView.Position := poOwnerFormCenter;
  FMazeView.Show(MainMenuForm);
end;

procedure TFCreateNewMaze.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self.Hide;
end;

end.
