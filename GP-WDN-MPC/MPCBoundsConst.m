function constraints = MPCBoundsConst(X,XX0,NumberX0,Hp,base,verify,iter,TankMax,TankMin,PumpStatusHp,IndexInVar)
    [m,n] = size(X);
    if (verify)
        X = sym('X',[m,n]);
    end
    
    constraints = [];
    for i = 1:(Hp + 1)
        ind = ((i - 1) * NumberX0 + 1):(i * NumberX0);
        const = BoundsConst4MPC(i,X(ind,:),base,XX0(ind,:),iter,TankMax,TankMin,PumpStatusHp(i,:),IndexInVar);
        constraints = [constraints;const];
    end
%     
%     [m,~] = size(constraints);
% 
%     for i = 1:m
%         constraints(i)
%     end

end