% A function that takes a every subgame possible game position 
% and assings the result of CheckSubTicTacToe
% Developed by: Roshan Mathew Tom (idea from Elliot Svennson)
% Inputs: None
% Outputs: ResFac - A 3^9 sized array with 4 possible values (-1,0,1,2)
%         Each position corresponds to the regular tic tac toe game correspoinidng the index in a base3 configuration. 
%         For e.g. if the index if 5, then the base3 number is 000000120, if we shapre it to a 3*3 matrix then you get the regular tic tac toe

function ResFac = CreateSubMemory()

    NumAll = 3^9;
    ResFac = -2*ones(NumAll,1);
    for i = 1:NumAll
        mystr = dec2tern(i-1);
        ResFac(i) = CheckSubTicTacToe(reshape(mystr,3,3));
    end

end


function res = dec2tern(Num)
    res = zeros(9,1);
    for i = 1:9
        res(i) = floor(Num/3^(9-i));
        Num = rem(Num,3^(9-i));
    end
end
