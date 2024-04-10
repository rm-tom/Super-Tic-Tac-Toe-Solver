clc, clear, close all

% Tic Tac Toe To Play Against Computer.

ResCnt = [0 0 0];

for Gm = 1:1
    A = SuperTicTacToe();
    for i = 1:50

        A.ViewCurrentStatus();
        [x,y] = ginput(1);
        x = floor(x);
        y = floor(y);
        try
            [A,flg] = A.AddMove(x,y);
        catch
            continue;
        end

        %close all;
        
        ProbRes = A.ScoreCurrentGrid();
        A.ViewCurrentStatus();
        if ProbRes > 0
            title(sprintf(" + %4.2f",ProbRes));
        else
            title(sprintf(" - %4.2f",-ProbRes));
        end
        pause(0.0001);
        
        if flg
            ResCnt(flg) = ResCnt(flg) + 1;
            break;
         end


        [prob,NextMove,~,MaxDepth, BestMoves] = FindMove(A,0,8192,0,0,[0,0]);

        

        fprintf("\n Maximum Depth of search is %i",MaxDepth);
        [A,flg] = A.AddMove(NextMove(1),NextMove(2));
        ProbRes = A.ScoreCurrentGrid();


    
    end
end