[m,n] = size(XXPROC);
ReferHEAD = Constants4WDN.ReferenceHead * ones(1,n);
HP=m/double(NumberofX);
figure;
i= 1;    
for i = 1:HP
    subplot(HP,1,i)
    plot(1:n,XXPROC(TankHeadIndexInVar+(i-1)*NumberofX,:),'b-','LineWidth',1);
    xlim([1,n+1]);
    hold on
    if(i == 1)
        ylim([836,839]);
        yticks(838);
    else
        plot(1:n,ReferHEAD,'r-.','LineWidth',1);
        yticks(Constants4WDN.ReferenceHead);
    end
    
    hold off

    ylabel("T"+string(i));
    
    if i<HP
        set(gca,'XTick',[]);
    else
            xlabel("Iteration");
            
    end
end
figure;
i= 1;    
for i = 1:HP-1
    subplot(HP,1,i)
    plot(1:n,XXPROC(18+(i-1)*NumberofX,:));
    xlim([1,n+1]);
    ylim([0.5,1.2]);
    ylabel("T"+string(i));
    if i<HP-1
        set(gca,'XTick',[]);
    else
            xlabel("Iteration");

    end

    
end


