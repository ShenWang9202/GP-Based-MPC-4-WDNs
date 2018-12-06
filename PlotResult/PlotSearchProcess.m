SimulationTime = 6;
speedso = [    1.0000    1.0000    1.0000    1.0000    1.0000    0.7408 0.7408;
         0    1.0000    1.0000    1.0000         0         0 0];
tanklevel = 1000*[    0.8587    0.8581    0.8583    0.8584    0.8585  0.8581 0.8581;
    1.1475    1.1476    1.1481    1.1485    1.1490    1.1492 1.1492];

ReferenceHead = [Constants4WDN.ReferenceHead1 Constants4WDN.ReferenceHead2];
faceAlpha = 0.7; %bar transparency
paperposition = [0 0 20 5];

titlecell{1,1} = '';
titlecell{1,2} = '';
duriation = 24;
fontsize = 34;
linewidth = 6;


% plot the first tank and pump pair
% prepare data
j = 1; % pump 172 and tank 130
tanklevel1  = tanklevel(j,:);
speedso2 = speedso(3-j,:) ;
refhead = ReferenceHead(j);
[~,n] = size(speedso2);
% start to plot
h = figure;

subplot(1,2,1);

yyaxis left
s1 = stairs(speedso2,'LineWidth',linewidth);
xlim([1,7])
ylim([-0.2,1.2])
set(gca, 'TickLabelInterpreter', 'latex');
xlabel('Window index','FontSize',fontsize,'interpreter','latex');
ylabel('Relative speed','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');

yyaxis right
s2 = stairs(tanklevel1,'LineWidth',linewidth,'LineStyle','-.');
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
ylabel('Water level (ft)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
ReferHEAD = refhead * ones(1,n);
ylim([refhead-10,866])
hold on
p1= plot(1:n,ReferHEAD,':','color',[0.8500    0.3250    0.0980],'LineWidth',linewidth);
lgd = legend([s1,s2,p1],{'Speed  of Pump 172','Water level of Tank 130','Safety water level of Tank 130'},'Location','NorthOutside');

lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')
%xlim([0,24])

xticks([2,4,6])
yticks([845,855,865])

% plot the second tank and pump pair
% prepare data
j = 2; % pump 170 and tank 131

tanklevel2  = tanklevel(j,:);
speedso1 = speedso(3-j,:) ;
refhead = ReferenceHead(j);
[~,n] = size(speedso2);

% start to plot
subplot(1,2,2);

yyaxis left
s1 = stairs(speedso1,'LineWidth',linewidth);
set(gca, 'TickLabelInterpreter', 'latex');
xlim([1,6])
ylim([-0.2,1.2])

ylabel('Relative speed','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
yyaxis right
s2= stairs(tanklevel2,'LineWidth',linewidth,'LineStyle','-.');
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
xlabel('Window index','FontSize',fontsize,'interpreter','latex');
ylabel('Water level (ft)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
ReferHEAD = refhead * ones(1,n);
ylim([1143,1160])
hold on
p1 = plot(1:n,ReferHEAD,':','color',[0.8500    0.3250    0.0980],'LineWidth',linewidth);

xticks([2,4,6])
yticks([1145,1155])
lgd = legend([s1,s2,p1],{'Speed  of Pump 170','Water level of Tank 131','Safety water level of Tank 131'},'Location','NorthOutside');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')
set(gcf,'PaperUnits','inches','PaperPosition',paperposition)
print(h,[pwd '/result/SearchProcess3'],'-depsc2','-r300');

%%

SimulationTime = 6;
speedso = [   1.0000    1.0000    1.0000    1.0000    1.0000    0.7408 0.7408;
         0         0    1.0000         0         0         0 0];
tanklevel = 1000*[   0.8587    0.8581    0.8577    0.8578    0.8573    0.8569 0.8569;
    1.1475    1.1476    1.1478    1.1482    1.1484    1.1486 1.1486];

ReferenceHead = [Constants4WDN.ReferenceHead1 Constants4WDN.ReferenceHead2];
faceAlpha = 0.7; %bar transparency
paperposition = [0 0 20 5];


% plot the first tank and pump pair
% prepare data
j = 1; % pump 172 and tank 130
tanklevel1  = tanklevel(j,:);
speedso2 = speedso(3-j,:) ;
refhead = ReferenceHead(j);
[~,n] = size(speedso2);
% start to plot
h = figure;

subplot(1,2,1);

yyaxis left
s1 = stairs(speedso2,'LineWidth',linewidth);
xlim([1,7])
ylim([-0.2,1.2])
set(gca, 'TickLabelInterpreter', 'latex');
xlabel('Window index','FontSize',fontsize,'interpreter','latex');
ylabel('Relative speed','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');

yyaxis right
s2 = stairs(tanklevel1,'LineWidth',linewidth,'LineStyle','-.');
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
ylabel('Water level (ft)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
ReferHEAD = refhead * ones(1,n);
ylim([refhead-10,866])
hold on
p1= plot(1:n,ReferHEAD,':','color',[0.8500    0.3250    0.0980],'LineWidth',linewidth);
lgd = legend([s1,s2,p1],{'Speed  of Pump 172','Water level of Tank 130','Safety water level of Tank 130'},'Location','NorthOutside');

lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')
%xlim([0,24])

xticks([2,4,6])
yticks([845,855,865])

% plot the second tank and pump pair
% prepare data
j = 2; % pump 170 and tank 131

tanklevel2  = tanklevel(j,:);
speedso1 = speedso(3-j,:) ;
refhead = ReferenceHead(j);
[~,n] = size(speedso2);

% start to plot
subplot(1,2,2);

yyaxis left
s1 = stairs(speedso1,'LineWidth',linewidth);
set(gca, 'TickLabelInterpreter', 'latex');
xlim([1,7])
ylim([-0.2,1.2])

ylabel('Relative speed','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
yyaxis right
s2= stairs(tanklevel2,'LineWidth',linewidth,'LineStyle','-.');
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
xlabel('Window index','FontSize',fontsize,'interpreter','latex');
ylabel('Water level (ft)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
ReferHEAD = refhead * ones(1,n);
ylim([1143,1160])
hold on
p1 = plot(1:n,ReferHEAD,':','color',[0.8500    0.3250    0.0980],'LineWidth',linewidth);

xticks([2,4,6])
yticks([1145,1155])
lgd = legend([s1,s2,p1],{'Speed  of Pump 170','Water level of Tank 131','Safety water level of Tank 131'},'Location','NorthOutside');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')
set(gcf,'PaperUnits','inches','PaperPosition',paperposition)
print(h,[pwd '/result/SearchProcess5'],'-depsc2','-r300');


