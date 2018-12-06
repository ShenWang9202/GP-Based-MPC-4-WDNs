function totalcost = CalculateCost(Xsolution,CurrentK,Hp,PumpStatusHp,PricePatternVal24h,EnergyPumpMatrixIndex,NumberofX,IndexInVar)

    totalcost = [];
    simulationtime = 24; % be careful, not suit for simulation time that is longer than 24 hours.
%     WindowStart = mod(CurrentK-1+0,simulationtime)+1;
%     WindowEnd = mod(CurrentK-1+Hp-1,simulationtime)+1;
%     ElectricityPrice = PricePatternVal24h(WindowStart:WindowEnd);
    ElectricityPrice= [];
    for i = 1:Hp
        ElectricityPrice = [ElectricityPrice; PricePatternVal24h(mod(CurrentK-1+i-1,simulationtime)+1)];
    end
    
    for i = 1:Hp 
        SingleXIndexVector = ((i - 1) * NumberofX + 1):(i * NumberofX); % ingore the last step, since it is just the moment, not the a peroid of time.
        cost = PumpCostEachHp(Xsolution(SingleXIndexVector,:),EnergyPumpMatrixIndex,PumpStatusHp(i,:),ElectricityPrice(i),IndexInVar);
        totalcost = [totalcost ; cost];
    end


end