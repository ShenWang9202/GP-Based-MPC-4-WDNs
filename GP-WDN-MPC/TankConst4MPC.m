function constraints = TankConst4MPC(X,base,d)
    constraints = [];
    
    constraints = [constraints;];
    
    %% tank volume V(k+1) = V(k) + q *delta_t
    TankIndex = Constants4WDN.TankIndex;
    TankDiameter = d.getNodeTankDiameter(TankIndex);
    Tank8Sec = Constants4WDN.pi * (TankDiameter)^2 * 0.25 ; % TankDiameter feet

    Delta_t = Constants4WDN.Delta_t;
    EquTankHeadLossCoeff = Delta_t / 448.8325660485 / Tank8Sec;
    %H8 = base^(h8 + delta_t * (q_8 / 448.8325660485) / Tank8Sec);
    constraints_tank = (W(h_end_index) == base^(X0(8)) * X(TankIndex + 8)^EquTankHeadLossCoeff);

    constraints = [constraints;];
end