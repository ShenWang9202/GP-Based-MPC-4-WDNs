[~,n]=size(XXPROC);
index0fresult = [iterdiverge n];
[~,sizeofindex] = size(index0fresult);
ReferenceHead = [Constants4WDN.ReferenceHead1 Constants4WDN.ReferenceHead2];
faceAlpha = 0.7; %bar transparency
paperposition = [0 0 18 14];
costcell = cell(1,2);
costcell{1,1} = cost_Hp_diverge;
costcell{1,2} = cost_Hp;
titlecell = cell(1,2);
titlecell{1,1} = '';
titlecell{1,2} = '';
duriation = 24;
fontsize = 28;
linewidth = 4;

for indresult=1:sizeofindex
    % plot the first tank and pump pair
    % prepare data
    j = 1; % pump 172 and tank 130
    tankind = IndexInVar.TankHeadIndex;
    tanki = tankind(j);
    speedind = IndexInVar.PumpSpeedIndex;
    speedi = speedind(3-j);
    tanklevel  = XXPROC(tanki:IndexInVar.NumberofX:end,index0fresult(indresult));
    speedso = XXPROC(speedi:IndexInVar.NumberofX:end,index0fresult(indresult));
    refhead = ReferenceHead(j);
    [m,~] = size(speedso);
    % start to plot
    h = figure;

    
    
    subplot(3,1,1);
    
    yyaxis left
    stairs(speedso,'LineWidth',linewidth);
    ylim([-0.2,1.2])
    set(gca, 'TickLabelInterpreter', 'latex');
    ylabel('Speed  of Pump 172','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
    
    yyaxis right
    stairs(tanklevel,'LineWidth',linewidth)
    set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
    ylabel('Water Level Tank 130 (ft)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
    ReferHEAD = refhead * ones(1,m);
    hold on
    plot(1:m,ReferHEAD,'-.','color',[0.8500    0.3250    0.0980],'LineWidth',linewidth);

    %xlim([0,24])

    xticks([2,4,6,8,10,12,14,16,18,20,22,24])
    
    % plot the second tank and pump pair
    % prepare data
    j = 2; % pump 170 and tank 131
    tanki = tankind(j);
    speedi = speedind(3-j);
    tanklevel  = XXPROC(tanki:IndexInVar.NumberofX:end,index0fresult(indresult));
    speedso = XXPROC(speedi:IndexInVar.NumberofX:end,index0fresult(indresult));
    refhead = ReferenceHead(j);
    [m,~] = size(speedso);
    
    % start to plot
    subplot(3,1,2);
    
    yyaxis left
    stairs(speedso,'LineWidth',linewidth)
    set(gca, 'TickLabelInterpreter', 'latex');
    ylim([-0.2,1.2])

    ylabel('Speed of Pump 170','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
    
    yyaxis right
    stairs(tanklevel,'LineWidth',linewidth)
    set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
    ylabel('Water Level of Tank 131(ft)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
    ReferHEAD = refhead * ones(1,m);
    hold on
    plot(1:m,ReferHEAD,'-.','color',[0.8500    0.3250    0.0980],'LineWidth',linewidth);
    xticks([2,4,6,8,10,12,14,16,18,20,22,24])
    %xlim([1,24])
    % the above color can be get from https://stackoverflow.com/questions/26372462/what-is-the-default-matlab-color-order
    % something about default color order.
    
    % colours = permute(get(gca, 'colororder'), [1 3 2]);
    % colours_resize = imresize(colours, 50.0, 'nearest');
    % imshow(colours_resize);


    
    
    
    subplot(3,1,3);
    cost_fen = costcell{1,indresult};
    [m,n]=size(cost_fen);
    yyaxis left
    k=1
    s1 = stairs(PricePatternVal24h(k:k+m-1,:)* Constants4WDN.PriceBase,'LineWidth',linewidth);
    xlabel('Time (hours)','FontSize',fontsize,'interpreter','latex');
    ylabel('Price(\$/Kwh)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
    ylim([0,2.5])
    
    xticks([2,4,6,8,10,12,14,16,18,20,22,24])
    %xlim([1-0.5,24])
    yyaxis right
    b1 = bar(cost_fen,'FaceAlpha',faceAlpha);%put another cost here %bar([cost_Hp_diverge1 cost_Hp_diverge2])
    b1(1).FaceColor = [0.9290    0.6940    0.1250];
    b1(1).LineStyle = '--';
    b1(1).LineWidth = 2;
    b1(2).FaceColor = [0.9290    0.6940    0.1250];
    b1(2).LineStyle = '-.';
    b1(2).LineWidth = 2;

    xticks([2,4,6,8,10,12,14,16,18,20,22,24])
    %xlim([1-0.5,24.5])
    ylabel('Cost(\$)','FontSize',fontsize-3,'FontName', 'sans-serif','interpreter','latex');
    set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
    %lgd = legend([s1,b1],{'Electricity Price Pattern',strcat('Cost of Pump 170',num2str(sum(sum(cost_fen)))),'Cost of Pump 172'},'Location','NorthOutside','Orientation','horizontal');
    lgd = legend(b1,{'Cost of Pump 170','Cost of Pump 172'},'Location','NorthOutside','Orientation','horizontal');
   
    lgd.FontSize = fontsize-3;
    lgd.FontName = 'sans-serif';
    set(lgd,'Interpreter','Latex');
    set(lgd,'box','off')
    % subplot(3,1,3);
    % bar()
    set(gcf,'PaperUnits','inches','PaperPosition',paperposition)
    print(h,sprintf('PumpTank-%d',indresult),'-depsc2','-r300');
end
