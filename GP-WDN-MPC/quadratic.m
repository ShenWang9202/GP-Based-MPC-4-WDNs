%https://keisan.casio.com/exec/system/14059932254941
% A = -280;
% B = 1.2;
% C = -0.001;
A = 40;
B = 0.13333333333333333333333;
C = -1.11111111111111111E-4;

Y = [];
X = [];
for x=0:100:1200
    y = A +B*x +C*x^2;
    X = [X x];
    Y = [Y y];
end

Z = [X;Y];
Z=Z';