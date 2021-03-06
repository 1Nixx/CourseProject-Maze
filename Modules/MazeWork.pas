unit MazeWork;

interface
uses
  MazeMain, MazeGen, MazeSolve, MazePrint;

  Procedure CreateMaze(var MazetoCreate: TMaze; var StatToWrite: TMazeStat; MazeSize: TMazeSize; MazeGenAlg: TMazeGenAlg);
  Procedure SetMazeDefIOCells(const MazeToFind: TMaze; var StatToWrite: TMazeStat);
  Procedure SolveMaze(const MazeSolve: TMaze; var Route, VisitedCells: TRoute; var StatToWrite: TMazeStat);
  Procedure SetNewStartPos(const MazeToFind: TMaze; var StatToWrite: TMazeStat; Height, Width: Integer; X, Y: Integer);
  Procedure SetNewExitPos(const MazeToFind: TMaze; var StatToWrite: TMazeStat; Height, Width: Integer; X, Y: Integer);
  procedure GenMazeFromStat(var MazeToGen: TMaze; const Stat: TMazeStat);

  implementation
uses
  SysUtils, Windows;

  //Set Array Size
  Procedure SetMazeSize(var MazeToUse: TMaze; SizeMaze: TMazeSize);
  begin
    SetLength(MazeToUse, MazeSize[SizeMaze, 0], MazeSize[SizeMaze, 1])
  end;

  //Choose alg to generate maze
  Procedure GenMaze(var MazeToGen: TMaze; const GenAlg: TMazeGenAlg; const EntryCell: TPos);
  begin
    case GenAlg of
      HuntAKill: GenMazeHuntAKill(MazeToGen, EntryCell);
      BackTrack: GenMazeBackTrack(MazeToGen, EntryCell);
      Prim: GenMazePrim(MazeToGen, EntryCell);
    end;
  end;

  //Choose alg to solve maze
  procedure FindRoute(const MazeToAnalyze: TMaze; var ExitRoute, FullRoute: TRoute; Start, ExitC: TPos; SolveAlg: TMazeSolveAlg);
  begin
    case SolveAlg of
      BFS: ExitRoute := SolveBFS(MazeToAnalyze, Start, ExitC, FullRoute);
      DFS: ExitRoute := SolveDFS(MazeToAnalyze, Start, ExitC, FullRoute);
      LeftHand: ExitRoute := SolveLeftHand(MazeToAnalyze, Start, ExitC, FullRoute);
      RightHand: ExitRoute := SolveRightHand(MazeToAnalyze, Start, ExitC, FullRoute);
    end;
  end;

  //Random Cell from maze
  Function GetRandStartCell(SizeInd: TMazeSize): TPos;
  begin
    Result.PosX := Random(MazeSize[SizeInd, 1]);
    Result.PosY := Random(MazeSize[SizeInd, 0]);
  end;

  //Create maze and write Statistic
  Procedure CreateMaze(var MazeToCreate: TMaze; var StatToWrite: TMazeStat; MazeSize: TMazeSize; MazeGenAlg: TMazeGenAlg);
  Var
    Start, Stop: Cardinal;
  begin
    //Randomize;
    //Write Stat
    StatToWrite.DateTime := Now;
    StatToWrite.MazeSize := MazeSize;
    StatToWrite.GenStartPos := GetRandStartCell(MazeSize);
    StatToWrite.MazeGenAlg := MazeGenAlg;

    //Generate maze
    SetMazeSize(MazeToCreate, MazeSize);
    CleanMaze(MazeToCreate);

    Start := GetTickCount;
    StatToWrite.MazeSeed := RandSeed;
    GenMaze(MazeToCreate, MazeGenAlg, StatToWrite.GenStartPos);
    Stop := GetTickCount;

    StatToWrite.TotalTime.GenTime := Stop-Start;
  end;

  //Write to statistic default Entry and Exit Points
  procedure SetMazeDefIOCells(const MazeToFind: TMaze; var StatToWrite: TMazeStat);
  begin
    StatToWrite.StartPoint := GetStartCell(MazeToFind);
    StatToWrite.EndPoint := GetExitCell(MazeToFind);
  end;

  //Solve maze and write statistic
  Procedure SolveMaze(const MazeSolve: TMaze; var Route, VisitedCells: TRoute; var StatToWrite: TMazeStat);
  Var
    //Start, Stop: Cardinal;
    iCounterPerSec: TLargeInteger;
    T1, T2: TLargeInteger;
  begin
    //Write Stat
    QueryPerformanceFrequency(iCounterPerSec);
    //Start := GetTickCount;
    QueryPerformanceCounter(T1);
    //Find route
    FindRoute(MazeSolve, Route, VisitedCells, StatToWrite.StartPoint, StatToWrite.EndPoint, StatToWrite.MazeSolveAlg);
    QueryPerformanceCounter(T2);
    //Stop := GetTickCount;

    StatToWrite.TotalTime.SolvingTime := Round((T2-T1)/iCounterPerSec * 1000);
    StatToWrite.VisitedCells.Route := Length(Route)-1;
    StatToWrite.VisitedCells.FullRoute := Length(VisitedCells)-1;
  end;

  //Set new Entry and Exit pos. Chec for avilebels
  Function SetMazeNewIOPos(const MazeToFind: TMaze; SizeMaze: TMazeSize; MazeDefPos: TPos;
                           Height, Width: Integer; PosX, PosY: Integer): TPos;
  var
    NewPos: TPos;
    BlockSizeX, BlockSizeY: Integer;
  begin
    Result := MazeDefPos;

    //Calc size of cell
    CalcCellSize(Width, Height, SizeMaze, BlockSizeX, BlockSizeY);

    //Calc New Pos
    NewPos.PosX := PosX div BlockSizeX - 2;
    NewPos.PosY := PosY div BlockSizeY - 2;

    //Check for availability
    if (NewPos.PosX >= 0) and (NewPos.PosY >= 0) and (NewPos.PosX < MazeSize[SizeMaze, 1])
       and (NewPos.PosY < MazeSize[SizeMaze, 0])and (MazeToFind[NewPos.PosY, NewPos.PosX] = Pass) then
      Result := NewPos;
  end;

  //Get user Entry point
  Procedure SetNewStartPos(const MazeToFind: TMaze; var StatToWrite: TMazeStat; Height, Width: Integer; X, Y: Integer);
  begin
    StatToWrite.StartPoint := SetMazeNewIOPos(MazeToFind, StatToWrite.MazeSize, StatToWrite.StartPoint, Height, Width, X, Y);
  end;

  //Get user out point
  Procedure SetNewExitPos(const MazeToFind: TMaze; var StatToWrite: TMazeStat; Height, Width: Integer; X, Y: Integer);
  begin
    StatToWrite.EndPoint := SetMazeNewIOPos(MazeToFind, StatToWrite.MazeSize, StatToWrite.EndPoint, Height, Width, X, Y);
  end;

  //Generate maze using statistic
  procedure GenMazeFromStat(var MazeToGen: TMaze; const Stat: TMazeStat);
  begin
    SetMazeSize(MazeToGen, Stat.MazeSize);
    CleanMaze(MazeToGen);
    RandSeed := Stat.MazeSeed;
    GenMaze(MazeToGen, Stat.MazeGenAlg, Stat.GenStartPos);
  end;

end.
