program Maze;

uses
  Vcl.Forms,
  MainMenu in 'MainMenu.pas' {MainMenuForm},
  MazeView in 'MazeView.pas' {FMazeView},
  CreateNewMaze in 'CreateNewMaze.pas' {FCreateNewMaze},
  MazeSaveMenu in 'MazeSaveMenu.pas' {FMazeSave},
  MazeGen in 'Modules\MazeGen.pas',
  MazeMain in 'Modules\MazeMain.pas',
  MazeSave in 'Modules\MazeSave.pas',
  MazeWork in 'Modules\MazeWork.pas',
  MazePrint in 'Modules\MazePrint.pas',
  MazeSolve in 'Modules\MazeSolve.pas',
  MazeHistory in 'MazeHistory.pas' {FHistory},
  MazeStat in 'MazeStat.pas' {fStat},
  About in 'About.pas' {fAbout},
  MazeStatistics in 'Modules\MazeStatistics.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainMenuForm, MainMenuForm);
  MainMenuForm.Position := poDesktopCenter;
  Application.CreateForm(TFMazeView, FMazeView);
  Application.CreateForm(TFHistory, FHistory);
  Application.CreateForm(TFStat, FStat);
  Application.Run;
end.

