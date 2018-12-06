function [obj_temp,constraints] = PumpCostObj4MPC(X,X0,Pressure_Pump_Matrix_Index,PumpStatus,ElectricityPricePattern,IndexInVar)
    % variable =
    % [ head of Junction;
    %   head of reservior;
    %   head of tank;
    %   flow of pipe;
    %   flow of pump;
    %   flow of valve;
    %   speed of pump;]

    constraints = [];
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
 
    q_pump_start_index = min(IndexInVar.PumpFlowIndex);
    q_pump_end_index = max(IndexInVar.PumpFlowIndex);
    Q = X(q_pump_start_index:q_pump_end_index);
    H = X(h_start_index:h_end_index);
    s_start_index = min(IndexInVar.PumpSpeedIndex);
    s_end_index = max(IndexInVar.PumpSpeedIndex);
    S =X(s_start_index:s_end_index);
    PumpEquation = IndexInVar.PumpEquation;
    h0_vector = PumpEquation(:,1);
    r_vector = PumpEquation(:,2);
    w_vector = PumpEquation(:,3);
    s = X0(s_start_index:s_end_index);
    q_pump = X0(q_pump_start_index:q_pump_end_index);

    
    a_s = h0_vector.*s;
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
    energyeff = (A +B.*q_pump +C.*q_pump.^2)/100;
    

    [m,~] = size(Pressure_Pump_Matrix_Index);
    f_mono = [];
    % PumpStatus
    obj_temp = 0;
    constraints=[];

    for i = 1:m
        if(PumpStatus(i))% if pump status open
            DeliveryIndex = Pressure_Pump_Matrix_Index(i,2);
            SuctionIndex = Pressure_Pump_Matrix_Index(i,1);
            monomial_temp = 1.0;
            costparameter = SpecificGravity*KWperHP/3960/energyeff(i,1)*ElectricityPricePattern*PriceBase;
            
            monomial_temp = monomial_temp *(Q(i))^((s(i)*s(i)*h0_vector(i) -  r_vector(i)*q_pump(i)^(w_vector(i))*(s(i)^(2-w_vector(i)))) *costparameter);
            %monomial_temp = monomial_temp *(Q(i))^(r_vector(i)*q_pump(i)^(w_vector(i))*(s(i)^(2-w_vector(i))) * costparameter) * S(i)^(a_s(i)*q_pump(i)*costparameter);
            %monomial_temp = monomial_temp * (H(SuctionIndex)^(-1) * H(DeliveryIndex))^(q_pump(i)*SpecificGravity*KWperHP/3960/energyeff(i)*ElectricityPricePattern*PriceBase);
            %constraints = [constraints;monomial_temp^(-1)<=1];
            obj_temp = obj_temp + monomial_temp;
        end
    end
end