ElectricityPrice = PricePatternVal24h;
% without pump, return directly.
if(isempty(IndexInVar.PumpFlowIndex))
    disp('No pumps in this network. Returning!');
    return
end
%
SimulationTime = Constants4WDN.SimulationTime;
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
h_solution = XXSOLVE(h_start_index:h_end_index,1:SimulationTime);

% get the flow solution
q_pump_start_index = min(IndexInVar.PumpFlowIndex);
q_pump_end_index = max(IndexInVar.PumpFlowIndex);
q_solution = XXSOLVE(q_pump_start_index:q_pump_end_index,1:SimulationTime);

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



speed_pump_simulation = XXSOLVE(PumpSpeedIndexInVar,1:SimulationTime);
[M,T] = size(speed_pump_simulation)


% cacluate effiency for each pump
energyeff = (A +B.*q_solution +C.*q_solution.^2)/100;

cost = zeros(M,T);
for t=1:T
    for i = 1:M
        if(speed_pump_simulation(i,t))
            DeliveryIndex = EnergyPumpMatrixIndex(i,2);
            SuctionIndex = EnergyPumpMatrixIndex(i,1);
            
            headgain = h_solution(DeliveryIndex) - h_solution(SuctionIndex)
            q_solution(i,t)
            costi = headgain * q_solution(i,t)*SpecificGravity*KWperHP/3960/energyeff(i)*ElectricityPrice(t)*PriceBase;
            cost(i,t) = costi;
        end
    end
end