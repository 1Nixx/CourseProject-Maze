unit MazePrint;

interface
uses
  MazeMain, Graphics;

const
  clFullRoute = clWebLightGreen;
  clRoute = clGreen;
  clStartPoint = clRed;
  clExitPoint = clBlue;

  Procedure CalcCellSize(Width, Height: Integer; MazeInd: TMazeSize; out XSize, YSize: Integer);
  Procedure PrintMaze(const Canv: TCanvas; const MazeToPrint: TMaze; CellSizeX, CellSizeY: Integer);
  Procedure PrintRoute(const Canv: TCanvas; const RouteToPrint: TRoute; CellSizeX, CellSizeY: Integer; CellColor: TColor);
  Procedure PrintIOPoints(const Canv: TCanvas; const StartC, EndC: TPos; CellSizeX, CellSizeY: Integer);

implementation
  //Get cell size
  Procedure CalcCellSize(Width, Height: Integer; MazeInd: TMazeSize; out XSize, YSize: Integer);
  begin
    XSize := Trunc(Width/(MazeSize[MazeInd, 1]+4));
    YSize := Trunc(Height/(MazeSize[MazeInd, 0]+4));
  end;

  //Print Maze use rectangles
  Procedure PrintMaze(const Canv: TCanvas; const MazeToPrint: TMaze; CellSizeX, CellSizeY: Integer);
  //CellSizeX, CellSizeY - sizes of cells to paint
  var
    RectX, RectY: Integer;
    StartX{, StartY}: Integer;
    I, J: Integer;
  begin
    RectX := CellSizeX;
    RectY := CellSizeY;

    StartX := RectX;
    //StartY := RectY;
    with Canv do
    begin
      Brush.Color := clBlack;
      Pen.Color := clBlack;

      for I := Low(MazeToPrint[0]) to Length(MazeToPrint[0])+1 do
        Rectangle(RectX*(I+1), RectY, RectX*(I+1)+CellSizeX, RectY+CellSizeY);

      //Cycle fot lines
      for I := Low(MazeToPrint) to High(MazeToPrint) do
      begin
        RectX := StartX;
        RectY := RectY + CellSizeY;

        Rectangle(RectX, RectY, RectX+CellSizeX, RectY+CellSizeY);

        //Cycle for collumns
        //Print rectangle if Maze[i, J] - wall
        for J := Low(MazeToPrint[I]) to High(MazeToPrint[I]) do
          if MazeToPrint[I, J] = Wall then
            Rectangle(RectX*(J+2), RectY, RectX*(J+2)+CellSizeX, RectY+CellSizeY);

        Rectangle(RectX*(Length(MazeToPrint[I])+2), RectY, RectX*(Length(MazeToPrint[I])+2)+CellSizeX, RectY+CellSizeY);
      end;

      for I := Low(MazeToPrint[0]) to Length(MazeToPrint[0])+1 do
        Rectangle(RectX*(I+1), RectY+CellSizeY, RectX*(I+1)+CellSizeX, RectY+CellSizeY*2);

    end;

  end;

  //Print route cell by cell
  Procedure PrintRoute(const Canv: TCanvas; const RouteToPrint: TRoute; CellSizeX, CellSizeY: Integer; CellColor: TColor);
  var
    I: Integer;
  begin
    with Canv do
    begin
      Brush.Color := CellColor;
      Pen.Color := CellColor;
      for I := Low(RouteToPrint) to High(RouteToPrint) do
        Rectangle(CellSizeX*(RouteToPrint[I].PosX+2), CellSizeY*(RouteToPrint[I].PosY+2), CellSizeX*(RouteToPrint[I].PosX+2)+CellSizeX, CellSizeY*(RouteToPrint[I].PosY+2)+CellSizeY);
    end;
  end;

  //Print 2 points Entry and Exit
  Procedure PrintIOPoints(const Canv: TCanvas; const StartC, EndC: TPos; CellSizeX, CellSizeY: Integer);
  begin
    with Canv do
    begin
      Brush.Color := clStartPoint;
      Pen.Color := clStartPoint;
      Rectangle(CellSizeX*(StartC.PosX+2), CellSizeY*(StartC.PosY+2), CellSizeX*(StartC.PosX+2)+CellSizeX, CellSizeY*(StartC.PosY+2)+CellSizeY);
      Brush.Color := clExitPoint;
      Pen.Color := clExitPoint;
      Rectangle(CellSizeX*(EndC.PosX+2), CellSizeY*(EndC.PosY+2), CellSizeX*(EndC.PosX+2)+CellSizeX, CellSizeY*(EndC.PosY+2)+CellSizeY);
    end;
  end;

end.
