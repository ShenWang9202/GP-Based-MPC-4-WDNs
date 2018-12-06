%https://keisan.casio.com/exec/system/14059932254941
% A = -280;
% B = 1.2;
% C = -0.001;

% A1 = 40;
% B1 = 0.13333333333333333333333;
% C1 = -1.11111111111111111E-4;

%pump 172
% A1 = 50;
% B1 = 0.15;
% C1 = -1.875E-4;

%pump 170
A1 = 60;
B1 = 0.05;
C1 = -3.125E-5;

Y = [];
X = [];
for x=0:100:1600
    y = A1 +B1*x +C1*x^2;
    X = [X x];
    Y = [Y y];
end

Z = [X;Y];
Z=Z';









A1 = Constants4WDN.A1;
B1 = Constants4WDN.B1;
C1 = Constants4WDN.C1;
%the second or the third pump effiency curve
A2 = Constants4WDN.A2;
B2 = Constants4WDN.B2;
C2 = Constants4WDN.C2;

A = [A1;A2;];
B = [B1;B2;];
C = [C1;C2;];
q_solution = [800;400];
% cacluate effiency for each pump
energyeff = (A +B.*q_solution +C.*q_solution.^2)/100;













