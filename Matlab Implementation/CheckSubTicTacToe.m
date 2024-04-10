% A function that checks a regular tic tac toe games and tells the status
% of the game. 
% Developed: Roshan Mathew Tom (4/9/2024)
% Inputs: Mat (a 3x3 matrix corresponding to a board)
%               0 - No marks
%               1 - O mark
%               2 - X mark
% Outputs: Win
%     -1: illegal position (e.g. 2 horizontal solutions)
%     0: Game drawn or no current winner
%     1: O won
%     2: X won

function Win = CheckSubTicTacToe(Mat)

    % A solution is defined as a condition of three Xs or Os in row (i.e. 
    % if you get a solution then you win the game)

    ResMatrix = zeros(3,3);

    % Checks for horizontal solution
    for i = 1:3
        % Checking the row/column has an O or X. 
        if Mat(i,1) > 0
            if Mat(i,1) == Mat(i,2) && Mat(i,1) == Mat(i,3)  
                ResMatrix(1,i) = Mat(i,1);
            end
        end
    end

    % Its illegal to have two or more horizontal solutions
    if sum(ResMatrix(1,:) > 0) > 1
        Win = -1;
        return;
    end

    % Check for vertical solution
    for i = 1:3
        % Checking the row/column has an O or X. 
        if Mat(1,i) > 0
            if Mat(1,i) == Mat(2,i) && Mat(1,i) == Mat(3,i)
                ResMatrix(2,i) = Mat(1,i);               
            end
        end
    end

    % Its illegal to have two or more vertical solutions
    if sum(ResMatrix(2,:) > 0) > 1
        Win = -1;
        return;
    end

    % There can only be two solutions of same kind in horizontal and
    % vertical positions. 2 is checked because 0 is the default solution. 
    %UniqueWins = unique(ResMatrix(:));
    if sum(max(ResMatrix,[],2)) == 3
        Win = -1;
        return;
    end


    % Check for diagonal solutions
    if Mat(2,2) > 0    
        if Mat(1,1) == Mat(2,2) && Mat(2,2) == Mat(3,3)
            ResMatrix(3,1) = Mat(2,2);
        end
        if  Mat(1,3) == Mat(2,2) && Mat(2,2) == Mat(3,1)
            ResMatrix(3,2) = Mat(2,2);
        end
    end

    % There can only be two solutions of same kind in horizontal and
    % vertical positions. 2 is checked because 0 is the default solution. 
    UniqueWins = unique(ResMatrix(:));
    if numel(UniqueWins) > 2
        Win = -1;
        return;
    elseif numel(UniqueWins) == 1
        Win = 0;        % No solutions, but legal positions set
        return;
    end

    % If only single solution found, then return since its a straighforward
    % win.
    NumSols = sum(ResMatrix(:) > 0);
    if NumSols == 1
        Win = max(ResMatrix(:));
        return;
    end

    %Start checking for multiple win solution combination (Edge Cases)

    WinNum = max(ResMatrix(:));
    
    hpos = find(ResMatrix(1,:) == WinNum);
    vpos = find(ResMatrix(2,:) == WinNum);
    dpos = find(ResMatrix(3,:) == WinNum);

    % This case is considered when there is both horizontal and vertical
    % win.
    if numel(hpos) > 0 && numel(vpos) > 0
 
        % If the two solutions are in the center then only one or zero diagonal
        % solutions
        % can exist, otherwise its illegal.
        if hpos == 2 && vpos == 2
            if numel(dpos) <= 1
                Win = WinNum;
                return;
            else
                Win = -1;
                return;
            end
        end

        % If the solutions are not in the center, then only zero diagonals
        % can exist. 
        if numel(dpos) > 0
            Win = -1;
            return;
        else
            Win = WinNum;
            return;
        end

    end

    % Both diagonals exisitng with horizontal and vertical is impossible
    if numel(dpos) == 2
        if numel(hpos) > 0 && numel(vpos) > 0
            Win = -1;
            return;
        end
    end

    % Checking for the edge cases when one horizontal/vertical exists with
    % one diagonal. Its always legal
    Win = WinNum;

end