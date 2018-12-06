clc;
clear;
close all;
%% Hydraulic Analysis
% Create EPANET object using the INP file
zhi  = 4;
if(zhi == 1)
    inpname='tutorial4.inp';
end
if(zhi == 2)
%     inpname='tutorial4price13_copy.inp';
%     inpname1='tutorial4price13_copy.inp';
    inpname='tutorial4price16_copy.inp';
    inpname1='tutorial4price16_copy.inp';
end
if(zhi == 3)
    inpname='tutorial4price14_valve.inp';
    inpname1='tutorial4price14_valve.inp';
end
if(zhi == 4)
%     inpname='tutorial4price13_copy.inp';
%     inpname1='tutorial4price13_copy.inp';
    inpname='BWSN_Network_modify_2.inp';
    inpname1='BWSN_Network_modify_2.inp';
end
if(zhi == 5)
%     inpname='tutorial4price13_copy.inp';
%     inpname1='tutorial4price13_copy.inp';
    inpname='BWSN_Network_1_original.inp';
    inpname1='BWSN_Network_1_original.inp';
end
% Net1 Net2 Net3 BWSN_Network_1 example tutorial2
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

Settings=[];
Status=[];
TimeString={};
controlstringSet = [];
ctrlstringGet={};
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

% Pattern of price
%PatternIdx = find(strcmp(d.getPatternNameID, 'pr3'));
PatternIdx = find(strcmp(d.getPatternNameID, 'pr4'));
PatternVal = d.getPattern;
PatternVal= PatternVal(PatternIdx,:);
PatternLength = d.getPatternLengths(PatternIdx);
PricePatternVal24h = repmat(PatternVal',24/PatternLength,1);

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
    PricePattern = [PricePattern;PricePatternVal24h(mod((t/TimeStep),24)+1)];
    T=[T; t];
    LinkSettings = [LinkSettings;d.getLinkSettings];
    LinkStatus = [LinkStatus;d.getLinkStatus];
    tstep=d.nextHydraulicAnalysisStep;
end
d.closeHydraulicAnalysis
%% Get Demand
%PatternIdx = find(strcmp(d.getPatternNameID, '1'));
PatternIdx = find(strcmp(d.getPatternNameID, 'ModifiedPattern0'));
PatternVal = d.getPattern;
PatternVal= PatternVal(PatternIdx,:);
PatternLength = d.getPatternLengths(PatternIdx);
BaseDemand = d.getNodeBaseDemands{1};
BaseDemand = BaseDemand(NodeJunctionIndex);
Demand72 = [];
DemandPatternVal24h = [];
for i = 1:PatternLength
    pat = repmat(PatternVal(i),24/PatternLength,1);
    DemandPatternVal24h = [DemandPatternVal24h; pat];
end
Demand = [];
randomNumber = -10 + (10+10)*rand(24,1); % [-10;10] random number
for i = 1:24
    Demand = [Demand; DemandPatternVal24h(i) * BaseDemand * (100+randomNumber(i))/100];
end

SimulationTime = d.getTimeSimulationDuration/TimeStep;
Demand72 = repmat(Demand,SimulationTime/24,1);

%% Get cost

% global price base

CostperStep = Energy.*PricePattern * Constants4WDN.PriceBase;
CostperDay = sum(CostperStep(1:24));

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
% pump status(open or close) should be viewed as known, and shouldn't be
% placed in Solution, but it is possible that the status of Pumps can be
% variables, so we just viewed them as variables with fixed value now.
PumpSpeedNew = PumpSpeed .* PumpStatus;
%result =xor(PumpSpeedNew,PumpStatus)
if(zhi == 1 )
    PumpEquation = [200 -0.0001389 2;];
end
if(zhi == 2 )
    PumpEquation = [393.7008 -3.746E-06 2.59;];
    %PumpEquation = [200*0.3048 -0.01064 2;];
end

if(zhi == 3 )
    PumpEquation = [393.7008 -3.746E-06 2.59;];
    %PumpEquation = [200*0.3048 -0.01064 2;];
end
if(zhi == 4) %BWSN_Network_1
    PumpEquation = [445.00 -1.947E-05 2.28;
        740.00 -8.382E-05 1.94;
        ];
end

if(zhi == 5) %BWSN_Network_1
    PumpEquation = [445.00 -1.947E-05 2.28;
        740.00 -8.382E-05 1.94;
        ];
end

% Generate Solution for later validation.
Solution = [];
for i = 1:m
    Solution = [Solution; [Head(i,:) Flows(i,:) PumpSpeedNew(i,:)]];
end
Solution = Solution';
%% Generate Demand for NodeJuncion;
Demand_known = [];
saved_temp_index = [];
% Pattern of price
%Demand_NodeJunction = Demand(:,NodeJunctionIndex)';
% [m,~] = size(Demand_NodeJunction);
% Demand_known = [Demand_known;Demand_NodeJunction(1,:)];
% saved_temp_index = [saved_temp_index 1];
% distance_demand = 0;
% for i = 2:m
%     distance_demand = norm(Demand_NodeJunction(i,:) - Demand_known(end,:));
%     if(distance_demand >= 1)
%         Demand_known = [Demand_known;Demand_NodeJunction(i,:)];
%         saved_temp_index = [saved_temp_index i];
%     end
% end
% Demand_known = Demand_known';
% % find corresponding Solution
% Solution = Solution(:,saved_temp_index);
% ValveStatus = ValveStatus';
% ValveStatus = ValveStatus(:,saved_temp_index);
% PumpStatus = PumpStatus';
% PumpStatus = PumpStatus(:,saved_temp_index);

% Demand_known = Demand(:,NodeJunctionIndex)';

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

%% Find the index for variable.
% variable =
% [ head of Junction;
%   head of reservior;
%   head of tank;
%   flow of pipe;
%   flow of pump;
%   flow of valve;
%   speed of pump;
%   degree open of vavle;]

% count of each element
PipeCount = d.getLinkPipeCount;
PumpCount = d.getLinkPumpCount;
ValveCount = d.getLinkValveCount;

JunctionCount = d.getNodeJunctionCount;
ReservoirCount = d.getNodeReservoirCount;
TankCount = d.getNodeTankCount;

% total count.
NumberofX = PipeCount + PumpCount + ValveCount;
NumberofX = NumberofX + JunctionCount + ReservoirCount + TankCount;
NumberofX = NumberofX + PumpCount; % speed of pump
NumberofX = NumberofX + ValveCount; % degree of openning

% index for each element.
JunctionHeadIndexInVar = 1:JunctionCount;

BaseCount4Next = JunctionCount;
ReservoirHeadIndexInVar = (BaseCount4Next+1):(BaseCount4Next+ReservoirCount);

BaseCount4Next = BaseCount4Next+ReservoirCount;
TankHeadIndexInVar = (BaseCount4Next+1):(BaseCount4Next + TankCount);

BaseCount4Next = BaseCount4Next+TankCount;
PipeFlowIndexInVar = (BaseCount4Next+1):(BaseCount4Next + PipeCount);

BaseCount4Next = BaseCount4Next+PipeCount;
PumpFlowIndexInVar = (BaseCount4Next+1):(BaseCount4Next + PumpCount);

BaseCount4Next = BaseCount4Next+PumpCount;
ValveFlowIndexInVar = (BaseCount4Next+1):(BaseCount4Next + ValveCount);

BaseCount4Next = BaseCount4Next+ValveCount;
PumpSpeedIndexInVar = (BaseCount4Next+1):(BaseCount4Next + PumpCount);

BaseCount4Next = BaseCount4Next+PumpCount;
ValveOpennessIndexInVar = (BaseCount4Next+1):(BaseCount4Next + ValveCount);

%% Get PipeFlowIndexInVar by TankHeadIndexInVar

% [ head of Junction;
%   head of reservior;
%   head of tank;
%   flow of pipe;
%   flow of pump;
%   flow of valve;
%   speed of pump;]

[~,n] = size(TankHeadIndexInVar);
PipeFlowStartIndex = max(TankHeadIndexInVar) + 1;
% H8 is the tank head, Q9 is the flow connected with tank
% X6 - X8 = FUNC(X16)
% H7 - H8 = FUNC(Q9)
% 8 -1 16
TankHead_PipeFlow_Index = zeros(n,3);
tempRow = 1;
for tankHead = TankHeadIndexInVar
    [RowNeg,ColNeg] = find(EnergyPipeMatrixIndex == tankHead);
    TankHead_PipeFlow_Index(tempRow,1) = tankHead;
    if ColNeg == 1
        TankHead_PipeFlow_Index(tempRow,2) = 1;
    else
        TankHead_PipeFlow_Index(tempRow,2) = -1;
    end
    TankHead_PipeFlow_Index(tempRow,3) = RowNeg + PipeFlowStartIndex - 1;
    tempRow = tempRow + 1;
end

IndexInVar = struct('NumberofX',NumberofX,'JunctionHeadIndex',JunctionHeadIndexInVar,...
    'ReservoirHeadIndex',ReservoirHeadIndexInVar,...
    'TankHeadIndex',TankHeadIndexInVar,'PipeFlowIndex',PipeFlowIndexInVar,'PumpFlowIndex',PumpFlowIndexInVar,...
    'ValveFlowIndex',ValveFlowIndexInVar,'PumpSpeedIndex',PumpSpeedIndexInVar,'ValveOpennessIndex',ValveOpennessIndexInVar,...
    'PumpEquation',PumpEquation,'TankHead_PipeFlow_Index',TankHead_PipeFlow_Index);



%% Variable_Symbol_Table


Variable_Symbol_Table = cell(NumberofX,2);
temp_i = 1;
NodeIndexInVar = d.getNodeIndex;
LinkIndexInVar = d.getLinkIndex  + d.getNodeCount;
LinkPumpNameID = d.getLinkPumpNameID;
LinkValveNameID = d.getLinkValveNameID;
for i = NodeIndexInVar
    Variable_Symbol_Table{i,1} =  NodeNameID{temp_i};
    temp_i = temp_i + 1;
end

temp_i = 1;
for i = LinkIndexInVar
    Variable_Symbol_Table{i,1} =  LinkNameID{temp_i};
    temp_i = temp_i + 1;
end

temp_i = 1;
for i = PumpSpeedIndexInVar
    Variable_Symbol_Table{i,1} = strcat('Speed_',LinkPumpNameID{temp_i});
    temp_i = temp_i + 1;
end

temp_i = 1;
for i = ValveOpennessIndexInVar
    Variable_Symbol_Table{i,1} = strcat('Degree_',LinkValveNameID{temp_i});
    temp_i = temp_i + 1;
end

for i = 1:NumberofX
    Variable_Symbol_Table{i,2} =  strcat('W_',int2str(i));
end

%% Initialize empty matrice for final results.
Error_All = cell(n,1);
Relative_Error_All = [];
Final_Error_All = [];
XSolution = [];
%% Elevation


PipeFLowAverage = mean(Solution,2);
ReservoirHead = Head(:,ReservoirHeadIndexInVar);
TankHead = Head(:,TankHeadIndexInVar);
%%

[m,n] = size(Demand_known);
% m2feet = 3.28084;
% LPS2GMP = 15.850372483753;
% Demand_known = Demand_known * LPS2GMP;
m2feet = 1;
LPS2GMP = 1;
%%
d=epanet(inpname1);
d.openHydraulicAnalysis;
d.initializeHydraulicAnalysis;
TimeStep = d.getTimeHydraulicStep;
tstep=1;
Velocity=[];
Pressure=[];
T=[]; 
Demand=[];
Head=[];
Flows=[];
TankVolume=[]; 
HeadLoss = [];
XX0SAVE = [];
Speed = [];
Openness = [];
XXSOLVE = [];
Settings=[];
Status=[];
TimeString={};
controlstringSet = [];
ctrlstringGet={};
% CtrlEfficiency=[];
CtrlEnergy=[];
CtrlPricePattern= [];
Error = [];
iterationC =  [];
Hp = Constants4WDN.Hp;
IterationTime = 0;
x_solve = [];
cost_Hp = [];
valveflagchage=[];
feasibleornot =[];
%PumpNameID = d.getLinkPumpNameID;
% pump1 = PumpNameID{1,1};
% pump2 = PumpNameID{1,2};
control_stringLink = 'LINK ';
% control_string_pump1 = strcat(control_stringLink,pump1);
% control_string_pump2 = strcat(control_stringLink,pump2);
control_string3 = ' AT TIME';
tankrefarray = [Constants4WDN.ReferenceHead1 Constants4WDN.ReferenceHead2;]; % row: number of tanks; colum: reference and max head of i-th tank
tankref = repmat(tankrefarray,Hp,1);
% for mt = 1:Hp
%     ind = (mt - 1)* TankCount+1:mt*TankCount;
%     tankref(ind,1) = tankrefarray;
% end
CostPROC = [];
XXPROC = [];
tic
Speed = [Speed;1;1]; %
iterdiverge = 0;

SimulationTime = Constants4WDN.SimulationTime;


while (tstep>0 && IterationTime <= SimulationTime)
    disp('******************************IterationTime******************************')
    IterationTime
    tstep
    t=d.runHydraulicAnalysis;   %current simulation clock time in seconds.
    k = t/TimeStep + 1; % since the index in Matlab start from 1, we need to add 1
    Head_K = d.getNodeHydaulicHead;
    Flows_K = d.getLinkFlows;
    
%     CtrlEfficiency=[CtrlEfficiency;d.getLinkEfficiency(PumpIndex)];
    CtrlEnergy=[CtrlEnergy;d.getLinkEnergy(PumpIndex)];
    CtrlPricePattern = [CtrlPricePattern;PricePatternVal24h(mod((t/TimeStep),24)+1)];
    Status = [Status;d.getLinkStatus];
    CurrentLinkSettings = d.getLinkSettings;
    Settings = [Settings;CurrentLinkSettings];
    timestring = num2str((t+TimeStep));
    TimeString = [TimeString; timestring];
    ctrls = d.getControls;
    ctrlstringGet = [ctrlstringGet;ctrls.Control];
    % if it is first time to initialize, use average flow, otherwise use
    % last time solution

    XX0 = InitialXK(NumberofX,Hp,ReservoirIndex,TankIndex,PumpIndex,CurrentLinkSettings,k,PipeFLowAverage,x_solve,Head_K,IndexInVar);
    XX0SAVE = [XX0SAVE XX0];
    %Velocity=[Velocity; d.getLinkVelocity];
    %Pressure=[Pressure; d.getNodePressure];
    Demand=[Demand; d.getNodeActualDemand];
    %TankVolume=[TankVolume; d.getNodeTankVolume];
    %HeadLoss=[HeadLoss; d.getLinkHeadloss];
    Head=[Head; Head_K];
    Flows=[Flows; Flows_K];
    T=[T; t];
    % find demand for the next Hp steps.
    Node_Demand = getNodeDemand(k,Demand72',Hp); % demand for next step;
    CurrentLinkStatus = d.getLinkStatus;
    PumpStatus = CurrentLinkStatus(:,PumpIndex)
    %[x_solve,iter,XXPROC,Error] = GP4WDN(tankref,k,XX0,NumberofX,d,Node_Demand,Hp,MassMatrixIndexCell,EnergyPipeMatrixIndex,EnergyPumpMatrixIndex,PumpStatus,CostCoeff,IndexInVar);
	[XXPROC,CostPROC] = BinarySearch(tankref,k,XX0,NumberofX,d,Node_Demand,Hp,MassMatrixIndexCell,EnergyPipeMatrixIndex,EnergyPumpMatrixIndex,EnergyValveMatrixIndex,PumpStatus,ValveStatus,PricePatternVal24h,IndexInVar);
    %PlotXX_tight(XXPROC,Hp,NumberofX,IterationTime,IndexInVar);
    x_solve = XXPROC(:,end);
    speed_pump = x_solve(NumberofX+PumpSpeedIndexInVar);
    openness_valve = x_solve(NumberofX+ValveOpennessIndexInVar);
    Speed = [Speed;speed_pump];
    Openness = [Openness;openness_valve];
    [~,pumpcount] = size(PumpSpeedIndexInVar);
    for ind_pump = 1:pumpcount
        control_string2= strcat(32,num2str(speed_pump(ind_pump)),32);
        control_string_pumpi = strcat(control_stringLink,32,num2str(PumpIndex(ind_pump)));
        Control = strcat(control_string_pumpi,control_string2,control_string3,32,timestring);
        controlstringSet = strvcat(controlstringSet,Control);
        d.setControls(ind_pump,Control);
    end
    % set pump speed
    XXSOLVE = [XXSOLVE x_solve];
    %iterationC = [iterationC iter];

    IterationTime = IterationTime + 1;
    tstep=d.nextHydraulicAnalysisStep;
end
d.closeHydraulicAnalysis
CtrlCostperStep = CtrlEnergy.*CtrlPricePattern*Constants4WDN.PriceBase;
%CtrlCostperDay = sum(CtrlCostperStep(1:24));

toc
