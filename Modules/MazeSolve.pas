unit MazeSolve;

Interface
Uses
  MazeMain;

  Function SolveBFS(const MazeToSolve: TMaze; const StartP, EndP: TPos; var AllVisitedCells: TRoute): TRoute;
  Function SolveDFS(const MazeToSolve: TMaze; Const StartP, EndP: TPos; var AllVisitedCells: TRoute): TRoute;
  Function SolveRightHand(const MazeToSolve: TMaze; Const StartP, EndP: TPos; var AllVisitedCells: TRoute): TRoute;
  Function SolveLeftHand(const MazeToSolve: TMaze; Const StartP, EndP: TPos; var AllVisitedCells: TRoute): TRoute;

Implementation
Type
  TCource = (Up, Down, Right, Left);

//Algorithm BFS
Function SolveBFS(const MazeToSolve: TMaze; const StartP, EndP: TPos; var AllVisitedCells: TRoute): TRoute;
Type
  TMazeInt = array of array of Integer;

  PQueueList = ^TQueueList;
  TQueueList = record
    Data: TPos;
    Next: PQueueList;
  end;

  TQueue = record
    PFirst, PLast: PQueueList;
  end;

  //Conver from type maze to numeric maze
  Procedure ConvertMaze(const Maze1: TMaze; var Maze2: TMazeInt);
  Var
    I, J: Integer;
  Begin
    For I := 0 to High(Maze1) do
      For J := 0 to High(Maze1[I]) do
        If Maze1[I, J] = Wall then
          Maze2[I, J] := -1
        else
          Maze2[I, J] := 0;
  End;

  Procedure Push(var Queue: TQueue; const Pos: TPos); overload;
  Var
    NewEl: PQueueList;
  Begin
    New(NewEl);

    NewEl^.Data := Pos;
    NewEl^.Next := nil;

    If Queue.PFirst = nil then
      Queue.PFirst := NewEl
    else
      Queue.PLast^.Next := NewEl;

    Queue.PLast := NewEl;
  End;

  Function Pop(var Queue: TQueue): TPos;
  Var
    NewEl: PQueueList;
  Begin
    If Queue.PFirst <> nil then
    Begin
      NewEl := Queue.PFirst;
      Result := NewEl^.Data;
      Queue.PFirst := NewEl^.Next;
      If Queue.PFirst = nil then
        Queue.PLast := nil;
      Dispose(NewEl);
    End;
  End;

  Function IsEmpty(const Queue: TQueue): Boolean;
  Begin
    Result := False;
    If (Queue.PFirst = nil) and (Queue.PLast = nil)then
      Result := True;
  End;

  Procedure QueueUnload(var Queue: TQueue);
  Var
    FData: TPos;
  Begin
    While not IsEmpty(Queue) do
      FData := Pop(Queue);
  End;

  Procedure QueueInit(var Queue: TQueue);
  Begin
    Queue.PFirst := nil;
    Queue.PLast := nil;
  End;

  Procedure Push(var Arr: TRoute; const Pos: TPos); overload;
  begin
    SetLength(Arr, Length(Arr)+1);
    Arr[High(Arr)] := Pos;
  end;

  //Wave alg fill maze numbers
  Procedure FillMazeNumbers(Var MazeToFill: TMazeInt; const PStart, PEnd: TPos; var VisitedCells: TRoute);

    //Fill nearest cells numbers? rerurn number of available cels
    Function FillNearestCells(var MazeToUse: TMazeInt; CellNow: TPos; WaveNow: Integer; var SetPoints: TQueue; var AllVisitP: TRoute): Integer;
    Const
      ModifX: array [0 .. 3] of Integer = (0, 0, 1, -1);
      ModifY: array [0 .. 3] of Integer = (-1, 1, 0, 0);
      Dir: array of TCource = [Up, Down, Right, Left];

    Var
      CourceNow: TCource;
      NewCell: TPos;
    Begin
      Result := 0;
      //Check each side
      For CourceNow in Dir do
      Begin
        NewCell := CellNow;
        Inc(NewCell.PosX, ModifX[Ord(CourceNow)]);
        Inc(NewCell.PosY, ModifY[Ord(CourceNow)]);

        //If available fill numb, push to the queue
        If (NewCell.PosX >= 0) and (NewCell.PosY >= 0) and (NewCell.PosY <= High(MazeToUse))
            and (NewCell.PosX <= High(MazeToUse[0])) and (MazeToUse[NewCell.PosY, NewCell.PosX] = 0) then
        Begin
          MazeToUse[NewCell.PosY, NewCell.PosX] := WaveNow;
          Push(SetPoints, NewCell);
          Push(AllVisitP, NewCell);
          Inc(Result);
        End;
      End;
    End;

  Var
    NumberWave, I: Integer;
    NewAmountPoints, AmountPoints: Integer;
    Cell: TPos;
    PointsToCheck: TQueue;
  Begin
    QueueInit(PointsToCheck);
    MazeToFill[PStart.PosY, PStart.PosX] := 1;

    Push(PointsToCheck, PStart);
    Push(VisitedCells, PStart);

    NumberWave := 1;
    AmountPoints := 0;

    //While not Finish do
    While MazeToFill[PEnd.PosY, PEnd.PosX] = 0 do
    Begin
      Inc(NumberWave);

      NewAmountPoints := 0;
      //Check cells from last check? get them from queue
      For I := 0 to AmountPoints do
      Begin
        Cell := Pop(PointsToCheck);
        Inc(NewAmountPoints, FillNearestCells(MazeToFill, Cell, NumberWave, PointsToCheck, VisitedCells))
      End;
      AmountPoints := NewAmountPoints-1;
    End;

    QueueUnload(PointsToCheck);
  End;

  //Restore the path
  Function GetRoute(const MazeToCheck: TMazeInt; const PStart, PEnd: TPos): TRoute;

  Var
    NumberCheck, NumberWave: Integer;
    Cell: TPos;
  Begin
    Cell := PEnd;

    NumberCheck := 0;
    NumberWave := MazeToCheck[PEnd.PosY, PEnd.PosX];
    SetLength(Result, 1);

    Result[NumberCheck] := Cell;

    //The cycle of finding the exit from the maze
    While (Cell.PosX <> PStart.PosX) or (Cell.PosY <> PStart.PosY) do
    Begin

      Dec(NumberWave);
      //Check for a wave and go back to the array, enter the path
      If (Cell.PosY > 0) and (MazeToCheck[Cell.PosY-1, Cell.PosX] = NumberWave) then
        Dec(Cell.PosY)
      else If (Cell.PosX > 0) and (MazeToCheck[Cell.PosY, Cell.PosX-1] = NumberWave) then
        Dec(Cell.PosX)
      else If (Cell.PosY < High(MazeToCheck)) and (MazeToCheck[Cell.PosY+1, Cell.PosX] = NumberWave) then
        Inc(Cell.PosY)
      else If (Cell.PosX < High(MazeToCheck[0])) and (MazeToCheck[Cell.PosY, Cell.PosX+1] = NumberWave) then
        Inc(Cell.PosX);

      Inc(NumberCheck);
      SetLength(Result, NumberCheck+1);
      Result[NumberCheck] := Cell;
    End;
  end;

Var
  ConvertedMaze: TMazeInt;

Begin
  SetLength(AllVisitedCells, 0);
  SetLength(ConvertedMaze, Length(MazeTosolve), Length(MazeTosolve[0]));
  ConvertMaze(MazeTosolve, ConvertedMaze);

  FillMazeNumbers(ConvertedMaze, StartP, EndP, AllVisitedCells);
  Result := GetRoute(ConvertedMaze, StartP, EndP);
end;

//Algorithm DFS
Function SolveDFS(const MazeToSolve: TMaze; Const StartP, EndP: TPos; var AllVisitedCells: TRoute): TRoute;
Type
  PStack = ^TStack;
  TStack= record
    Data: TPos;
    Next: PStack;
  end;

  Procedure Push(Var Stack: PStack; const Pos: TPos); overload;
  Var
    NewEl: PStack;
  Begin
    New(NewEl);

    NewEl^.Data := Pos;
    NewEl^.Next := Stack;

    Stack := NewEl;
  End;

  Function Pop(var Stack: PStack): TPos;
  Var
    BuffEl: PStack;
  Begin
    If Stack <> nil then
    Begin
      BuffEl := Stack;
      Result := BuffEl^.Data;
      Stack := BuffEl^.Next;
      Dispose(BuffEl);
    End;
  End;

  Function IsEmpty(const Stack: PStack): Boolean;
  Begin
    Result := False;
    If Stack = Nil then
      Result := True;
  End;

  Procedure ConvertToArr(var Stack: PStack; var ArrToUnload: TRoute);
  Begin
    While not IsEmpty(Stack) do
    Begin
      SetLength(ArrToUnload, Length(ArrToUnload)+1);
      ArrToUnload[High(ArrToUnload)] := Pop(Stack);
    End;
  End;

  Procedure StackInit(var Stack: PStack);
  Begin
    Stack := nil;
  End;

  Procedure StackUnload(var Stack: PStack);
  Var
    Buff: TPos;
  Begin
    while not IsEmpty(Stack) do
      Buff := Pop(Stack);
  End;

  Procedure Push(var Arr: TRoute; const Pos: TPos); overload;
  begin
    SetLength(Arr, Length(Arr)+1);
    Arr[High(Arr)] := Pos;
  end;

  procedure CopyMaze(const Maze1: TMaze; var Maze2: TMaze);
  var
    I, J: Integer;
  begin
    SetLength(Maze2, Length(Maze1), Length(Maze1[0]));
    for I := Low(Maze1) to High(Maze1) do
      for J := Low(Maze1[I]) to High(Maze1[I]) do
        Maze2[I, J] := Maze1[I, J];
  end;

  Var
  Cell: TPos;
  CellStack: PStack;
  MazeSolve: TMaze;
Begin
  CopyMaze(MazeToSolve, MazeSolve);

  SetLength(AllVisitedCells, 0);
  StackInit(CellStack);

  Cell := StartP;
  MazeSolve[Cell.PosY, Cell.PosX] := Visited;
  Push(CellStack, Cell);
  Push(AllVisitedCells, Cell);
  //While not finish
  While MazeSolve[EndP.PosY, EndP.PosX] = Pass do
  Begin

    //If cell available push to the stack, else return return back
    If (Cell.PosY > 0) and (MazeSolve[Cell.PosY-1, Cell.PosX] = Pass) then
    begin
      Dec(Cell.PosY);
      Push(AllVisitedCells, Cell);
    end
    else If (Cell.PosX > 0) and (MazeSolve[Cell.PosY, Cell.PosX-1] = Pass) then
    begin
      Dec(Cell.PosX);
      Push(AllVisitedCells, Cell);
    end
    else If (Cell.PosY < High(MazeSolve)) and (MazeSolve[Cell.PosY+1, Cell.PosX] = Pass) then
    begin
      Inc(Cell.PosY);
      Push(AllVisitedCells, Cell);
    end
    else If (Cell.PosX < High(MazeSolve[0])) and (MazeSolve[Cell.PosY, Cell.PosX+1] = Pass) then
    begin
      Inc(Cell.PosX);
      Push(AllVisitedCells, Cell);
    end
    else
    begin
      Cell := Pop(CellStack);
      Cell := Pop(CellStack);
    end;

    MazeSolve[Cell.PosY, Cell.PosX] := Visited;
    Push(CellStack, Cell);
  End;
  ConvertToArr(CellStack, Result);
  StackUnload(CellStack);
End;

//Algorithm Right and left hand
Function FindRouteHand(const MazeToFind: TMaze; Const StartP, EndP: TPos; Hand: TCource): TRoute;

  //if (Right hand) wall on the right return true
  Function IsSideWall(const MazeToCheck: TMaze; Pos: TPos; DirNow, HandNow: TCource): Boolean;

    //Get true orientation
    Function GetSideDir(CourceNew, HandToUse: TCource): TCource;
    Const
      LeftConvert: array [0..3] of TCource = (Left, Right, Up, Down);
      RightConvert: array [0..3] of TCource = (Right, Left, Down, Up);
    Begin
      If HandToUse = Left then
        Result := LeftConvert[Ord(CourceNew)]
      else
        Result := RightConvert[Ord(CourceNew)];
    End;

  Const
    ModifX: array [0..3] of Integer = (0, 0, 1, -1);
    ModifY: array [0..3] of Integer = (-1, 1, 0, 0);
  Var
    CheckCource: TCource;
    NewPos: TPos;
  Begin
    CheckCource := GetSideDir(DirNow, HandNow);
    NewPos.PosY := Pos.PosY + ModifY[Ord(CheckCource)];
    NewPos.PosX := Pos.PosX + ModifX[Ord(CheckCource)];

    If (NewPos.PosX < 0) or (NewPos.PosY < 0) or (NewPos.PosX > High(MazeToCheck[0])) or (NewPos.PosY > High(MazeToCheck)) then
      Result := True
    else If MazeToCheck[NewPos.PosY, NewPos.PosX] = Wall then
      Result := True
    else
      Result := False;
  End;

  //Check for the front wall
  Function IsFrontWall(const MazeToCheck: TMaze; Pos: TPos; DirNow: TCource): Boolean;
  Const
    ModifX: array [0..3] of Integer = (0, 0, 1, -1);
    ModifY: array [0..3] of Integer = (-1, 1, 0, 0);
  Var
    NewPos: TPos;
  Begin
    NewPos.PosX := Pos.PosX + ModifX[Ord(DirNow)];
    NewPos.PosY := Pos.PosY + ModifY[Ord(DirNow)];
    If (NewPos.PosX < 0) or (NewPos.PosY < 0) or (NewPos.PosX > High(MazeToCheck[0])) or (NewPos.PosY > High(MazeToCheck)) then
      Result := True
    else If MazeToCheck[NewPos.PosY, NewPos.PosX] = Wall then
      Result := True
    else
      Result := False;
  end;

  //If Hit the wall correct direction
  Function CorrectCource(DirNow, HandNow: TCource): TCource;
  Const
    Sides: array of TCource = [Down, Right, Up, Left];
  Var
    I, DirPos: Integer;
  Begin
    For I := Low(Sides) to High(Sides) do
      If Sides[I] = DirNow then
        DirPos := I;

    If HandNow = Left then
      If DirNow = Down then
        Result := Left
      else
        Result := Sides[Pred(DirPos)]
    else
      If DirNow = Left then
        Result := Down
      else
        Result := Sides[Succ(DirPos)];
  end;

  //Answer
  Procedure Push(var Route: TRoute; Pos: TPos);
  begin
    SetLength(Route, Length(Route)+1);
    Route[High(Route)] := Pos;
  end;

Const
  ModifX: array [0..3] of Integer = (0, 0, 1, -1);
  ModifY: array [0..3] of Integer = (-1, 1, 0, 0);

Var
  CourceNow: TCource;
  PosNow: TPos;
Begin
  CourceNow := Right;
  PosNow := StartP;

  Push(Result, PosNow);
  //while not Finish
  While (PosNow.PosX <> EndP.PosX) or (PosNow.PosY <> EndP.PosY) do
  Begin
    //IF right side - Pass -> Rotate
    If IsSideWall(MazeToFind, PosNow, CourceNow, Hand) then
      If IsFrontWall(MazeToFind, PosNow, CourceNow) then
        CourceNow := CorrectCource(CourceNow, Hand)
      else
      Begin
        Inc(PosNow.PosX, ModifX[Ord(CourceNow)]);
        Inc(PosNow.PosY, ModifY[Ord(CourceNow)]);
      End
    else
    Begin
      If Hand = Right then
        CourceNow := CorrectCource(CourceNow, Left)
      else
        CourceNow := CorrectCource(CourceNow, Right);

      Inc(PosNow.PosX, ModifX[Ord(CourceNow)]);
      Inc(PosNow.PosY, ModifY[Ord(CourceNow)]);
    End;
    Push(Result, PosNow);
  End;

end;

//Algorithm Right hand
Function SolveRightHand(const MazeToSolve: TMaze; Const StartP, EndP: TPos; var AllVisitedCells: TRoute): TRoute;
begin
  Result := FindRouteHand(MazeToSolve, StartP, EndP, Right);
  AllVisitedCells := Result;
end;

//Algorithm Left hand
Function SolveLeftHand(const MazeToSolve: TMaze; Const StartP, EndP: TPos; var AllVisitedCells: TRoute): TRoute;
begin
  Result := FindRouteHand(MazeToSolve, StartP, EndP, Left);
  AllVisitedCells := Result;
end;

end.
