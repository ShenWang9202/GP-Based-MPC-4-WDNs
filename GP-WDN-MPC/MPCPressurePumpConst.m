function constraints = MPCPressurePumpConst(X,EnergyPumpMatrixIndex,X_init,base,verify,NumberX0,Hp,PumpStatusHp,IndexInVar)
    [m,n] = size(X);
    if (verify)
        X = sym('X',[m,n]);
    end
    
    constraints = [];
    for i = 1:(Hp+1)
        singleindex = ((i - 1) * NumberX0 + 1):(i * NumberX0);
        const = PressurePumpConst4MPC(X(singleindex,:),EnergyPumpMatrixIndex,X_init(singleindex,:),base,verify,PumpStatusHp(i,:),IndexInVar);
        constraints = [constraints;const];
    end
%     [m,n] = size(constraints);
% 
%     if (verify)
%         f_value = double(subs(constraints,X,base.^(X_init)))
%     else
%         for i = 1:m
%             constraints(i)
%         end
%     end
    
end