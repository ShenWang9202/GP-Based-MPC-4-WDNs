function plotx(X)
    [m,n] = size(X);
    h = figure;
    for i = JunctionHeadIndexInVar(1:end)
        plot(1:n,X(i,:),'LineWidth',2);
        hold on
    end
    title(strcat(' X(head)',num2str(base,10)))
    xlabel('Iterartion','FontSize',12)
    ylabel('Head','FontSize',12)
    saveas(h,sprintf('X_HEAD.png'));
    close(h)
    
    h = figure;
    
    for i = PipeFlowIndexInVar(1:end)
        plot(1:n,X(i,:),'LineWidth',2);
        hold on
    end
    title(strcat(' X(flow)',num2str(base,10)))
    xlabel('Iterartion','FontSize',12)
    ylabel('Flow','FontSize',12)
    saveas(h,sprintf('X_Flow.png'));
    close(h)
end