%% Plot demand at each junction
h = figure;
duration = 24;
Demand24 = Demand72(1:duration,:);
[m,n] = size(Demand24);
fontsize = 38;
linewidth = 5;
for i = 4:6
%     plot(1:m,Demand(1:m,i)','DisplayName',strcat('Junction '+string(i)));
    stairs(1:m,Demand24(1:m,i)','LineWidth',linewidth);
    set(gca,'fontsize',fontsize,'FontName', 'sans-serif')
    hold on
end
set(gca, 'TickLabelInterpreter', 'latex');
xlabel('Time (hours)','FontSize',fontsize,'interpreter','latex');
xticks([2,4,6,8,10,12,14,16,18,20,22,24])
xlim([1-0.5,duration])
ylim([0,290]);
ylabel('Demand (GPM)','FontSize',fontsize,'interpreter','latex');
lgd = legend('Demand of Junction 5','Demand of Junctions 3,4,6','Demand of Junctions 2,7','Location','SouthEast');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
%title('$h^{\mathrm{M}} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex')
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
%lgd.FontWeight = 'bold';
%title('Demand of junctions','FontSize',fontsize+3)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 7])
%saveas(h,sprintf('Demand.eps'));
%print(h,'Demand', '-dpng', '-r300');
print(h,'Demand','-depsc2','-r300');

%% Plot Head of tank and speed of pump
h = figure;
tankindex = 8;
HeadTank24 = Head(1:duration,tankindex);
[m,n] = size(HeadTank24);
%     plot(1:m,Demand(1:m,i)','DisplayName',strcat('Junction '+string(i)));
Speed24 = [];
Speed24 = [1;Speed24];
Speed24 = [Speed24 ;Speed(1:duration-1,:)];
[m,n] = size(Speed24);
yyaxis left
stairs(1:m,Speed24','LineWidth',linewidth);
ylim([0.71,1.02])
xticks([2,4,6,8,10,12,14,16,18,20,22,24])
%yticks([])
ylabel('Relative speed of Pump 9','FontSize',fontsize);

yyaxis right
stairs(1:m,HeadTank24','LineWidth',linewidth);
hold on
ReferHEAD = Constants4WDN.ReferenceHead * ones(1,m);
plot(1:m,ReferHEAD,'r-.','LineWidth',linewidth);
set(gca,'fontsize',fontsize,'FontName', 'sans-serif')
xlabel('Time (hours)','FontSize',fontsize);
xlim([1-0.5,duration+0.5])
ylabel('Water Level of Tank 8 (ft)','FontSize',fontsize);
yticks([834,838,840])
lgd = legend('Relative speed','Water level after applying control actions','Safety water level','Location','NorthOutside');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'box','off')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
print(h,'WaterLever_PumpSpeed','-depsc2','-r300');

%% Plot the flow through pipes and pumps 
h = figure;
pipeundertankindex = 8;
pumpsindex = 9;
duration = 24;
Flows24 = Flows(1:duration,pipeundertankindex:pumpsindex);
[m,n] = size(Flows24);
stairs(1:m,Flows24(:,1)','LineWidth',linewidth);
xticks([2,4,6,8,10,12,14,16,18,20,22,24])
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
hold on
stairs(1:m,Flows24(:,2)','LineWidth',linewidth);
Referflow = zeros(1,m);
hold on
plot(1:m,Referflow,'r-.','LineWidth',linewidth);
xlabel('Time (hours)','FontSize',fontsize);
ylabel('Flow (GPM)','FontSize',fontsize);
xlim([1-0.2,duration+0.2])
lgd = legend('$q_{78}$: flow through the pipe connected with Tank 8','$q_{12}$: flow throgh Pump 9','Location','NorthEast');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex')
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 7])
print(h,'FlowPipePump','-depsc2','-r300');


%% Plot pump curve
set(0,'defaultTextInterpreter','latex'); %trying to set the default
PumpEquation = [393.7008 -3.746E-06 2.59;];
fontsize = 38;
linewidth = 5;
h0 = PumpEquation(1);
r = PumpEquation(2);
w = PumpEquation(3);
q = 0:1250;
s = 0.8;
headincrease1 = s^2.*(h0 + r.*(q./s).^w);
s = 1;
headincrease2 = s^2.*(h0 + r.*(q./s).^w);
h = figure
plot(q,headincrease1,'LineWidth',linewidth);
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
hold on
plot(q,headincrease2,'LineWidth',linewidth);
set(gca,'fontsize',fontsize,'FontName', 'sans-serif')
xlim([0,1300])
ylim([0,400])
xlabel('Flow: $q$ (GPM)','FontName','sans-serif','FontSize',fontsize,'interpreter','latex');
ylabel('Head increase: $h^{M}$ (ft)','FontName','sans-serif','FontSize',fontsize,'interpreter','latex');
lgd = legend('$s=0.8$','$s=1.0$','Location','NorthEast');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','FontName', 'sans-serif','interpreter','latex')
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
%Variable-Speed Pump Curve
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 7])
print(h,'PumpHeadIncrease','-depsc2','-r300');

%% Plot flips of flow direction in DTown example
load('FlowBinary.mat')
load('hour.mat')
load('LinkNameID.mat')
[~,n] = size(FlowBinary);
fontsize = 25;
linewidth = 5;
flip_max = 0;
index = 0;
Flips = [];
for i = 1:n
    result = logical(FlowBinary(:,i));
    [m,~] = size(result);
    times_flipped = 0;
    for j = 2:m
        times_flipped = times_flipped + abs(result(j) - result(j-1));
    end
    Flips = [Flips;times_flipped];
    if(times_flipped >flip_max)
        flip_max = times_flipped;
        index = i;
    end
end

DayI = 24:24:7*24;
HourIndex = zeros(1,7);
for i = 1:7
    HourIndex(i) = find(hour == DayI(i));
end
HourIndex = [0,HourIndex];


DayI = 24:24:7*24;
HourIndex = zeros(1,7);
for i = 1:7
    HourIndex(i) = find(hour == DayI(i));
end
HourIndex = [0,HourIndex];
for i = 2:2
    h = figure(i);
    
    result = logical(FlowBinary(1:400,index));
    result2 = logical(FlowBinary(1:400,139));
    stairs(hour(HourIndex(i-1)+1:HourIndex(i)),result(HourIndex(i-1)+1:HourIndex(i)),'b','LineWidth',1)
%     hold on
%     stairs(hour(HourIndex(i-1)+1:HourIndex(i)),result2(HourIndex(i-1)+1:HourIndex(i)),'b','LineWidth',1)
%     lgd = legend('P932','P280','Location','NorthEastOutside');
%     lgd.FontSize = fontsize-3;
    set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
    axis([(i-2)*24 (i-1)*24 -0.05 1.05])
    yticks([0 1]);
    %title('Changes of flow direction of the Pipe 932 in DTown','FontSize',fontsize+3)
    xlabel('Time (hours)','FontSize',fontsize+3,'FontName','sans-serif','interpreter','latex')
    ylabel('Flow direction','FontSize',fontsize+3,'FontName','sans-serif','interpreter','latex')
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 3])
    print(h,'Flips','-depsc2','-r300');
end




%% Plot convergence and Hp

[~,n] = size(XXPROC);

fontsize = 38;
Hp = 10;
iter = 1:25;
ReferHEAD = Constants4WDN.ReferenceHead * ones(1,25);
ha = tight_subplot(Hp,1,0.005);
for i = 1:Hp
    axes(ha(i));
    plot(iter,XXPROC(IndexInVar.TankHeadIndex+(i-1)*NumberofX,iter),'b-','LineWidth',1);
    MaxValue = max(XXPROC(IndexInVar.TankHeadIndex+(i-1)*NumberofX,iter));
    MinValue = min(XXPROC(IndexInVar.TankHeadIndex+(i-1)*NumberofX,iter));
    xlim([1,25]);
    hold on
    if(i == 1)
        ylim([833,835]);
        yticks(834);
        %title('Iteration process of water level change at tank for $t =\{1,\cdots,10\}$','FontSize', fontsize,'interpreter','latex');
    else
        plot(iter,ReferHEAD,'r-.','LineWidth',1);
        if(MaxValue > 838)
            ylim([MinValue,MaxValue+0.5])
        else
            ylim([MinValue,838+0.5])
        end
        yticks(Constants4WDN.ReferenceHead);
    end
    if i<Hp
        ylabel("T"+string(i),'FontSize', fontsize,'FontName', 'sans-serif');
        %set(gca,'fontsize',fontsize,'FontName', 'sans-serif','XTick',[]);
    else
        %set(gca,'fontsize',fontsize,'FontName', 'sans-serif');
        xlabel("Iteration",'FontSize', fontsize,'FontName', 'sans-serif');
        ylabel("T"+string(i),'FontSize', fontsize,'FontName', 'sans-serif');
    end
    
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 10])
print('MPC_HP','-depsc2','-r300');

%% Plot convergence
fontsize = 38;
linewidth = 5;
[m,n] = size(Error);
h = figure;
yyaxis left
stairs(log10(Error),'LineWidth',linewidth);
%ylim([0.7,1.1])
%set(gca, 'XTickLabel', {2,4,6,8,10,12,14,16,18,20,22,24}, 'TickLabelInterpreter', 'latex');
set(gca, 'TickLabelInterpreter', 'latex');
%xticks([2,4,6,8,10,12,14,16,18,20,22,24]);
% yticks([0.8,1])
xlim([1,n])
ylabel('Iteration','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');
ylabel('log10(error)','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');

yyaxis right
stairs(XXPROC(36,:),'LineWidth',linewidth);
hold on
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
% xlabel('Time (hours)','FontSize',fontsize+3);
% xlim([1-0.5,duration+0.5])
ylabel('Relative Speed $s$','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');
ylim([0.5,1.1])
yticks([0.5,0.7,0.9])
lgd = legend('log10(error)','Relative Speed $s$','Safety water level','Location','NorthEast');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')
%title('Relative speed of Pump 9 and controlled water level of Tank 8','FontSize',fontsize+3)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 4])
print('Convergence','-depsc2','-r300');

%% PLOT MPC TABLE
mpciter = zeros(2,10);
for i = 1:24
    for k = 1:10
        mpciter(k,1) = XXSOLVE(18 + (k-1)*NumberofX,i);
        mpciter(k,2) = XXSOLVE(8 + (k-1)*NumberofX,i);
    end
end

%% Plot relative spped and water level and flows into one figure
% Plot Head of tank and speed of pump
h = figure;
tankindex = 8;
HeadTank24 = Head(1:duration,tankindex);
[m,n] = size(HeadTank24);
%     plot(1:m,Demand(1:m,i)','DisplayName',strcat('Junction '+string(i)));
Speed24 = [];
Speed24 = [1;Speed24];
Speed24 = [Speed24 ;Speed(1:duration-1,:)];
[m,n] = size(Speed24);
subplot(2,1,1);
yyaxis left
stairs(1:m,Speed24','LineWidth',linewidth);
ylim([0.7,1.1])
%set(gca, 'XTickLabel', {2,4,6,8,10,12,14,16,18,20,22,24}, 'TickLabelInterpreter', 'latex');
set(gca, 'TickLabelInterpreter', 'latex');
xticks([2,4,6,8,10,12,14,16,18,20,22,24]);
% yticks([0.8,1])
ylabel('Relative speed','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');

yyaxis right
stairs(1:m,HeadTank24','LineWidth',linewidth);
hold on
ReferHEAD = Constants4WDN.ReferenceHead * ones(1,m);
plot(1:m,ReferHEAD,'r-.','LineWidth',linewidth);
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
% xlabel('Time (hours)','FontSize',fontsize+3);
% xlim([1-0.5,duration+0.5])
ylabel('Water Level (ft)','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');
%ylim([825,843])
yticks([834,838,842])
lgd = legend('Relative speed','Water level after applying control actions','Safety water level','Location','NorthOutside');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')
%title('Relative speed of Pump 9 and controlled water level of Tank 8','FontSize',fontsize+3)

subplot(2,1,2);

pipeundertankindex = 8;
pumpsindex = 9;
duration = 24;
Flows24 = Flows(1:duration,pipeundertankindex:pumpsindex);
[m,n] = size(Flows24);
stairs(1:m,Flows24(:,1)','b','LineWidth',linewidth);
%set(gca, 'XTickLabel', {'','2','','4','','6','8','10','12','14','16','18','20','22','24'}, 'TickLabelInterpreter', 'latex');
set(gca, 'TickLabelInterpreter', 'latex');
xticks([2,4,6,8,10,12,14,16,18,20,22,24])
hold on
stairs(1:m,Flows24(:,2)','m','LineWidth',linewidth);
Referflow = zeros(1,m);
% hold on
% plot(1:m,Referflow,'r-.','LineWidth',linewidth);
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')

xlabel('Time (hours)','FontSize',fontsize,'FontName','sans-serif','interpreter','latex');
ylabel('Flow (GPM)','FontSize',fontsize,'FontName','sans-serif','interpreter','latex');
%xlim([1-0.2,duration+0.2])
lgd = legend('$q_{78}$: flow through the pipe connected with Tank 8','$q_{12}$: flow throgh Pump 9','Location','North');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
%title('$h^{\mathrm{M}} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex')
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 16])

print(h,'WaterLever_PumpSpeed_Flow','-depsc2','-r300');

%% Plot the flow through pipes and pumps 




