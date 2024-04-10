function ResFac = CreateMem()

    NumAll = 3^9;
    ResFac = -2*ones(NumAll,1);
    for i = 1:NumAll
        mystr = dec2tern(i-1);
        ResFac(i) = CheckSlv2(reshape(mystr,3,3));
    end

end


function res = dec2tern(Num)
    res = zeros(9,1);
    for i = 1:9
        res(i) = floor(Num/3^(9-i));
        Num = rem(Num,3^(9-i));
    end
end
