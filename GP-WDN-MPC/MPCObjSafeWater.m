function [object,constraints,unreached_all] =  MPCObjSafeWater(X,XX0,NumberofX,Hp,base,TankRef,verify,IndexInVar)

    [TankCount,~] = size(IndexInVar.TankHeadIndex);

    [m,n] = size(X);
    if (verify)
        X = sym('X',[m,n]);
    end
    % TankRef is a Hp times 1 vector, it stands for, the safety water head
    % for each k = 2:Hp+1; totally, we have Hp+1, as for the first one, it
    % is the current status, so you cannot change it, it make none sense to
    % add it to object function.
    XX0 = XX0(NumberofX+1:end); % ingore the current step
    XNew = X(NumberofX+1:end);
    unreached_all = 0;
    constraints = [];
    object = 0.0;
    for i = 1:Hp
        SingleXIndexVector = ((i - 1) * NumberofX + 1):(i * NumberofX);
        %SingleTankIndexVector = ((i-1)*TankCount+1):(i*TankCount);
        [const,obj,unreached_all] = SafeWaterObj4MPC(XNew(SingleXIndexVector,:),XX0(SingleXIndexVector,:),base,verify,TankRef(i,:),unreached_all,IndexInVar);
        constraints = [constraints;const];
        object = object + obj;
    end
    [m,n] = size(constraints);

    if (verify)
        f_value = double(subs(constraints,X,base.^(X_init)))
    else
        for i = 1:m
            constraints(i);
        end
    end

end