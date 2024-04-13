clc, clear, close all

% Tic Tac Toe To Play Against Computer.
MaximumDepth = 10;      % Maximum Calculating Depth
MaximumChilds = 4^7;    % Maximum trees to Calculate.

A = SuperTicTacToe();
for i = 1:81

    if rem(A.NumSteps,2) == 0
        A.ViewCurrentStatus();
        title("Your Turn");
        [x,y] = ginput(1);
        x = floor(x);
        y = floor(y);
        try
            MoveList = A.FindNextPossibleMove();
            if ismember([x,y],MoveList,'rows')
                [A,flg] = A.AddMove(x,y);
            else
                fprintf("\n Illegal Move: Try Again");
            end
        catch
            fprintf("\n Illegal Move: Pleasy Retry");
            continue;
        end
    else
        A.ViewCurrentStatus();
        title("Computing Calculating.....");
        shg;
        [prob,NextMove,~,AllParms] = FindMove(A,0,MaximumChilds,[0,0],[0,0,10,4]);
        fprintf("\n Maximum Depth of search is %i",AllParms(2));
        [A,flg] = A.AddMove(NextMove(1),NextMove(2));
        ProbRes = A.ScoreCurrentGrid();
    end

    
    if flg
        ProbRes = A.ScoreCurrentGrid();
        A.ViewCurrentStatus();

        if flg == 3
            title("Game Drawn!!!!");
        elseif flg == 1
            title("You (O) won");
        elseif flg == 2
            title("Computer (X) won");
        else
            title("Weird Behavior");
        end
        shg;

        break;
     end

    

end
