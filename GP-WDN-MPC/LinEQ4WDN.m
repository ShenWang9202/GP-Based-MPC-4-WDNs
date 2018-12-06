% linear equation constraints
function [Aeq,beq] = LinEQ4WDN(d,NodeDemand,Num_XX0,XX)
    % input :
    %         Tao 8 * 1  = [z(k);x(k)] = [h1;h2;...;h8]
    %         mu 9 * 1   = [w(k);u(k)] = [ q1;q2;...;q9]
    %         XX = [Tao;mu]
    % output:
    %         A equality constraint: Aeq
    %         b equality constraint: beq
    % inequality constraint is null
    %XX = [ Head(1,7) Head(1,1:6) Head(1,8) Flows(1,1:9) Head(2,7) Head(2,1:6) Head(2,8) Flows(2,1:9)]';
  
    TankDiameter = d.getNodeTankDiameter(Constants4WDN.TankIndex);
    Tank8Sec = Constants4WDN.pi * (TankDiameter)^2 * 0.25 ; % TankDiameter feet
    %% Demand  known
    d.getNodeNameID;
    Hp = Constants4WDN.Hp;
    i = 1;
    %d_k_i = Demand_k_hp(k,i,NodeDemand);
    d_k_i = NodeDemand';% only node 2 - 7
    Mass_Balance_matrix = [0,0,0,0,0,0,0,0,-1;
                     -1,0,0,0,0,0,0,0,1;
                     1,-1,0,-1,0,0,0,0,0;
                     0,1,-1,0,-1,0,0,0,0;
                     0,0,1,0,0,0,1,0,0;%q3 - q7
                     0,0,0,0,1,1,-1,0,0;%q5 + q6 + q7
                     0,0,0,1,0,-1,0,-1,0;
                     0,0,0,0,0,0,0,1,0];
    %% matrix init
    row = Constants4WDN.COUNT_TANKS;
    A = eye(row);
    Delta_t = Constants4WDN.Delta_t;
    % B_U HAS TO BE CUSTOMIZED, NOT EASY TO GENERATE ACCORDING TO SCENARIOS
    B_u = Delta_t / 448.8325660485 / Tank8Sec * [1 0];
    B_w = zeros(row,Constants4WDN.SIZE_W_K);
    B_d = zeros(row,Constants4WDN.SIZE_D_K);
    %% model
    % model  x(k+i+1|k) = A * x(k+i|k) + Xi * mu(k+i|k) + B_d * d(k+i|k)
    % rewrite as: x(k+i+1|k) - A * x(k+i|k) - Xi * mu(k+i|k) - B_d * d(k+i|k)=0
    % rewrite as: [0 -I -B_w -B_u 0 I 0 0] * XX = 0
    %Aeq_Model = zeros(row,Num_XX0);
  
    Aeq_Model_Base = [zeros(row,Constants4WDN.SIZE_Z_K) -A -B_w -B_u zeros(row,Constants4WDN.SIZE_SPEED_K) zeros(row,Constants4WDN.SIZE_Z_K) eye(row) zeros(row,Constants4WDN.SIZE_W_K) zeros(row,Constants4WDN.SIZE_U_K) zeros(row,Constants4WDN.SIZE_SPEED_K)];
    beq_Model_Base = zeros(row,1);
    % Verify;
    %Aeq_Model_Base * XX(1:36,:) - beq_Model_Base
    
    %% Mass conservative
    % q_i - q_j = d_ij
    [m_dm,n_dm] = size(Mass_Balance_matrix(2:end-1,:));
    m_XX = Num_XX0; %should be 18
    Aeq_Mass_Base = [zeros(m_dm,Num_XX0) zeros(m_dm,Constants4WDN.SIZE_Z_K + Constants4WDN.SIZE_X_K) Mass_Balance_matrix(2:end-1,:) zeros(m_dm,Constants4WDN.SIZE_SPEED_K)];
    Aeq = [];
    beq = [];
    % Verify;
    %Aeq_Mass_Base * XX(1:36,:)
    for i = 1:Hp
        % generate the i-th Aeq_Model
        Aeq_Model_i_th = zeros(row,Num_XX0*(Hp+1));
        Aeq_Model_i_th(:,(Num_XX0*(i-1)+1:Num_XX0*(i+1))) = Aeq_Model_Base;
        % generate the i-th Aeq_Model
        Aeq_Mass_i_th = zeros(m_dm,Num_XX0*(Hp+1));
        Aeq_Mass_i_th(:,(Num_XX0*(i-1)+1:Num_XX0*(i+1))) = Aeq_Mass_Base;
        [m_Model,n_Model] = size(Aeq_Model_i_th);
        [m_Mass,n_Mass] = size(Aeq_Mass_i_th);
        
        beq_Mass_i_th = d_k_i(:,i);
        
        if m_Model < m_Mass
            extend_dimension = m_Mass - m_Model;
            Aeq_Model_i_th_extend = [Aeq_Model_i_th;zeros(extend_dimension,n_Model)];
            beq_Model_i_th_extend = [beq_Model_Base;zeros(extend_dimension,1)];
            Aeq_i_th = Aeq_Model_i_th_extend + Aeq_Mass_i_th;
            beq_i_th = beq_Model_i_th_extend + beq_Mass_i_th;
        else
            extend_dimension =  m_Model - m_Mass;
            Aeq_Mass_i_th_extend = [Aeq_Model_i_th;zeros(extend_dimension,n_Mass)];
            beq_Mass_i_th_extend = [beq_Mass_i_th;zeros(extend_dimension,1)];
            Aeq_i_th = Aeq_Model_i_th + Aeq_Mass_i_th_extend;
            beq_i_th = beq_Model_Base + beq_Mass_i_th_extend;
        end
        Aeq = [Aeq;Aeq_i_th];
        beq = [beq;beq_i_th];
    end
    
    % Verify
    %Aeq_Mass * XX - beq_Mass
    
    %Aeq_Model and Aeq_Mass must be the same size, we need to extend the small one by adding zeros.

    % verify Aeq * XX = beq
     %Aeq * XX - beq
end