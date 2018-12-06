%% Plot demand at each junction
h = figure;
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
%xticks([2,4,6,8,10,12,14,16,18,20,22,24])
xlim([0.5,25.5])
%

%ylabel('Real demand pattern','FontSize',fontsize-7,'interpreter','latex');
%lgd = legend('Demand of Junction 5','Demand of Junctions 3,4,6','Demand of Junctions 2,7','Location','SouthEast');
%'Orientation','horizontal'
lgd = legend(s1,{'Estimated demand pattern','Real demand pattern'},'Location','NorthOutside');
lgd.FontSize = fontsize-8;
lgd.FontName = 'sans-serif';
%title('$h^{\mathrm{M}} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex')
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
lgd.FontWeight = 'bold';
%title('Demand of junctions','FontSize',fontsize+3)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 9])
%saveas(h,sprintf('Demand_journal.eps'));
%print(h,'Demand', '-dpng', '-r300');
print(h,[pwd '/result/Demand-journal'],'-depsc2','-r300');