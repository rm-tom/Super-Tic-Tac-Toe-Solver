function [MoveProbab,NextMove, MvCntr, MxDepth, BestMoves] = FindMove(A, n, AlwdIters, MvCntr, MxDepth, BestMoves)

% A recursive function to go to a certain depth in the tree and return the
% best move out of them all 
% Inputs: A is the SuperTicTacToe game, n is the depth
% Outputs: NextMove is the most likely move from this function, MoveProbab
% is the likelihood that the move wins

    MaxProceed = 4;

    MvCntr = MvCntr+1;
    if MxDepth < n
        MxDepth = n;
    end

    if AlwdIters <= 1 || n == 10       
        NextMove = A.NumArray(A.NumSteps,:);
        MoveProbab = A.ScoreCurrentGrid();
        return;
    end
    
    %Getting playing number: O:1, X:2
    if rem(A.NumSteps+1,2)
        XOval = 1;
    else
        XOval = 2;
    end

    PossibleMoves = A.FindNextPossibleMove();
    NumMoves = size(PossibleMoves,1);
    AllProbs = zeros(NumMoves,1);
    B = cell(NumMoves,1);
    flg = zeros(NumMoves,1);

    NextGrid = A.FindNextGrid();
    if NextGrid(1) == 0
        MaxProceed = 2*MaxProceed;
    end

    for i = 1:NumMoves
        [B{i},flg(i)] = A.AddMove(PossibleMoves(i,1),PossibleMoves(i,2));
        AllProbs(i) = B{i}.ScoreCurrentGrid();
    end

    %For testing
    if A.MainGrid(4,1) == 1 && A.MainGrid(4,3) == 1
        disp('1');
    end

    % Return the win positio if any of the possible moves results in the
    % win of a player.
    if sum(flg == XOval) > 0
        idx = flg == XOval;
        if XOval == 1
            MoveProbab = 1;
        else
            MoveProbab = -1;
        end
        NextMove = PossibleMoves(idx,:);
        NextMove = NextMove(1,:);
        BestMoves(n+1,:) = NextMove;
        return;
    end


    if XOval == 1
        [AllProbs,sindex] = sort(AllProbs,'descend');
    else
        [AllProbs,sindex] = sort(AllProbs);
    end

    if NumMoves > MaxProceed
        NumMoves = MaxProceed;
        sindex = sindex(1:MaxProceed);
    end
    AllProbs = AllProbs(1:NumMoves);
    PossibleMoves = PossibleMoves(sindex,:);
    Bs = cell(NumMoves,1);
    for i = 1:NumMoves
        Bs{i} = B{sindex(i)};
    end
    flg = flg(sindex);

    SentIters = round(AlwdIters/MaxProceed);

    BestMoveChoices = cell(4,1);

    for i = 1:NumMoves
        % Return 0 Probab if draw is detected.
        if flg(i) == 3
            AllProbs(i) = 0;

        % Return  1/-1 if the other player's win is detected.   
        elseif flg(i) > 0
            if flg(i) == XOval
                error("Win undetected in FindMove_5");
            end
            if XOval == 1
                AllProbs(i) = 1;
            else
                AllProbs(i) = -1;
            end 

        % Increase the depth of the simulation to get a better probabvalue.     
        else
            [AllProbs(i),~,MvCntr, MxDepth,BestMoveChoices{i}] = FindMove(Bs{i},n+1,SentIters,MvCntr, MxDepth,BestMoves);
        end
    end

    if XOval == 1
        [MoveProbab,ReturnInd] = max(AllProbs);
    else
        [MoveProbab,ReturnInd] = min(AllProbs);
    end
    NextMove = PossibleMoves(ReturnInd,:);
    BestMoves = BestMoveChoices{ReturnInd};
    BestMoves(n+1,:) = NextMove;

    

end