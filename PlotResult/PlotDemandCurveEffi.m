%% Plot demand at each junction
h = figure;
h1=subplot(2,2,[1,3]);
Demand24 = DemandPatternVal24h;
Demand24 = [Demand24;Demand24(end)];
RealDemand24 = DemandPatternVal24h.*((100+randomNumber)./100);
RealDemand24 = [RealDemand24;RealDemand24(end)];
[m,n]=size(Demand24);
fontsize = 42;
linewidth = 8;
Xvalue = 1:m;
Yvalue = [RealDemand24 Demand24];
s1 = stairs(Yvalue);
set(gca,'fontsize',fontsize-4,'FontName', 'sans-serif')
ylabel('Demand pattern','FontSize',fontsize-7,'interpreter','latex');
% ylim([0.33,2.3]);
% yyaxis right
% s2 = stairs(Xvalue,Yvalue(:,2),'LineWidth',linewidth-4);
s1(1).LineStyle = ':';
s1(1).LineWidth = linewidth;
s1(2).LineStyle = '-';
s1(2).LineWidth = linewidth-3;
%p  = patchline(Xvalue,Yvalue(:,1),'linestyle','--','edgecolor','g','linewidth',3,'edgealpha',0.2);
set(gca, 'TickLabelInterpreter', 'latex');
xlabel('Time (hours)','FontSize',fontsize,'interpreter','latex');
% xlim([0,24]);
ylim([0.33,2.3]);
xticks([4,8,12,16,20,24])
xlim([0.5,25.5])
%

%ylabel('Real Demand pattern','FontSize',fontsize-7,'interpreter','latex');
%lgd = legend('Demand of Junction 5','Demand of Junctions 3,4,6','Demand of Junctions 2,7','Location','SouthEast');
lgd = legend(s1,{'Estimated Demand pattern','Real Demand pattern'},'Location','NorthOutside');
lgd.FontSize = fontsize-8;
lgd.FontName = 'sans-serif';
%title('$h^{\mathrm{M}} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex')
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
lgd.FontWeight = 'bold';
%title('Demand of junctions','FontSize',fontsize+3)
%set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 8])
%saveas(h,sprintf('Demand_journal.eps'));
%print(h,'Demand', '-dpng', '-r300');
%print(h,'Demand-journal1','-depsc2','-r300');




%%

set(0,'defaultTextInterpreter','latex'); %trying to set the default
PumpEquation = [445.00 -1.947E-05 2.28;
    740.00 -8.382E-05 1.94;
    ];
fontsize = 30;
linewidth = 5;
i=1;
h0 = PumpEquation(i,1);
r = PumpEquation(i,2);
w = PumpEquation(i,3);
q = 0:2:1600;
s = 1;
headincrease1 = s^2.*(h0 + r.*(q./s).^w);

%ylabel('Effiency (%)','FontName','sans-serif','FontSize',fontsize,'interpreter','latex');
h2=subplot(2,2,2);

yyaxis left
plot(q,headincrease1,'-.','LineWidth',linewidth);
xlim([0,1600])
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
ylim([0,500])
ylabel('$h^M$ of Pump 170(ft)','FontName','sans-serif','FontSize',fontsize-7,'interpreter','latex');
%xticks([2,4,6,8,10,12,14,16,18,20,22,24])
%yticks([])


yyaxis right
% plot effiency
A1 = 60;
B1 = 0.05;
C1 = -3.125E-5;

eff = A1 +B1.*q +C1.*q.^2;

plot(q,eff,'LineWidth',linewidth);
ylim([60,85])
set(gca,'fontsize',fontsize,'FontName', 'sans-serif')

ylabel('Effiency of Pump 170(\%)','FontName','sans-serif','FontSize',fontsize-4,'interpreter','latex');


% subplot 2;
i=2;
h0 = PumpEquation(i,1);
r = PumpEquation(i,2);
w = PumpEquation(i,3);
q = 0:2:4000;
s = 1;
headincrease1 = s^2.*(h0 + r.*(q./s).^w);

h3=subplot(2,2,4);
p2=get(h3,'position');
yyaxis left
plot(q,headincrease1,'-.','LineWidth',linewidth);
xlim([0,4000])
ylim([0,800])
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')

ylabel('$h^M$ of Pump 172(ft)','FontName','sans-serif','FontSize',fontsize-4,'interpreter','latex');

yyaxis right
% plot effiency
%pump 172
A1 = 50;
B1 = 0.03;
C1 = -7.5E-6;

eff = A1 +B1.*q +C1.*q.^2;

plot(q,eff,'LineWidth',linewidth);
ylim([50,85])
set(gca,'fontsize',fontsize,'FontName', 'sans-serif')

xlabel('Flow: $q$ (GPM)','FontName','sans-serif','FontSize',fontsize,'interpreter','latex');
ylabel('Effiency of Pump 172(\%)','FontName','sans-serif','FontSize',fontsize-4,'interpreter','latex');
% lgd = legend('$Head\; increase$','$Effiency$','Location','NorthEast');
% lgd.FontSize = fontsize-3;
% %title('$Head increase and effiency curve$','FontName', 'sans-serif','interpreter','latex')
% set(lgd,'box','off')
% set(lgd,'Interpreter','Latex');
%Variable-Speed Pump Curve
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8.8])

print(h,[pwd '/result/demand_effi'],'-depsc2','-r300');






