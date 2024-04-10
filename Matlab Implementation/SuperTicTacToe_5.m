classdef SuperTicTacToe_5
    properties
        MainGrid; % The large 9*9 grid that contains all elements. 
        SolvedGrid; % The small 3*3 grid that stores the solved squares.
        NumSteps % The number of steps completed.
        NumArray % The history of all the steps
        AllWinProbs; % A list of all possibilities of win/lose (solv probab)
        AllResFac; %All result possibilities.
        ProbabMatrix; % The matrix multiplier to condense all probabilities into one.
        AltProMatrix; % Mirror of ProbabMatrix
    end
    
    methods
        function obj = SuperTicTacToe_5()
            obj.MainGrid = zeros(9,9);
            obj.SolvedGrid = -1*ones(3,3);  % Haven't put zeros since theoretically some small games can be drawn.
            obj.NumSteps = 0;
            obj.NumArray = zeros(81,2);
            obj.AllWinProbs = getSolvProbab_4();
            obj.AllResFac = CreateMem();

            obj.ProbabMatrix = [1 0 0 0 0 0 0 0;
                                0 1 0 0 0 0 0 0;
                                0 0 1 0 0 0 0 0;
                                0 0 0 1 0 0 0 0;
                                0 0 0 0 1 0 0 0;
                                0 0 0 0 0 1 0 0;
                                0 0 0 0 0 0 1 0;
                                0 0 0 0 0 0 0 1];

            obj.AltProMatrix = abs(obj.ProbabMatrix - 1);

        end
        
        function ViewCurrentStatus(obj,~)

            MoveList = obj.FindNextPossibleMove();
        
            if nargin == 1
                clf;
            end

            hold on;
            for x = 1:9
                for y = 1:9
                    xloc = floor((x-1)/3)+1;
                    yloc = floor((y-1)/3)+1; 

                    if obj.SolvedGrid(xloc,yloc) == 0
                        c = 'black';
                        mytxt = ".";
                    elseif obj.SolvedGrid(xloc,yloc) == 1
                        c = 'r';
                        mytxt = "O";
                    elseif obj.SolvedGrid(xloc,yloc) == 2
                        c = 'b';
                        mytxt = "X";
                    else
                        if obj.MainGrid(x,y) == 0
                            c = 'g';
                            mytxt = "";
                        elseif obj.MainGrid(x,y) == 1
                            c = 'r';
                            mytxt = "O";
                        else
                            c = 'b';
                            mytxt = "X";
                        end
                    end
                    
                    xv = [x x+1 x+1 x];
                    yv = [y y y+1 y+1];
                    
                    if ismember([x,y],MoveList,'rows')
                        patch(xv,yv,c,'FaceAlpha',0.1);
                    else
                        patch(xv,yv,c);
                    end
                    text(x+0.4,y+0.4,mytxt,"FontSize",14);

                end
            end

            xline(1,'LineWidth',2);
            xline(4,'LineWidth',2);
            xline(7,'LineWidth',2);
            xline(10,'LineWidth',2);
            yline(1,'LineWidth',2);
            yline(4,'LineWidth',2);
            yline(7,'LineWidth',2);
            yline(10,'LineWidth',2);
            hold off;


        
        end


        % A function to extract a subgame from the main grid to check to stuff
        % x = 1,2,3 | y = 1,2,3
        % if y is missing then x is taken as a number between 1 to 9.
        function SmallGame = ExtractSubGame(obj,x,y)
            if nargin == 2
                y = ceil(x/3);
                x = rem(x,3);
                if x == 0
                    x = 3;
                end
            end
            SmallGame = obj.MainGrid((x-1)*3+1:x*3,(y-1)*3+1:y*3);
        end

        function [obj,flg] = AddMove(obj,x,y)

            flg = 0;
            obj.NumSteps = obj.NumSteps + 1;
            obj.NumArray(obj.NumSteps,:) = [x,y];
    
            if rem(obj.NumSteps,2)
                XOval = 1;
            else
                XOval = 2;
            end
    
            if obj.MainGrid(x,y) == 0
                obj.MainGrid(x,y) = XOval;
            else
                error("\n Error:: Move added in occupied location");
            end
    
            % Check if solved or drawn and updating SolveGrid
            xloc = floor((x-1)/3)+1;
            yloc = floor((y-1)/3)+1;
            if obj.SolvedGrid(xloc,yloc) == -1
    
                %Res = CheckSlv2(obj.ExtractSubGame(xloc,yloc));
                Res = obj.CheckSolve(obj.ExtractSubGame(xloc,yloc));
                if Res == -1
                    error("\n Error:: Illegal subgame positions found");
                elseif Res == 1
                    %fprintf("\n Solved for O");
                    obj.SolvedGrid(xloc,yloc) = Res;
                elseif Res == 2
                    %fprintf("\n Solved for X");
                    obj.SolvedGrid(xloc,yloc) = Res;
                else
                    if(sum(obj.ExtractSubGame(xloc,yloc)==0,'all') == 0)
                        %fprintf("\n Sub Game Drawn");
                        obj.SolvedGrid(xloc,yloc) = Res;
                    end
                end
            else
                error("\n Error:: Move added in solved position");
            end

            %Res = CheckSlv2(obj.SolvedGrid); % This could potential be error prone since it contains "-1" as some of its enteries. The CheckSlv was written with 0,1,2 in mind.
            TempVar = obj.SolvedGrid;
            TempVar(TempVar == -1) = 0;
            Res = obj.CheckSolve(TempVar);
            %Res = obj.CheckSolve(obj.SolvedGrid);
            if Res == 1
                %fprintf("\n Game Finished:: O won");
                flg = 1;
            elseif Res == 2
                %fprintf("\n Game Finished:: X won");
                flg = 2;
            elseif Res == 0   
                MoveList = obj.FindNextPossibleMove();
                if isempty(MoveList)
                    %fprintf("\n Game Drawn");
                    flg = 3;
                end
            end
    
        end

        function MoveGame = FindNextGrid(obj)

            if obj.NumSteps == 0
                MoveGame = [0,0];
            else
                LastMove = obj.NumArray(obj.NumSteps,:);
                xloc = floor((LastMove(1)-1)/3)+1;
                yloc = floor((LastMove(2)-1)/3)+1;
                if obj.SolvedGrid(xloc,yloc) >= 0
                    MoveGame = [0,0];
                else
                    xrel = LastMove(1) - (xloc-1)*3;
                    yrel = LastMove(2) - (yloc-1)*3;

                    if obj.SolvedGrid(xrel,yrel) >= 0
                        MoveGame = [0,0];
                    else
                        MoveGame = [xrel,yrel];
                    end
                end

            end

        end


        function MoveList = FindNextPossibleMove(obj)
            
            % The first step can be anywhere
            if obj.NumSteps == 0
                MoveList = obj.FindEmptySpots();
                return;
            end

            LastMove = obj.NumArray(obj.NumSteps,:);

            % If the previous move resulted in a win then the next move can
            % be done anywhere legal in the grid.
            xloc = floor((LastMove(1)-1)/3)+1;
            yloc = floor((LastMove(2)-1)/3)+1;
            if obj.SolvedGrid(xloc,yloc) >= 0
                MoveList = obj.FindEmptySpots();
                return;
            end

            % Find the relative position of last placed move.
            xrel = LastMove(1) - (xloc-1)*3;
            yrel = LastMove(2) - (yloc-1)*3;

            % If the new position is solved then the next move can be done
            % anywhere legal in the grid
            if obj.SolvedGrid(xrel,yrel) >= 0
                MoveList = obj.FindEmptySpots();
                return;
            end

            SubGame = obj.ExtractSubGame(xrel,yrel);
            MoveList = zeros(9,2);
            NumMove = 0;
            for xv = 1:3
                for yv = 1:3
                    if SubGame(xv,yv) < 1
                        NumMove = NumMove + 1;
                        MoveList(NumMove,:) = [(xrel-1)*3 + xv,(yrel-1)*3 + yv];
                    end
                end
            end
            MoveList(NumMove+1:end,:) = [];

        end


        function EmptyList = FindEmptySpots(obj)

            EmptyList = zeros(81,2);
            NumEmpty = 0;
        
            for x = 1:9
                for y = 1:9
                    xloc = floor((x-1)/3)+1;
                    yloc = floor((y-1)/3)+1;
                    
                    if obj.SolvedGrid(xloc,yloc) == -1
                        
                        if obj.MainGrid(x,y) == 0
                            NumEmpty = NumEmpty + 1;
                            EmptyList(NumEmpty,:) = [x,y];
                        end

                    end
                end
            end

            EmptyList(NumEmpty+1:end,:) = [];
            
        end

        function MyProbab = ScoreCurrentGrid(obj)


            MyProbab = 1000;
            MoveGame = obj.FindNextGrid();
            if rem(obj.NumSteps+1,2)
                XOval = 1;
            else
                XOval = 2;
            end

            if MoveGame(1) == 0
                xlist = [1 2 3];
                ylist = [1 2 3];
            else
                xlist = MoveGame(1);
                ylist = MoveGame(2);
            end

            for Bi = xlist
                for Bj = ylist
    
                    Matx = zeros(3,3);
                    Mato = zeros(3,3);
                    thr = 3.^(8:-1:0);
        
                    for i = 1:3
                        for j = 1:3
                            CurGrid = obj.MainGrid((i-1)*3+1:i*3,(j-1)*3+1:j*3);
                            CurGrid = CurGrid(:);
                            Num = sum(thr.*CurGrid');

                            if i == Bi && j == Bj
                                if XOval == 1
                                    Matx(i,j) = obj.AllWinProbs(Num+1,2)/100;
                                    Mato(i,j) = obj.AllWinProbs(Num+1,4)/100;
                                else
                                    Matx(i,j) = obj.AllWinProbs(Num+1,5)/100;
                                    Mato(i,j) = obj.AllWinProbs(Num+1,1)/100;
                                end

                            else
                                Matx(i,j) = obj.AllWinProbs(Num+1,2)/100;
                                Mato(i,j) = obj.AllWinProbs(Num+1,1)/100;        
                            end
                        end
                    end
        
                    ProbX = zeros(8,1);
                    ProbO = zeros(8,1);
        
                    for i = 1:3
                        ProbX(i) = Matx(i,1)*Matx(i,2)*Matx(i,3);
                        ProbX(i+3) = Matx(1,i)*Matx(2,i)*Matx(3,i);
                        ProbO(i) = Mato(i,1)*Mato(i,2)*Mato(i,3);
                        ProbO(i+3) = Mato(1,i)*Mato(2,i)*Mato(3,i);
                    end
                    
                    ProbX(7) = Matx(1,1)*Matx(2,2)*Matx(3,3);
                    ProbX(8) = Matx(1,3)*Matx(2,2)*Matx(3,1);
                    ProbO(7) = Mato(1,1)*Mato(2,2)*Mato(3,3);
                    ProbO(8) = Mato(1,3)*Mato(2,2)*Mato(3,1);        
        
                    ProbX_Comb = obj.ProbabMatrix.*repmat(ProbX',[8 1]) +  obj.AltProMatrix.*repmat(1-ProbX',[8 1]);
                    ProbO_Comb = obj.ProbabMatrix.*repmat(ProbO',[8 1]) +  obj.AltProMatrix.*repmat(1-ProbO',[8 1]);
        
                    SProbX = sum(prod(ProbX_Comb,2));
                    SProbO = sum(prod(ProbO_Comb,2));
        
                    MyProbabTemp = (SProbO - SProbX)/(SProbO + SProbX);
%                     if rem(obj.NumSteps,2) == 0
%                         MyProbabTemp = MyProbabTemp + 0.1222/2;
%                     else
%                         MyProbabTemp = MyProbabTemp - 0.1222/2;
%                     end
                    if isnan(MyProbabTemp)
                        MyProbabTemp = 0;
                    end

                    if MyProbab == 1000
                        MyProbab = MyProbabTemp;

                    elseif XOval == 1
                        if MyProbabTemp > MyProbab
                            MyProbab = MyProbabTemp;
                        end
                    else
                        if MyProbabTemp < MyProbab
                            MyProbab = MyProbabTemp;
                        end
                    end

                    

                end
            end
           
        end


        function Win = CheckSolve(obj,Mat)
            
            thr = 3.^(8:-1:0);
            Mat = Mat(:);
            Num = sum(thr.*Mat');
            Win = obj.AllResFac(Num+1);
            
        end


        function Res = ProdMul(~,A,b)
            NumRows = size(A,1);
            Res = zeros(NumRows,1);
            for i = 1:NumRows
                Res(i) = A(i,:).*b';
            end

        end


    end
end