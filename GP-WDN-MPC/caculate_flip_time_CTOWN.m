clc;
clear
% Create EPANET object using the INP file
inpname='ctown.inp'; 
% Net1 Net2 Net3 BWSN_Network_1 example tutorial2
d=epanet(inpname);
d.plot();
 
d.getNodeNameID % the Name of each node   head of each node
d.getLinkNameID % the Name of each pipe   flow of each pipe
d.getNodesConnectingLinksID %


d.openHydraulicAnalysis;
d.initializeHydraulicAnalysis;
tstep=1; Velocity=[];Pressure=[];T=[]; Demand=[]; Head=[];Flows=[];TankVolume=[]; HeadLoss = [];
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

% PipeName = {'P15','P844','P866','P398'};
% [m,n] = size(PipeName);
% PipeIndex = zeros(n,1);
% for i = 1:n
%     PipeIndex(i) = find(strcmp(LinkNameID,string(PipeName(i))));
% end
% hour = T/3600;
% figure
% color = ['r','b','g','k'];
% for i = 1:n
%     plot(hour,Flows(:,PipeIndex(i)),color(i));
%     hold on
% end
% hold off
hour = T/3600;
[m,n] = size(Flows);
FlowBinary = zeros(m,n);
for i = 1:m
    for j = 1:n
        if (Flows(i,j) >=0 || abs(Flows(i,j))<= 0.1)
            FlowBinary(i,j) = 1;
        end
        
    end
end
[m,n] = size(FlowBinary);
result = logical(FlowBinary(:,1));
for i = 2:n
    result = xor(result,logical(FlowBinary(:,i)));
end

DayI = 24:24:7*24;
HourIndex = zeros(1,7);
for i = 1:7
    HourIndex(i) = find(hour == DayI(i));
end
HourIndex = [0,HourIndex];
for i = 2:8
    h = figure(i);
    stairs(hour(HourIndex(i-1)+1:HourIndex(i)),result(HourIndex(i-1)+1:HourIndex(i)),'LineWidth',1)
    axis([(i-2)*24 (i-1)*24 -0.1 1.1])
    title(strcat('Day',string(i-1)),'FontSize',15)
    xlabel('Hours','FontSize',15)
    ylabel('Status Flipped','FontSize',15)
    saveas(h,sprintf('Day%d.png',(i-1)))
    close(h)
end

[m,n] = size(result);
times_flipped = 0;
for i = 2:m
    times_flipped = times_flipped + abs(result(i) - result(i-1));
end



