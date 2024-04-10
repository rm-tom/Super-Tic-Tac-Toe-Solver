% A function that takes a every subgame possible game position 
% and assings a score for to calculate whether X or O wins
% Developed by: Roshan Mathew Tom (idea from Elliot Svennson)
% Inputs: None (MyMay, and MyRes can be ignored for now)
% Outputs: ResFac - A 3^9*5 sized array with 4 possible values 0 to 100
%             100 corresponds to definite win
%             0 corresponds to impossible win (usually when the game is drawn or other side wins)
%             Column 1: Score of O winning
%             Column 2: Score of X winning
%             Column 3: Score of game draw
%             Column 4: Score of O winning if O has the next move
%             Column 5: Score of X winning if X has the next move

function Res = getSolveProbs(MyMat, MyRes)

    persistent GetMatrix;

    if nargin <= 0

        if isempty(GetMatrix)
            NumAll = 3^9;
            Res = zeros(NumAll,5);
    
            for i = 1:NumAll
                mystr = dec2tern(i-1);
                WinNum = CheckSubTicTacToe(reshape(mystr,3,3));
                %disp(reshape(mystr,3,3));
    
                if WinNum == 1
                    Res(i,1:3) = [100, 0, 0];
                elseif WinNum == 2
                    Res(i,1:3) = [0, 100, 0];
                elseif WinNum == -1
                    Res(i,1:3) = [0, 0, 0];
                else
    
                    NumNone = sum(mystr == 0);
                    NumPoss = 3^(NumNone);      % Number of theoretical possible futures
                    WinCnters = [0 0 0];        
                    NumAdd = zeros(9,NumPoss);  % A matrix where each column represents a possible future plays. 
                    NumAdd(mystr == 0,:) = getbinarr(NumNone);
    
                    NumActPoss = 0;             % Number of actual possible futures
    
                    for cn = 1:NumPoss                    
                        NewMat = mystr + NumAdd(:,cn);
                        WinChk = CheckSubTicTacToe(reshape(NewMat,3,3));
    
                        % Only count the cases which are legal
                        if WinChk >= 0
                            NumActPoss = NumActPoss + 1;
                            % Since draw yields 0, I have to change it to 3. 
                            if WinChk == 0
                                WinChk = 3;
                            end
                            WinCnters(WinChk) = WinCnters(WinChk) + 1;
                        end
                    end
                    Res(i,1:3) = WinCnters/NumActPoss*100;
                end

            end

            % Adding the case when the next move is by a given piece. 
            thr = 3.^(8:-1:0);
            for i = 1:NumAll
                PossRes1 = zeros(9,1);
                PossRes2 = zeros(9,1);
                for j = 1:9
                    mystr1 = dec2tern(i-1);
                    mystr2 = dec2tern(i-1);
                    if mystr1(j) == 0
                        mystr1(j) = 1;
                        mystr2(j) = 2;
                    else
                        continue;
                    end

                    MyMat1 = mystr1(:);
                    MyMat2 = mystr2(:);
                    Num1 = sum(thr.*MyMat1');
                    Num2 = sum(thr.*MyMat2');
                    PossRes1(j) = Res(Num1+1,1);
                    PossRes2(j) = Res(Num2+1,2);
                end
                Res(i,4) = max(PossRes1);
                Res(i,5) = max(PossRes2);

            end

            GetMatrix = Res;

        else
            Res = GetMatrix;
        end


    else

        if isempty(GetMatrix)
            GetMatrix = getSolvProbab();
        end
    
        % Calculate probability.
        thr = 3.^(8:-1:0);
        MyMat = MyMat(:);
        Num = sum(thr.*MyMat');
        Res = MyRes(Num+1,:);

    end




end

function res = dec2tern(Num)
    res = zeros(9,1);
    for i = 1:9
        res(i) = floor(Num/3^(9-i));
        Num = rem(Num,3^(9-i));
    end
end

% This function makes an array of possible futures that a certain tic-tac-toe can have
% Input: Num (number of free spots)
% Output: binres (Num*3^(Num)) array. 
%         Each column repesents a possible future of tic-tac-toe.

function binres = getbinarr(Num)
    
    TotalNums = 3^Num;
    binres = zeros(Num,TotalNums);

    for i = 1:TotalNums
        BinNum = i-1;
        for j = 1:Num
            binres(j,i) = floor(BinNum/3^(Num-j));
            BinNum = rem(BinNum,3^(Num-j));
        end
    end

end