function [MoveProbab,NextMove, BestMoves,AllParm] = FindMove(A, n, AlwdIters, BestMoves, AllParm)

% A recursive function to go to a certain depth in the tree and return the
% best move out of them all 
% Inputs: A is the SuperTicTacToe game, n is the depth, AllParms is a set,
% Alwditers is the number of total child function each function can have.
% This number is divided into each child cells. Best Moves is the track 
% predicted by the algorithm. To be used for debuggin only
% of parameters that control the recursive Algorithm.
%     AllParm(1) = The number of times the function has been called. 
%     AllParm(2) = The Maximum that the system went to
%     AllParm(3) = The maximum limit of the depth
%     AllParm(4) = The maximum number of childs that each recursion can
%     take. 
% Outputs: NextMove is the most likely move from this function, MoveProbab
% is the likelihood that the move wins

    AllParm(1) = AllParm(1)+1;
    if AllParm(2) < n
        AllParm(2) = n;
    end

    if AlwdIters <= 1 || n == AllParm(3)       
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
        MaxProceed = 2*AllParm(4);
    else
        MaxProceed = AllParm(4);
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
            [AllProbs(i),~,BestMoveChoices{i},AllParm] = FindMove(Bs{i},n+1,SentIters,BestMoves,AllParm);
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