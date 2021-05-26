unit About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfAbout = class(TForm)
    lbMaze: TLabel;
    mAbout: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfAbout.FormCreate(Sender: TObject);
const
  FileName = 'About.txt';
begin
  Try
    mAbout.Lines.LoadFromFile(FileName)
  Except
    ShowMessage('Не удается загрузить файл "'+FileName+'"');
  End;
end;


end.
