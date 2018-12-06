% Optimal doping profile optimization with current gain constraint.
% (a figure is generated)
%
% This example is directly taken from the paper:
%
%   Optimal Doping Profiles via Geometric Programming,
%   IEEE Transactions on Electron Devices, December, 2005,
%   by S. Joshi, S. Boyd, and R. Dutton.
%   (see pages 12-16)
%
% Determines the optimal doping profile that minimizes base transit 
% time subject to a lower bound constraint on the current gain (beta).
% This problem can be posed as a GP:
%
%   minimize   tau_B
%       s.t.   Nmin <= v <= Nmax
%              y_(i+1) + v_i^const1 <= y_i
%              w_(i+1) + v_i^const2 <= w_i, etc...
%              beta => beta_min
%
% where variables are v_i, y_i, and w_i.
%
% Almir Mutapcic and Siddharth Joshi 10/05
clear all;

% set the quiet flag (no solver reporting)
global QUIET; QUIET = 1;

% problem size
M = 100;

% problem constants
g1 = 0.42;
g2 = 0.69;
Nmax = 5*10^18;
Nmin = 5*10^16;
Nref = 10^17;
Dn0 = 20.72;
ni0= 1.4*(10^10);
WB = 10^(-5);
C =  WB^2/((M^2)*(Nref^g1)*Dn0);

% minimum current gain values
beta_min_GE = [1 1.4 1.8 2.2 2.6 3.0 3.4 3.43]*(1e-11);

% exponent powers
pwi = g2 -1;
pwj = 1+g1-g2;

% optimization variables
gpvar v(M) y(M) w(M) 

% objective function is the base transmit time
tau_B = C*w(1);

% fixed problem constraints
constr = [ Nmin*ones(M,1) <= v;
v <= Nmax*ones(M,1); ];

for i=1:M-1
  if( mod(i,100) == 0 ), disp(i), end;
  constr(end+1) = y(i+1) + v(i)^pwj <= y(i);
  constr(end+1) = w(i+1) + y(i)*v(i)^pwi <= w(i);
end

% equalities
constr(end+1) = y(M) == v(M)^pwj;
constr(end+1) = w(M) == y(M)*v(M)^pwi;

% index of the current gain constraint that we update
last_constr_index = length(constr) + 1;

v_array = [];
for k = 1:length(beta_min_GE)
  % changing constraint
  disp(['Solving for beta_min_GE = ', num2str(beta_min_GE(k))])
  constr(last_constr_index) = (WB*beta_min_GE(k)/(M*Nref^(g1-g2)*Dn0))*y(1) <= 1;

  % solve the problem
  [opt_val sol status] = gpsolve(tau_B, constr);

  % recover optimal solution 
  % sol is a cell array with fields
  %   'v'    [Mx1 double]
  %   'w'    [Mx1 double]
  %   'y'    [Mx1 double]

  v_array = [v_array sol{1,2}];
end

% plot the basic optimal doping profile
nbw = 0:1/M:1-1/M;
for k = 1:length(beta_min_GE)
  semilogy(nbw,v_array(:,k),'LineWidth',2); hold on;
end
axis([0 1 1e16 1e19]);
xlabel('base');
ylabel('doping');
text(0,Nmin,'Nmin ', 'HorizontalAlignment','right');
text(0,Nmax,'Nmax ', 'HorizontalAlignment','right');
hold off;

% restore solver reporting
global QUIET; QUIET = 0;
