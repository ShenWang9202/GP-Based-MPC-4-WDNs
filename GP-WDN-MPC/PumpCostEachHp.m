function cost = PumpCostEachHp(Xsolution,Pressure_Pump_Matrix_Index,PumpStatus,ElectricityPricePattern,IndexInVar)
    % variable =
    % [ head of Junction;
    %   head of reservior;
    %   head of tank;
    %   flow of pipe;
    %   flow of pump;
    %   flow of valve;
    %   speed of pump;]
    
    % without pump, return directly.
    if(isempty(IndexInVar.PumpFlowIndex))
        disp('No pumps in this network. Returning!');
        return
    end

    % getting start index of head in var
    h_start_index = min(IndexInVar.JunctionHeadIndex);
    % getting end index of head in var
    if(~isempty(IndexInVar.TankHeadIndex))
        h_end_index = max(IndexInVar.TankHeadIndex);
    else % without valves, check reservoirs
        if (~isempty(IndexInVar.ReservoirHeadIndex))
            h_end_index = max(IndexInVar.ReservoirHeadIndex);
        else % without reservoirs, only Junctions
            h_end_index = max(IndexInVar.JunctionHeadIndex);
        end
    end
    % get the head solution
    h_solution = Xsolution(h_start_index:h_end_index);

    % get the flow solution
    q_pump_start_index = min(IndexInVar.PumpFlowIndex);
    q_pump_end_index = max(IndexInVar.PumpFlowIndex);
    q_solution = Xsolution(q_pump_start_index:q_pump_end_index);

    % Load constant from constant4WDN class
    SpecificGravity = Constants4WDN.SpecificGravity;
    KWperHP = Constants4WDN.KWperHP;
    PriceBase = Constants4WDN.PriceBase;
    
    % go and check GeneratePumpEffiCurve.m file
    A1 = Constants4WDN.A1;
    B1 = Constants4WDN.B1;
    C1 = Constants4WDN.C1;
    %the second or the third pump effiency curve
    A2 = Constants4WDN.A2;
    B2 = Constants4WDN.B2;
    C2 = Constants4WDN.C2;
    
    A = [A1;A2;];
    B = [B1;B2;];
    C = [C1;C2;];
    
    % cacluate effiency for each pump
    energyeff = (A +B.*q_solution +C.*q_solution.^2)/100;
    

    [m,~] = size(Pressure_Pump_Matrix_Index);
    cost = zeros(1,m);
    for i = 1:m
        if(PumpStatus(i))
            DeliveryIndex = Pressure_Pump_Matrix_Index(i,2);
            SuctionIndex = Pressure_Pump_Matrix_Index(i,1);
            
            headgain = h_solution(DeliveryIndex) - h_solution(SuctionIndex);
            
            costi = headgain * q_solution(i)*SpecificGravity*KWperHP/3960/energyeff(i)*ElectricityPricePattern*PriceBase;
            cost(1,i) = cost(1,i) + costi;
        end
    end

end