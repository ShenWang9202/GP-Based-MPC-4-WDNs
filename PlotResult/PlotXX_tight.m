function PlotXX_tight(XXPROC,Hp,IndexInVar,ki)
NumberofX = IndexInVar.NumberofX;
[~,n] = size(XXPROC);
ref_vector = [Constants4WDN.ReferenceHead1 Constants4WDN.ReferenceHead2];
[~,k] = size(IndexInVar.TankHeadIndex);
Hp=Hp+1;
for j=1:k
    ref1 = ref_vector(j);
    ReferHEAD = ref1 * ones(1,n);
    h = figure;
    fontsize = 15;
    ha = tight_subplot(Hp,1,0.005);
    TankHead = IndexInVar.TankHeadIndex;
    Tankheadi = TankHead(j);
    for i = 1:Hp
        axes(ha(i));
        plot(1:n,XXPROC(Tankheadi+(i-1)*NumberofX,:),'b-','LineWidth',1);
        xlim([1,n+1]);
        hold on
        if(i == 1)
            %ylim([836,839]);
            %yticks(ReferHEAD);
            title('Iteration process of water level change at tank for $t =\{1,\cdots,Hp\}$','FontSize', fontsize,'interpreter','latex');
        else
            plot(1:n,ReferHEAD,'r-.','LineWidth',1);
            %yticks(ref1);
        end
        
        hold off
        
        ylabel('T'+string(i),'FontSize', fontsize);
        
        if i<Hp
            set(gca,'XTick',[]);
        else
            xlabel('Iteration','FontSize', fontsize);
            
        end
    end
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 12, 12], 'PaperUnits', 'Inches', 'PaperSize', [12, 12])
    saveas(h,sprintf('MPC_%d_WATER_LEVEL_Safety_COST_Hp_%d_Iter_%d_K_%d.png',Tankheadi,Constants4WDN.Hp,Constants4WDN.MaxIter,ki))
    close(h)
    
end

PumpSpeedInd = IndexInVar.PumpSpeedIndex;
[~,k] = size(PumpSpeedInd);
for j = 1:k
    h = figure;
    fontsize = 15;
    ha = tight_subplot(Hp,1,0.005);
    
    pumpspeed = PumpSpeedInd(j);
    for i = 1:Hp
        axes(ha(i));
        plot(1:n,XXPROC(pumpspeed+(i-1)*NumberofX,:),'b-','LineWidth',1);
        xlim([1,n+1]);
        ylim([0,1.2]);
        ylabel('T'+string(i-1));
        if(i == 1)
            ylim([0.8,1.2]);
            yticks(1);
            title('Iteration process of relative speed change of pump for $t =\{1,\cdots,Hp\}$','FontSize', fontsize,'interpreter','latex');
        end
        
        if i<Hp
            set(gca,'XTick',[]);
        else
            xlabel('Iteration');
            
        end
        
        
    end
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 12, 12], 'PaperUnits', 'Inches', 'PaperSize', [12, 12])
    saveas(h,sprintf('MPC_%d_SPEED_Safety_COST_Hp_%d_Iter_%d_K_%d.png',(pumpspeed),Constants4WDN.Hp,Constants4WDN.MaxIter,ki))
    close(h)
    
end


[~,n] = size(XXPROC);
PumpFlowInd = IndexInVar.PumpFlowIndex;
[~,k] = size(PumpFlowInd);
for j = 1:k
    h = figure;
    fontsize = 15;
    ha = tight_subplot(Hp,1,0.005);
    
    pumpflow = PumpFlowInd(j);
    for i = 1:Hp
        axes(ha(i));
        plot(1:n,XXPROC(pumpflow+(i-1)*NumberofX,:),'b-','LineWidth',1);
        xlim([1,n+1]);
        %ylim([0,1.2]);
        ylabel('T'+string(i-1));
        if(i == 1)
            %ylim([0.8,1.2]);
            %yticks(1);
            title('Iteration process of flow change of pump for $t =\{1,\cdots,Hp\}$','FontSize', fontsize,'interpreter','latex');
        end
        
        if i<Hp
            set(gca,'XTick',[]);
        else
            xlabel('Iteration');
            
        end
        
        
    end
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 12, 12], 'PaperUnits', 'Inches', 'PaperSize', [12, 12])
    saveas(h,sprintf('MPC_%d_FLOW_Safety_COST_Hp_%d_Iter_%d_K_%d.png',(pumpflow),Constants4WDN.Hp,Constants4WDN.MaxIter,ki))
    close(h)
    
end

end
%[-4.06936923370745;-90.9943928140586;-2.28921015930632;-2.25180208743291;-2.21336835166107;71.6916800977737;4.02371971962680;3.93785360918048]