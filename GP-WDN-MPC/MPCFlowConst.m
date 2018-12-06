function constraints = MPCFlowConst(X,MassMatrixCell,Demand,verify,Hp,NumberX0,X_init,base,IndexInVar)
    [m,n] = size(X);
    if (verify)
        X = sym('X',[m,n]);
    end
    
    constraints = [];
    for i = 1:(Hp+1)
        const = FlowConst4MPC(X(((i - 1) * NumberX0 + 1):(i * NumberX0),:),MassMatrixCell,Demand(:,i),verify,IndexInVar);
        constraints = [constraints;const];
    end
%     [m,~] = size(constraints);
%     if (verify)
%         f_value = double(subs(constraints,X,base.^(X_init)))
%     else
%         for i = 1:m
%             constraints(i)
%         end
%     end
end