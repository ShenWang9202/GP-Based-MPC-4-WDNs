%% Plot pump curve
set(0,'defaultTextInterpreter','latex'); %trying to set the default
PumpEquation = [445.00 -1.947E-05 2.28;
        740.00 -8.382E-05 1.94;
        ];
fontsize = 38;
linewidth = 5;
i=1;
h0 = PumpEquation(i,1);
r = PumpEquation(i,2);
w = PumpEquation(i,3);
q = 0:2:1600;
s = 1;
headincrease1 = s^2.*(h0 + r.*(q./s).^w);
h = figure;

%ylabel('Effiency (%)','FontName','sans-serif','FontSize',fontsize,'interpreter','latex');
h1=subplot(2,1,1);

yyaxis left
plot(q,headincrease1,'LineWidth',linewidth);
xlim([0,1600])
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
ylim([0,500])
ylabel('Head increase(ft)','FontName','sans-serif','FontSize',fontsize-7,'interpreter','latex');
yticks([250,500]);

yyaxis right
% plot effiency
A1 = 60;
B1 = 0.05;
C1 = -3.125E-5;

eff = A1 +B1.*q +C1.*q.^2;

plot(q,eff,'LineWidth',linewidth);
ylim([60,85])
set(gca,'fontsize',fontsize,'FontName', 'sans-serif')

ylabel('Effiency (%)','FontName','sans-serif','FontSize',fontsize-7,'interpreter','latex');

lgd = legend('$h^M$ of Pump 170','Effiency of Pump 170','Location','south');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');


% subplot 2;
i=2;
h0 = PumpEquation(i,1);
r = PumpEquation(i,2);
w = PumpEquation(i,3);
q = 0:2:4000;
s = 1;
headincrease1 = s^2.*(h0 + r.*(q./s).^w);
h2=subplot(2,1,2);
p2=get(h2,'position');
yyaxis left
plot(q,headincrease1,'LineWidth',linewidth);
xlim([0,4000])
ylim([0,800])
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
%ylim([0.71,1.02])
%xticks([2,4,6,8,10,12,14,16,18,20,22,24])
yticks([400,800]);
ylabel('Head increase(ft)','FontName','sans-serif','FontSize',fontsize-7,'interpreter','latex');

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

xlabel('Flow: $q$ (GPM)','FontName','sans-serif','FontSize',fontsize-4,'interpreter','latex');

ylabel('Effiency (%)','FontName','sans-serif','FontSize',fontsize-7,'interpreter','latex');
lgd = legend('$h^M$ of Pump 172','Effiency of Pump 172','Location','south');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 12])

print(h,'PumpHeadIncreaseEffiency','-depsc2','-r300');