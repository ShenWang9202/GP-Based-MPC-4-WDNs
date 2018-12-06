function [object,constraints] =  MPCObjSmoothness(X,XX0,NumberofX,Hp,verify,IndexInVar)
    PumpFlowIndex = IndexInVar.PumpFlowIndex;
    constraints = [];
    [m,~] = size(PumpFlowIndex);
    object = 0;
    for i = 2:(Hp+1)
        product = 1;
        for j = 1:m % m pumps
            IndexCurrentK = PumpFlowIndex(j) + (i-1)*NumberofX;
            IndexCurrentK_1 = PumpFlowIndex(j) + (i-2)*NumberofX;
            deltaq = XX0(IndexCurrentK) - XX0(IndexCurrentK_1);
            deltaq = deltaq/100;
            product = product * X(IndexCurrentK)^(-deltaq) * X(IndexCurrentK_1)^(deltaq);
        end
        constraints = [constraints;product<=1];
        object = object + product^(-1);
    end
end