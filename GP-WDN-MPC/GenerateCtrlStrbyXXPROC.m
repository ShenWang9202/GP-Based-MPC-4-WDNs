PumpNameID = d.getLinkPumpNameID;
j =1;
tankind = IndexInVar.TankHeadIndex;
tanki = tankind(j);
speedind = IndexInVar.PumpSpeedIndex;
speedi = speedind(j);
tanklevel  = XXPROC(tanki:IndexInVar.NumberofX:end,end);
speedso = XXPROC(speedi:IndexInVar.NumberofX:end,end)

[m,n] = size(speedso);
control_stringLink = 'LINK ';
% control_string_pump1 = strcat(control_stringLink,pump1);
% control_string_pump2 = strcat(control_stringLink,pump2);
control_string3 = ' AT TIME';

controlGenSet = [];
for i = 1:m
    
    control_string2= strcat(32,num2str(speedso(i)),32);
    control_string_pumpi = strcat(control_stringLink,32,PumpNameID{1,j});
    timestring = num2str(i-1);
    Control = strcat(control_string_pumpi,control_string2,control_string3,32,timestring);
    controlGenSet = strvcat(controlGenSet,Control);
end

j =2;
tankind = IndexInVar.TankHeadIndex;
tanki = tankind(j);
speedind = IndexInVar.PumpSpeedIndex;
speedi = speedind(j);
tanklevel  = XXPROC(tanki:IndexInVar.NumberofX:end,end)
speedso = XXPROC(speedi:IndexInVar.NumberofX:end,end)

[m,n] = size(speedso);
control_stringLink = 'LINK ';
% control_string_pump1 = strcat(control_stringLink,pump1);
% control_string_pump2 = strcat(control_stringLink,pump2);
control_string3 = ' AT TIME';


for i = 1:m
    
    control_string2= strcat(32,num2str(speedso(i)),32);
    control_string_pumpi = strcat(control_stringLink,32,PumpNameID{1,j});
    timestring = num2str(i-1);
    Control = strcat(control_string_pumpi,control_string2,control_string3,32,timestring);
    controlGenSet = strvcat(controlGenSet,Control);
end


h = figure;
fontsize = 18;
linewidth = 2;
hold on 

subplot(2,1,1);

yyaxis left
stairs(speedso,'LineWidth',2)
set(gca, 'TickLabelInterpreter', 'latex');
ylim([-0.2,1.2])
ylabel('Relative speed','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');

yyaxis right
stairs(tanklevel,'LineWidth',2)
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
ylabel('Water Level (ft)','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');
ReferHEAD = Constants4WDN.ReferenceHead * ones(1,m);
hold on
plot(1:m,ReferHEAD,'r-.','LineWidth',linewidth);

subplot(2,1,2);
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
[m,n]=size(cost_Hp)
bar([PricePatternVal24h(k:k+m-1,:) cost_Hp])
ylabel('PricePattern && Cost($)','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
lgd = legend('PricePattern','Cost','Location','NorthEast');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')
% subplot(3,1,3);
% bar()





tanklevel  = XXPROC(IndexInVar.TankHeadIndex:IndexInVar.NumberofX:end,iterdiverge+1)
speedso = XXPROC(IndexInVar.PumpSpeedIndex:IndexInVar.NumberofX:end,iterdiverge+1)


[m,n] = size(speedso);

control_string1 = 'LINK 9';
control_string3 = ' AT TIME';
controlGenSet = [];
for i = 1:m
    control_string2= strcat(32,num2str(speedso(i)),32);
    timestring = num2str(i-1);
    ControlGen = strcat(control_string1,control_string2,control_string3,32,timestring);
    controlGenSet = strvcat(controlGenSet,ControlGen);
end


h = figure;
fontsize = 18;
linewidth = 2;


subplot(2,1,1);

yyaxis left
stairs(speedso,'LineWidth',2)
set(gca, 'TickLabelInterpreter', 'latex');
ylim([-0.2,1.2])
ylabel('Relative speed','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');

yyaxis right
stairs(tanklevel,'LineWidth',2)
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
ylabel('Water Level (ft)','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');
ReferHEAD = Constants4WDN.ReferenceHead * ones(1,m);
hold on
plot(1:m,ReferHEAD,'r-.','LineWidth',linewidth);

subplot(2,1,2);
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
[m,n]=size(cost_Hp_diverge);
stairs(PricePatternVal24h(k:k+m-1,:),'LineWidth',2);
hold on 
bar(cost_Hp_diverge);%put another cost here
ylabel('PricePattern && Cost($)','FontSize',fontsize,'FontName', 'sans-serif','interpreter','latex');
set(gca,'fontsize',fontsize,'FontName', 'sans-serif','TickLabelInterpreter', 'latex')
lgd = legend('PricePattern','Cost','Location','NorthEast');
lgd.FontSize = fontsize-3;
lgd.FontName = 'sans-serif';
set(lgd,'Interpreter','Latex');
set(lgd,'box','off')
% subplot(3,1,3);
% bar()



