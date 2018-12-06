function [object,constraints] =  MPCObjPumpCost(X,CurrentK,EnergyPumpMatrixIndex,PumpStatusHp,XX0,NumberofX,Hp,verify,PricePatternVal24h,CostLastIteration,IndexInVar)
    [m,n] = size(X);
    if (verify)
        X = sym('X',[m,n]);
    end
    
    WindowStart = mod(CurrentK-1+0,24)+1;
    WindowEnd = mod(CurrentK-1+Hp-1,24)+1;
    ElectricityPrice = PricePatternVal24h(WindowStart:WindowEnd);

    
%     XX0 = XX0(NumberofX+1:end); % ingore the current step
%     XNew = X(NumberofX+1:end);
%     PumpStatusHp = PumpStatusHp(NumberofX+1:end);
    object = 0;
    constraints = [];
    for i = 1:Hp
        SingleXIndexVector = ((i - 1) * NumberofX + 1):(i * NumberofX);
        [obj_temp,~] = PumpCostObj4MPC(X(SingleXIndexVector,:),XX0(SingleXIndexVector,:),EnergyPumpMatrixIndex,PumpStatusHp(i,:),ElectricityPrice(i),IndexInVar);
        object = object + obj_temp;
        %constraints = [constraints;consts];
    end
    constraints = [constraints;object * CostLastIteration^(-1) <= 1];
    
 end