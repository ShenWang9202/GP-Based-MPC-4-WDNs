SimulationTime = Constants4WDN.SimulationTime;
speedso = [];
tanklevel = [];
speedso = XXSOLVE(PumpSpeedIndexInVar,1:SimulationTime);
tanklevel = XXSOLVE(TankHeadIndexInVar,2:SimulationTime+1);
speedso = [speedso speedso(:,end)]; % repete for stair plot, otherwise cannot plot the final time slot
tanklevel = [tanklevel tanklevel(:,end) ] ;
PricePatternVal24hSave = [PricePatternVal24h;PricePatternVal24h(end)]
ReferenceHead = [Constants4WDN.ReferenceHead1 Constants4WDN.ReferenceHead2];
faceAlpha = 0.7; %bar transparency
paperposition = [0 0 18 14];
costcell = cell(1,2);
CtrlEnergy
costcell{1,1} = CtrlEnergy(2:SimulationTime+1,:);
titlecell{1,1} = '';
titlecell{1,2} = '';
duriation = 24;
fontsize = 32;
linewidth = 4;


% plot the first tank and pump pair
% prepare data
j = 1; % pump 172 and tank 130
tankind = IndexInVar.TankHeadIndex;
tanki = tankind(j);
speedind = IndexInVar.PumpSpeedIndex;
speedi = speedind(3-j);
tanklevel1  = tanklevel(j,:);
speedso2 = speedso(3-j,:) ;
refhead = ReferenceHead(j);
[~,n] = size(speedso2);
% start to plot
h = figure;



subplot(3,1,1);

yyaxis left
s1 = stairs(speedso2,'LineWidth',linewidth);
xlim([0.5,25.5])
ylim([-0.2,1.2])
set(gca, 'TickLabelInterpreter', 'latex');
ylabel('Relative Speed','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');

yyaxis right
s2 = stairs(tanklevel1,'LineWidth',linewidth,'LineStyle','-.');
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
ylabel('Water level (ft)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
ReferHEAD = refhead * ones(1,n);
ylim([refhead-10,866])
yticks([845,855,865]);
hold on
p1= plot(1:n,ReferHEAD,':','color',[0.8500    0.3250    0.0980],'LineWidth',linewidth);
lgd = legend([s1,s2,p1],{'Speed of Pump 172','Water level of Tank 130','Safety water level of Tank 130'},'Location','NorthOutside','Orientation','horizontal');

lgd.FontSize = fontsize-2;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')
%xlim([0,24])

xticks([2,4,6,8,10,12,14,16,18,20,22,24])

% plot the second tank and pump pair
% prepare data
j = 2; % pump 170 and tank 131
tankind = IndexInVar.TankHeadIndex;
tanki = tankind(j);
speedind = IndexInVar.PumpSpeedIndex;
speedi = speedind(3-j);
tanklevel2  = tanklevel(j,:);
speedso1 = speedso(3-j,:) ;
refhead = ReferenceHead(j);
[~,n] = size(speedso2);

% start to plot
subplot(3,1,2);

yyaxis left
s1 = stairs(speedso1,'LineWidth',linewidth);
set(gca, 'TickLabelInterpreter', 'latex');
xlim([0.5,25.5])
ylim([-0.2,1.2])

ylabel('Relative Speed','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
yyaxis right
s2= stairs(tanklevel2,'LineWidth',linewidth,'LineStyle','-.');
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
ylabel('Water level (ft)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
ReferHEAD = refhead * ones(1,n);
ylim([1143,1160])
hold on
p1 = plot(1:n,ReferHEAD,':','color',[0.8500    0.3250    0.0980],'LineWidth',linewidth);
yticks([1145,1150,1155]);
xticks([2,4,6,8,10,12,14,16,18,20,22,24])
lgd = legend([s1,s2,p1],{'Speed of Pump 170','Water level of Tank 131','Safety water level of Tank 131'},'Location','NorthOutside','Orientation','horizontal');
lgd.FontSize = fontsize-2;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')

%xlim([1,24])
% the above color can be get from https://stackoverflow.com/questions/26372462/what-is-the-default-matlab-color-order
% something about default color order.

% colours = permute(get(gca, 'colororder'), [1 3 2]);
% colours_resize = imresize(colours, 50.0, 'nearest');
% imshow(colours_resize);

subplot(3,1,3);

cost_fen = costcell{1,1};
[m,n]=size(cost_fen);
yyaxis left
% xlim([0.5,25.5])
Xva = (1:24)-0.2;
s1 = stairs(PricePatternVal24hSave* Constants4WDN.PriceBase,'LineWidth',linewidth);
xlim([0.5,25.5])
hold on
b1 = bar(Xva,cost_fen(:,1)*0.0125/3,0.3);%put another cost here %bar([cost_Hp_diverge1 cost_Hp_diverge2])
b1(1).FaceColor = [0.8500    0.3250    0.0980];%[ 0    0.4470    0.7410];
b1(1).FaceAlpha = faceAlpha;
b1(1).LineStyle = '-';
b1(1).EdgeColor = 'r';
b1(1).LineWidth = 2;
xlabel('Time (hours)','FontSize',fontsize,'interpreter','latex');
ylabel('Price(\$/Kwh)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
% xlim([-2,26])
% xlim([0.5,25.5])
ylim([0,2.5])

xticks([2,4,6,8,10,12,14,16,18,20,22,24])
%xlim([1-0.5,24])
yyaxis right
% xlim([-2,26])
Xva = (1:24)+0.2;
b2 = bar(Xva,cost_fen(:,2),0.3);%put another cost here %bar([cost_Hp_diverge1 cost_Hp_diverge2])
%b2(1).FaceColor = [0.8500    0.3250    0.0980];
b2(1).FaceAlpha = faceAlpha;
% b1(1).LineStyle = '--';
% b1(1).LineWidth = 2;
b2(1).FaceColor = [0.8500    0.3250    0.0980];%'r';%[0.9290    0.6940    0.1250];
b2(1).FaceAlpha = faceAlpha;
b2(1).LineStyle = '--';
b2(1).EdgeColor = 'r';
b2(1).LineWidth = 2;

xticks([2,4,6,8,10,12,14,16,18,20,22,24])
% xlim([0.5,25.5])
ylabel('Cost(\$)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
%lgd = legend([s1,b1],{'Electricity price Pattern',strcat('Cost of Pump 170',num2str(sum(sum(cost_fen)))),'Cost of Pump 172'},'Location','NorthOutside','Orientation','horizontal');
lgd = legend([s1,b1,b2],{'Electricity price','Cost of Pump 170','Cost of Pump 172'},'Location','NorthOutside','Orientation','horizontal');

lgd.FontSize = fontsize-2;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')
% subplot(3,1,3);
% bar()
set(gcf,'PaperUnits','inches','PaperPosition',paperposition)
print(h,[pwd '/result/PumpTank'],'-depsc2','-r300');

