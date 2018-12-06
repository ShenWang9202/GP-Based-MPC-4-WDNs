clc;
clear;
close all;

% Create EPANET object using the INP file
inpname='tutorial4.inp'; 
% Net1 Net2 Net3 BWSN_Network_1 example tutorial2
d=epanet(inpname);
d.plot('nodes','yes','links','yes','highlightnode',{'1','8'},'highlightlink',{'7'},'fontsize',8);

%% Simulate all

% Another way to Simulate all
d.openHydraulicAnalysis;
d.initializeHydraulicAnalysis;
tstep=1; Velocity=[];Pressure=[];T=[]; Demand=[]; Head=[];Flows=[];TankVolume=[]; HeadLoss = [];
d.getTimeHydraulicStep
%d.setTimeHydraulicStep(1800);
%d.getTimeHydraulicStep
% index constant
TankIndex = Constants4WDN.TankIndex;
PumpIndex = Constants4WDN.PumpIndex;
SpeedIndexInXX0 = Constants4WDN.SpeedIndexInXX0;
% 
Head_Reservior = Constants4WDN.Head_Reservior;
Reservior_index = Constants4WDN.Reservior_index;
Hp = Constants4WDN.Hp;
ReferenceHead = Constants4WDN.ReferenceHead;

while (tstep>0)
    t=d.runHydraulicAnalysis;   %current simulation clock time in seconds.    
    Velocity=[Velocity; d.getLinkVelocity];
    Pressure=[Pressure; d.getNodePressure];
    Demand=[Demand; d.getNodeActualDemand];
    TankVolume=[TankVolume; d.getNodeTankVolume];
    HeadLoss=[HeadLoss; d.getLinkHeadloss];
    Head=[Head; d.getNodeHydaulicHead];
    Flows=[Flows; d.getLinkFlows];
    T=[T; t];
    tstep=d.nextHydraulicAnalysisStep;
end
d.closeHydraulicAnalysis
%% verify model
XX = [];
for i = 1:(Hp+1)
    XX = [XX Head(i,7) Head(i,1:6) Head(i,8)  Flows(i,1:9) 1];
end

XX = XX';
%test LinEQ4WDN
k = 1;
NodeDemand1 = getNodeDemand(k,d,Hp);
%verify Aeq beq
[Aeq,beq]=LinEQ4WDN(d,NodeDemand1,18,XX);
Aeq * XX - beq
%test nlcon4WDN
[c,ceq] = nlcon4WDN(XX,d,18);

