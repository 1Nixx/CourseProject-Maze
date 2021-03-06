Unit MazeGen;

interface
uses
  MazeMain;

  Procedure GenMazeHuntAKill(var MazeToCreate: TMaze; StartPoint: TPos);
  Procedure GenMazeBackTrack(var MazeToCreate: TMaze; Cell: TPos);
  Procedure GenMazePrim(var MazeToCreate: TMaze; StartPoint: TPos);

implementation
type
  TCource = (Up, Down, Right, Left);

  //Shuffle array with sides
  Procedure ShuffleArr(var ArrToShuffle: array of TCource);

    //Swap two elements
    Procedure Swap(var SwapArr: array of TCource; Ind1, Ind2: Integer);
    Var
      Temp: TCource;
    Begin
      Temp := SwapArr[Ind1];
      SwapArr[Ind1] := SwapArr[Ind2];
      SwapArr[Ind2] := Temp;
    End;

  Var
    I: Integer;
  Begin
    For I := 0 to High(ArrToShuffle)*2 do
      Swap(ArrToShuffle, Random(Length(ArrToShuffle)), Random(Length(ArrToShuffle)));
  End;

  //Check the direction of travel so that no loops are formed
  Function CheckCell(const MazeToCheck: TMaze; CellPos: TPos; Side: TCource): Boolean;

    //Return Y-1 pos, check for the Maze size
    Function GetYMinPos(const Arr: TMaze; YPos: Integer): Integer;
    begin
      if YPos = Low(Arr) then
        Result := YPos
      else
        Result := YPos - 1;
    end;

    //Resurn Y+1 pos, check for the Maze size
    Function GetYMaxPos(const Arr: TMaze; YPos: Integer): Integer;
    begin
      if YPos = High(Arr) then
        Result := YPos
      else
        Result := YPos + 1;
    end;

    //Resurn X-1 pos, check for the Maze size
    Function GetXMinPos(const Arr: TMaze; XPos: Integer): Integer;
    begin
      if XPos = Low(Arr[0]) then
        Result := XPos
      else
        Result := XPos - 1;
    end;

    //Resurn X+1 pos, check for the Maze size
    Function GetXMaxPos(const Arr: TMaze; XPos: Integer): Integer;
    begin
      if XPos = High(Arr[0]) then
        Result := XPos
      else
        Result := XPos + 1;
    end;

    //Return amount of passes around the cell with cell
    Function GetAmountOfPass(const ArrToCheck: TMaze; Point: TPos): Integer;
    var
      I, J: Integer;
    begin
      Result := 0;
      //Check maze from Cell.Y + 1 to Cell.Y - 1 and X +- 1
      //Check for the borders
      for I := GetYMinPos(ArrToCheck, Point.PosY) to GetYMaxPos(ArrToCheck, Point.PosY) do
        for J := GetXMinPos(ArrToCheck, Point.PosX) to GetXMaxPos(ArrToCheck, Point.PosX) do
          if ArrToCheck[I, J] = Pass then
            Inc(Result);
    end;

    //Return amount of passes behind the direction of movement of the cell
    Function GetOppositePass(const ArrToCheck: TMaze; Point: TPos; SideNow: TCource): Integer;

      //If dir Right or Left
      Function CheckLineX(Const ArrLine: TMaze; Ind1, Ind2, Line: Integer): Integer;
      var
        I: Integer;
      begin
        Result := 0;
        for I := Ind1 to Ind2 do
          if ArrLine[I, Line] = Pass then
            Inc(Result);
      end;

      //If dir Up or Down
      Function CheckLineY(Const ArrLine: TMaze; Ind1, Ind2, Line: Integer): Integer;
      var
        I: Integer;
      begin
        Result := 0;
        for I := Ind1 to Ind2 do
          if ArrLine[Line, I] = Pass then
            Inc(Result);
      end;

    Begin
      Case SideNow of
        Up: Result := CheckLineY(ArrToCheck, GetXMinPos(ArrToCheck, Point.PosX), GetXMaxPos(ArrToCheck, Point.PosX), GetYMaxPos(ArrToCheck, Point.PosY));
        Down: Result := CheckLineY(ArrToCheck, GetXMinPos(ArrToCheck, Point.PosX), GetXMaxPos(ArrToCheck, Point.PosX), GetYMinPos(ArrToCheck, Point.PosY));
        Right: Result := CheckLineX(ArrToCheck, GetYMinPos(ArrToCheck, Point.PosY), GetYMaxPos(ArrToCheck, Point.PosY), GetXMinPos(ArrToCheck, Point.PosX));
        Left: Result := CheckLineX(ArrToCheck, GetYMinPos(ArrToCheck, Point.PosY), GetYMaxPos(ArrToCheck, Point.PosY), GetXMaxPos(ArrToCheck, Point.PosX));
      End;
    End;

  Const
    ModifX: array [0 .. 3] of Integer = (0, 0, 1, -1);
    ModifY: array [0 .. 3] of Integer = (-1, 1, 0, 0);

  Begin
    Inc(CellPos.PosX, ModifX[Ord(Side)]);
    Inc(CellPos.PosY, ModifY[Ord(Side)]);

    {1. Check for the maze sizes
     2. Check front side for wall
     3. Sub The number of passes around the cell and the cell itself - Behind the direction of travel}
    If (CellPos.PosX < 0) or (CellPos.PosY < 0) or (CellPos.PosX > High(MazeToCheck[0])) or (CellPos.PosY > High(MazeToCheck)) then
      Result := False
    Else If (MazeToCheck[CellPos.PosY, CellPos.PosX] = Pass) then
      Result := False
    Else If GetAmountOfPass(MazeToCheck, CellPos) - GetOppositePass(MazeToCheck, CellPos, Side) = 0 then
      Result := True
    else
      Result := False;

  End;

  //Algorithm Hunt-and-Kill
  Procedure GenMazeHuntAKill(var MazeToCreate: TMaze; StartPoint: TPos);
  const
    isMazeGenerated = -3;

    //Breaking the path until there's nowhere to go
    Procedure Walk(var MazeToGen: TMaze; const StartP: TPos);
    Const
      ModifX: array [0 .. 3] of Integer = (0, 0, 1, -1);
      ModifY: array [0 .. 3] of Integer = (-1, 1, 0, 0);

    Var
      Cell: TPos;
      CourceNow: TCource;
      NumberOfCheckSides: Integer;
      DirFound: Boolean;
      Dir: array of TCource;

    Begin
      Dir := [Up, Down, Right, Left];
      Cell := StartP;

      MazeToGen[Cell.PosY, Cell.PosX] := Pass;

      //Repeats until it runs into a hopeless situation
      Repeat

        DirFound := False;
        NumberOfCheckSides := 0;
        ShuffleArr(Dir);

        //Checking each direction of travel
        While (NumberOfCheckSides < 4) and not DirFound do
        Begin

          CourceNow := Dir[NumberOfCheckSides];
          If CheckCell(MazeToGen, Cell, CourceNow) then
          Begin

            Inc(Cell.PosX, ModifX[Ord(CourceNow)]);
            Inc(Cell.PosY, ModifY[Ord(CourceNow)]);

            MazeToGen[Cell.PosY, Cell.PosX] := Pass;
            DirFound := True;
          End
          else
            Inc(NumberOfCheckSides);

        End;
      Until (NumberOfCheckSides >= 4) or not DirFound;
    End;

    //Finding the first free cell to continue the path
    Function Hunt(const MazeToGen: TMaze): TPos;

      //Find available cells near cell
      Function CheckNeighbors(const MazeWithCell: TMaze; CellToCheck: TPos): Boolean;
      Const
        Dir: array [0..3] of TCource = (Up, Down, Right, Left);
      Var
        CourceNow: TCource;
      Begin
        Result := False;
        For CourceNow in Dir do
          If CheckCell(MazeWithCell, CellToCheck, CourceNow) then
            Result := True;
      End;

    Var
      PointFound: Boolean;
      Cell: TPos;
    Begin
      Result.PosX := isMazeGenerated;
      PointFound := False;
      //Check all cells of maze
      Cell.PosY := 0;
      While (Cell.PosY <= High(MazeToGen)) and not PointFound do
      Begin
        Cell.PosX := 0;
        While (Cell.PosX <= High(MazeToGen[Cell.PosY])) and not PointFound do
        Begin
          //If Pass and there are available direcrion, return Cell
          If (MazeToGen[Cell.PosY, Cell.PosX] = Pass) and CheckNeighbors(MazeToGen, Cell) then
          Begin
            Result := Cell;
            PointFound := True;
          End;
          Inc(Cell.PosX);
        End;
        Inc(Cell.PosY);
      End;

    End;

  Var
    Position: TPos;

  Begin
    Position := StartPoint;
    While Position.PosX <> isMazeGenerated do
    Begin
      Walk(MazeToCreate, Position);
      Position := Hunt(MazeToCreate);
    End;
  End;

  //Algorithm BackTracker
  Procedure GenMazeBackTrack(var MazeToCreate: TMaze; Cell: TPos);
  Var
    Dir: array of TCource;
    CourceNow: TCource;
    NewCell: TPos;
  Begin
    Dir := [Up, Down, Right, Left];
    MazeToCreate[Cell.PosY, Cell.PosX] := Pass;
    ShuffleArr(Dir);

    //Check each direction for a cell
    For CourceNow in Dir do
    Begin
      //If direction available, break wall
      If CheckCell(MazeToCreate, Cell, CourceNow) then
      Begin

        NewCell := Cell;
        Case CourceNow of
          Up: Dec(NewCell.PosY);
          Down: Inc(NewCell.PosY);
          Right: Inc(NewCell.PosX);
          Left: Dec(NewCell.PosX);
        End;

        GenMazeBackTrack(MazeToCreate, NewCell);
      End
    End;
  End;

  //Algorithm Prims
  Procedure GenMazePrim(var MazeToCreate: TMaze; StartPoint: TPos);
  Type
    TFront = array of TPos;

    //Add Neighbors for a cell to Array
    Procedure AddNeighbors(const MazeToCmp: TMaze; var SetOfPoints: TFront; PosToCheck: TPos);

      //Add Neighbors
      Procedure AddPointToFront(var ArrWithPoints: TFront; Pos: TPos; Direction: TCource);
      const
        ModifX: array [0..3] of Integer = (0, 0, 1, -1);
        ModifY: array [0..3] of Integer = (-1, 1, 0, 0);
      Var
        NewPos: TPos;
      Begin
        NewPos.PosX := Pos.PosX + ModifX[Ord(Direction)];
        NewPos.PosY := Pos.PosY + ModifY[Ord(Direction)];

        SetLength(SetOfPoints, Length(SetOfPoints)+1);
        SetOfPoints[High(SetOfPoints)] := NewPos;
      End;

      //Get array with broken walls and wtih cells which located in Queue
      Function GetShadowMaze(MazeToModif: TMaze; const Points: TFront): TMaze;
      Var
        I: Integer;
      Begin
        For I := 0 to High(Points) do
          MazeToModif[Points[I].PosY, Points[I].PosX] := Pass;
        Result := MazeToModif;
      End;

    Const
      Dir: array of TCource = [Up, Down, Right, Left];
    Var
      CourceNow: TCource;
    Begin
      //Check each direction for cell, and add Neighbors
      For CourceNow in Dir do
        If CheckCell(GetShadowMaze(MazeToCmp, SetOfPoints), PosToCheck, CourceNow) then
          AddPointToFront(SetOfPoints, PosToCheck, CourceNow);
    End;

    //Get random sell from array with neighbors
    Function GetRandomCell(var SetOfPoints: TFront): TPos;

    Var
      I: Integer;
    Begin
      I := Random(Length(SetOfPoints));

      Result := SetOfPoints[I];
      SetOfPoints[I] := SetOfPoints[High(SetOfPoints)];
      SetOfPoints[High(SetOfPoints)] := Result;

      SetLength(SetOfPoints, High(SetOfPoints));
    end;

  Var
    Frontier: TFront;
    Cell: TPos;
  Begin
    SetLength(Frontier, 1);
    Frontier[0] := StartPoint;
    While Length(Frontier) <> 0 do
    Begin
      Cell := GetRandomCell(Frontier);
      MazeToCreate[Cell.PosY, Cell.PosX] := Pass;
      AddNeighbors(MazeToCreate, Frontier, Cell);
    End;
  End;

end.
