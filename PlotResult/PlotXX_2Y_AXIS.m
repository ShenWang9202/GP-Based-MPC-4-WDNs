[m,n] = size(XXPROC);
ReferHEAD = Constants4WDN.ReferenceHead * ones(1,n);
HP=m/double(NumberofX);
figure;
fontsize = 15;
ha = tight_subplot(HP,1,0.005);
for i = 1:HP
    axes(ha(i));
    if i == 1
        title('Iteration process of water level change at tank for $t =\{1,\cdots,Hp\}$','FontSize', fontsize,'interpreter','latex');
        plot(1:n,XXPROC(TankHeadIndexInVar+(i-1)*NumberofX,:),'k-','LineWidth',1);
        ylabel("t0",'FontSize', fontsize);
    else
        yyaxis left
        plot(1:n,XXPROC(TankHeadIndexInVar+(i-1)*NumberofX,:),'b-','LineWidth',1);
        hold on
        plot(1:n,ReferHEAD,'b-.','LineWidth',1);
        yticks(Constants4WDN.ReferenceHead);
        ylabel("t"+string(i-1),'FontSize', fontsize);
        yyaxis right
        plot(1:n,XXPROC(18+(i-2)*NumberofX,:),'k-','LineWidth',1);
        xlim([1,n+1]);
        hold off
    end
    
    if i<HP
        set(gca,'XTick',[]);
    else
        xlabel("Iteration",'FontSize', fontsize);
    end
end

figure;
fontsize = 15;
ha = tight_subplot(HP-1,1,0.005);
for i = 1:HP-1
    axes(ha(i));
    plot(1:n,XXPROC(18+(i-1)*NumberofX,:),'b-','LineWidth',1);
    xlim([1,n+1]);
    ylim([0,1.2]);
    ylabel("T"+string(i-1));
    if(i == 1)
        ylim([0.8,1.2]);
        yticks(1);
        title('Iteration process of relative speed change of pump for $t =\{1,\cdots,Hp\}$','FontSize', fontsize,'interpreter','latex');
    end
    
    if i<HP-1
        set(gca,'XTick',[]);
    else
            xlabel("Iteration");

    end

    
end

PumpFlowIndex = IndexInVar.PumpFlowIndex;
[m,~] = size(PumpFlowIndex);
object = 0;
Delta_U = [];
for i = 2:(Hp)
    for j = 1:m % m pumps
        IndexCurrentK = PumpFlowIndex(j) + (i-1)*NumberofX;
        IndexCurrentK_1 = PumpFlowIndex(j) + (i-2)*NumberofX;
        XXSOLVE
        deltaq = XXSOLVE(IndexCurrentK) - XXSOLVE(IndexCurrentK_1);
        Delta_U = [Delta_U ; deltaq];
    end
end
%[-4.06936923370745;-90.9943928140586;-2.28921015930632;-2.25180208743291;-2.21336835166107;71.6916800977737;4.02371971962680;3.93785360918048]