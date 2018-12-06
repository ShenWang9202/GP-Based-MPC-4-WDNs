pricePattern = [24
23
20
20
20.5
23
27
27.5
29
32
36
36.5
37
40
42
45
46
46
40
37.5
40
35
27.5
25];
priceBase = 0.005;
priceFinal = pricePattern*priceBase;
ymin = min(priceFinal)-0.005;
ymax = max(priceFinal)+0.005;
t=1:24;
h = figure;
plot(t,priceFinal,'LineWidth',3)
xlim([0 24])
ylim([ymin ymax])
title('Real-time pricing (24hrs)')
xlabel('Hour','FontSize',12)
ylabel('Electricity price ($/KWh)','FontSize',12)
saveas(h,sprintf('realtime.png'));
close(h)