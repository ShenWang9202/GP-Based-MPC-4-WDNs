PumpIndex = d.getLinkPumpIndex;
LinkPumpNameID = d.getLinkPumpNameID
NodesConnectingLinksID(PumpIndex,:)
NodesConnectingLinksIndex(PumpIndex,:)

%
% variable = 
% [ head of pipe;
%   head of reservior;
%   head of tank;
%   flow of pipe;
%   flow of pump;
%   flow of valve;
%   speed of pump;]

% count of each element
PipeCount = d.getLinkPipeCount;
PumpCount = d.getLinkPumpCount;
ValveCount = d.getLinkValveCount;

JunctionCount = d.getNodeJunctionCount;
ReservoirCount = d.getNodeReservoirCount;
TankCount = d.getNodeTankCount;


% index for each element.
PipeHeadIndexInHead = 1:JunctionCount;

BaseCount4Next = JunctionCount;
ReservoirHeadIndexInHead = (BaseCount4Next+1):(BaseCount4Next+ReservoirCount);

BaseCount4Next = BaseCount4Next+ReservoirCount;
TankHeadIndexInHead = (BaseCount4Next+1):(BaseCount4Next + TankCount);

% index in Flows

PipeFlowIndexInFlows = 1:PipeCount;

BaseCount4Next = PipeCount;
PumpFlowIndexInFlows = (BaseCount4Next+1):(BaseCount4Next + PumpCount);

BaseCount4Next = BaseCount4Next+PumpCount;
ValveFlowIndexInFlows = (BaseCount4Next+1):(BaseCount4Next + ValveCount);

PipeHead = Head(:,PipeHeadIndexInHead);
ReservoirHead = Head(:,ReservoirHeadIndexInHead);
TankHead = Head(:,TankHeadIndexInHead);

PipeFlow = Flows(:,PipeFlowIndexInFlows);
PumpFlow = Flows(:,PumpFlowIndexInFlows);
ValveFlow = Flows(:,ValveFlowIndexInFlows);


% Tank min and max Head

TankMinimumWaterLevel = d.getNodeTankMinimumWaterLevel(NodeTankIndex);
TankMaximumWaterLevel = d.getNodeTankMaximumWaterLevel(NodeTankIndex);

TankElevation = d.getNodeElevations(NodeTankIndex);
TankMinimumHead = TankMinimumWaterLevel + TankElevation;
TankMaximumHead = TankMaximumWaterLevel + TankElevation;

% Heads across valve
ValveIndex = d.getLinkValveIndex;
ValveIndexInHead = NodesConnectingLinksIndex(ValveIndex,:);
[m,n] = size(ValveIndexInHead);
ValveIndexInHead = reshape(ValveIndexInHead',[m*n,1]);
HeadAcrossValve =[];
for i = ValveIndexInHead
    HeadAcrossValve = [HeadAcrossValve Head(:,i)];
end

% Pressure across valve
PressureAcrossValve = [];
for i = ValveIndexInHead
    PressureAcrossValve = [PressureAcrossValve Pressure(:,i)];
end



