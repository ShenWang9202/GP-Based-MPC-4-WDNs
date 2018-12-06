function checkoutSolution(solution,Hp,IndexInVar)
    number = IndexInVar.NumberofX;
    h_start_index = min(IndexInVar.JunctionHeadIndex);
    h_end_index = max(IndexInVar.TankHeadIndex);
    for i = 1:Hp+1
        for j = h_start_index:h_end_index
            if(solution(j + (i-1)*number)<=0)
                disp('Negative pressure decteced!!!');
                return;
            end
        end
    end

end