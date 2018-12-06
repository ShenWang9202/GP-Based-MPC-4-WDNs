function constraints = MPCTankConst(X,d,NumberX0,Hp,base,verify,IndexInVar)

    constraints = [];
    
    TankHeadIndex = IndexInVar.TankHeadIndex;
    TankHead_PipeFlow_Index = IndexInVar.TankHead_PipeFlow_Index;

    TankDiameter = d.getNodeTankDiameter(TankHeadIndex);
    Tank8Sec = Constants4WDN.pi * (TankDiameter).^2 * 0.25 ; % TankDiameter feet

    Delta_t = d.getTimeHydraulicStep;
    EquTankHeadLossCoeff = double(Delta_t) / 448.8325660485 ./ Tank8Sec;
    %H8 = base^(h8 + delta_t * (q_8 / 448.8325660485) / Tank8Sec);
    
    %const = (X(TankHeadIndex) == base^X0(TankHeadIndex) * X0(TankFlowIndex)^EquTankHeadLossCoeff);
    %constraints = [constraints;const];
    [m,~] = size(TankHead_PipeFlow_Index);
    for i = 2:(Hp+1)
        for j = 1:m
            tankIndex = TankHead_PipeFlow_Index(j,1);
            PipeFlowUnderTankIndex = TankHead_PipeFlow_Index(j,3);
            const = (X(tankIndex + (i-1)*NumberX0) == X(tankIndex + (i-2)*NumberX0) * X(PipeFlowUnderTankIndex + (i-2)*NumberX0)^EquTankHeadLossCoeff(j));
            constraints = [constraints;const];
        end
    end
%     constraints
end