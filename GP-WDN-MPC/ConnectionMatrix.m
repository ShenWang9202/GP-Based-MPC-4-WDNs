clc;
clear;
close all;
%% Hydraulic Analysis
% Create EPANET object using the INP file

NETWORK  = 4;
if(NETWORK == 1)
    inpname='tutorial4.inp';
end
if(NETWORK == 4)
%     inpname='tutorial4price13_copy.inp';
%     inpname1='tutorial4price13_copy.inp';
    inpname='BWSN_Network_modify_2.inp';
    inpname1='BWSN_Network_modify_2.inp';
end
if(NETWORK == 5)
%     inpname='tutorial4price13_copy.inp';
%     inpname1='tutorial4price13_copy.inp';
    inpname='BWSN_Network_1_original.inp';
    inpname1='BWSN_Network_1_original.inp';
end

d=epanet(inpname);
% d.plot('nodes','yes','links','yes','highlightnode',{'1','8'},'highlightlink',{'7'},'fontsize',8);

Velocity=[];
Pressure=[];
T=[];
Demand=[];
Head=[];
Flows=[];
TankVolume=[];
HeadLoss = [];
LinkSettings = [];
LinkStatus = [];

% Efficiency=[];
Energy=[];
PricePattern= [];
% Another way to Simulate all
d.openHydraulicAnalysis;
d.initializeHydraulicAnalysis;
tstep=1;
TimeStep = d.getTimeHydraulicStep;

% Index of components
PipeIndex = 1:d.getLinkPipeCount;
PumpIndex = d.getLinkPumpIndex;
ValveIndex = d.getLinkValveIndex;
NodeJunctionIndex = d.getNodeJunctionIndex;
ReservoirIndex = d.getNodeReservoirIndex;
TankIndex = d.getNodeTankIndex;

while (tstep>0)
    t=d.runHydraulicAnalysis;   %current simulation clock time in seconds.
    Velocity=[Velocity; d.getLinkVelocity];
    Pressure=[Pressure; d.getNodePressure];
    Demand=[Demand; d.getNodeActualDemand];
    TankVolume=[TankVolume; d.getNodeTankVolume];
    HeadLoss=[HeadLoss; d.getLinkHeadloss];
    Head=[Head; d.getNodeHydaulicHead];
    Flows=[Flows; d.getLinkFlows];
%     Efficiency=[Efficiency;d.getLinkEfficiency(PumpIndex)];
    Energy=[Energy;d.getLinkEnergy(PumpIndex)];
    T=[T; t];
    LinkSettings = [LinkSettings;d.getLinkSettings];
    LinkStatus = [LinkStatus;d.getLinkStatus];
    tstep=d.nextHydraulicAnalysisStep;
end
d.closeHydraulicAnalysis




%% Get Solution from EPANET
[m,~] = size(T);

%PipeIndex = d.getLinkPipeIndex; This method would miss the CVPIPE, e.g
%P446 in CTOWN
% So there is a bug in getLinkPipeIndex and getLinkPipeNameID functions,
% these two funcitons missed CVPIPE type.

% Pump and Valve Status
CurrentLinkStatus = d.getLinkStatus;
PumpStatus = CurrentLinkStatus(:,PumpIndex);
ValveStatus = CurrentLinkStatus(:,ValveIndex);

% Settings for all types of links
PipeRoughness = LinkSettings(:,PipeIndex);
PumpSpeed = LinkSettings(:,PumpIndex); % take effect when pumpstatus is open
ValveSettings = LinkSettings(:,ValveIndex);

SettingsNStatus = struct('PipeRoughness',PipeRoughness,...
    'PumpStatus',PumpStatus,'PumpSpeed',PumpSpeed,...
    'ValveSettings',ValveSettings,...
    'ValveStatus',ValveStatus);

if(NETWORK == 4) %BWSN_Network_1
    PumpEquation = [445.00 -1.947E-05 2.28;
        740.00 -8.382E-05 1.94;
        ];
end


%% Generate Mass and Energy Matrice
NodeNameID = d.getNodeNameID; % the Name of each node   head of each node
LinkNameID = d.getLinkNameID; % the Name of each pipe   flow of each pipe

NodesConnectingLinksID = d.getNodesConnectingLinksID; %
[m,n] = size(NodesConnectingLinksID);
NodesConnectingLinksIndex = zeros(m,n);

for i = 1:m
    for j = 1:n
        NodesConnectingLinksIndex(i,j) = find(strcmp(NodeNameID,NodesConnectingLinksID{i,j}));
    end
end
NodesConnectingLinksIndex
% Generate MassEnergyMatrix
[m1,n1] = size(NodeNameID);
[m2,n2] = size(LinkNameID);
MassEnergyMatrix = zeros(n2,n1);

for i = 1:m
    MassEnergyMatrix(i,NodesConnectingLinksIndex(i,1)) = -1;
    MassEnergyMatrix(i,NodesConnectingLinksIndex(i,2))= 1;
end
% Display
MassEnergyMatrix


%% Generate Mass Matrix
% For nodes like source or tanks shouldn't have mass equations.
MassMatrix = MassEnergyMatrix(:,NodeJunctionIndex)';
[m,~] = size(MassMatrix);
MassMatrixIndexCell = cell(m,2);
[RowPos,ColPos] = find(MassMatrix == 1);
[m,~] = size(RowPos);
for i = 1:m
    MassMatrixIndexCell(RowPos(i),1) = {[MassMatrixIndexCell{RowPos(i),1},ColPos(i)]};
end

[RowNeg,ColNeg] = find(MassMatrix == -1);
[m,~] = size(RowNeg);
for i = 1:m
    MassMatrixIndexCell(RowNeg(i),2) = {[MassMatrixIndexCell{RowNeg(i),2},ColNeg(i)]};
end



%% Generate Energy Matrix

% for pipe
EnergyPipeMatrix = -MassEnergyMatrix(PipeIndex,:);

[m,~] = size(EnergyPipeMatrix);
EnergyPipeMatrixIndex = zeros(m,2);
[RowPos,ColPos] = find(EnergyPipeMatrix == 1);
[m,~] = size(RowPos);
for i = 1:m
    EnergyPipeMatrixIndex(RowPos(i),1) = ColPos(i);
end

[RowNeg,ColNeg] = find(EnergyPipeMatrix == -1);
[m,~] = size(RowNeg);
for i = 1:m
    EnergyPipeMatrixIndex(RowNeg(i),2) = ColNeg(i);
end

% for Pump
EnergyPumpMatrix = -MassEnergyMatrix(PumpIndex,:);

[m,~] = size(EnergyPumpMatrix);
EnergyPumpMatrixIndex = zeros(m,2);
[RowPos,ColPos] = find(EnergyPumpMatrix == 1);
[m,~] = size(RowPos);
for i = 1:m
    EnergyPumpMatrixIndex(RowPos(i),1) = ColPos(i);
end

[RowNeg,ColNeg] = find(EnergyPumpMatrix == -1);
[m,~] = size(RowNeg);
for i = 1:m
    EnergyPumpMatrixIndex(RowNeg(i),2) = ColNeg(i);
end

% for valve
EnergyValveMatrix = -MassEnergyMatrix(ValveIndex,:);
[m,~] = size(EnergyValveMatrix);
EnergyValveMatrixIndex = zeros(m,2);
[RowPos,ColPos] = find(EnergyValveMatrix == 1);
[m,~] = size(RowPos);
for i = 1:m
    EnergyValveMatrixIndex(RowPos(i),1) = ColPos(i);
end

[RowNeg,ColNeg] = find(EnergyValveMatrix == -1);
[m,n] = size(RowNeg);
for i = 1:m
    EnergyValveMatrixIndex(RowNeg(i),2) = ColNeg(i);
end

MassEnergyMatrix4GP = struct('MassMatrixIndexCell',{MassMatrixIndexCell},...
    'EnergyPipeMatrixIndex',EnergyPipeMatrixIndex,'EnergyPumpMatrixIndex',EnergyPumpMatrixIndex,...
    'EnergyValveMatrixIndex',EnergyValveMatrixIndex);

