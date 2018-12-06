function [constraints,c_estimate] = MPCPressurePipeConst(X,EnergyPipeMatrixIndex,X_init,base,d,verify,NumberX0,Hp,IndexInVar)

    [m,n] = size(X);
    if (verify)
        X = sym('X',[m,n]);
    end
    constraints = [];
    c_estimate =[];
    for i = 1:(Hp+1)
        [const,c_estimate_value] = PressurePipeConst4MPC(X(((i - 1) * NumberX0 + 1):(i * NumberX0),:),EnergyPipeMatrixIndex,X_init(((i - 1) * NumberX0 + 1):(i * NumberX0),:),base,d,verify,IndexInVar);
        constraints = [constraints;const];
        c_estimate = [c_estimate;c_estimate_value];
    end
% 
%     [m,n] = size(constraints);
%     if (verify)
%         f_value = double(subs(constraints,X,base.^(X_init)))
%     else
%         for i = 1:m
%             constraints(i)
%         end
%     end
end