clc, clear, close all

ResCnt = [0 0 0];

rng(10);

figure;
%hold on;
AvgDiff = zeros(81,1);
AvgDiffCntr = zeros(81,1);
for Gm = 1:1000
    A = SuperTicTacToe();
    fprintf("\n ");
    PrString = [];

    for i = 1:81

        if rem(i,2) < 2
            PossibleMoves = A.FindNextPossibleMove();
            NumMoves = size(PossibleMoves,1);
            NextMove = randi(NumMoves,1);
            [A,flg] = A.AddMove(PossibleMoves(NextMove,1),PossibleMoves(NextMove,2));
        else
            [~,NextMove] = FindMove(A,0,10000,[0 0 0 0 0 0 0 0 0]);
            [A,flg] = A.AddMove(NextMove(1),NextMove(2));
        end
        ProbRes = A.ScoreCurrentGrid();

        %clc;
%         A.ViewCurrentStatus();
%         if ProbRes > 0
%             title(sprintf(" + %4.2f",ProbRes));
%         else
%             title(sprintf(" - %4.2f",-ProbRes));
%         end
%         pause(0.01);

        PrString = [PrString,ProbRes];
        

   
        %A.ViewCurrentStatus();
        if flg
            ResCnt(flg) = ResCnt(flg) + 1;
            fprintf("O wins = %i | X wins = %i | Draws = %i | Ratio = %f", ResCnt(1), ResCnt(2), ResCnt(3), ResCnt(1)/ResCnt(2));
            break;
        end
    
    end

    CurDiff = abs(diff(PrString));
    %plot(CurDiff);
    plot(AvgDiff./AvgDiffCntr,'LineWidth',2);
    AvgDiff(1:length(CurDiff)) = AvgDiff(1:length(CurDiff)) +  CurDiff';
    AvgDiffCntr(1:length(CurDiff)) = AvgDiffCntr(1:length(CurDiff)) +  1;
    pause(0.1);

end

plot(AvgDiff./AvgDiffCntr,'LineWidth',2);