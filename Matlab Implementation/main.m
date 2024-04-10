clc, clear, close all

Cnt0 = [0 0];
MyCnt = zeros(10000,1);

clear CheckMem;
ResFac = CreateMem();

for j = 1:50
    fprintf("\n");
    for i = 1:1e5
        mat = randi(3,3) - 1;
        res1 = CheckSlv(mat);
        res2 = CheckMem(mat);
        res3 = CheckMem2(mat, ResFac);

        if res1 ~= res2
            disp('error');
        end

        if res1 > 0
            Cnt0(res1) = Cnt0(res1)+1;
%             MyCnt(sum(Cnt0)) = Cnt0(1)/Cnt0(2);
%             plot(MyCnt(1:sum(Cnt0)));
%             pause(0.0001);
        end
    end
end