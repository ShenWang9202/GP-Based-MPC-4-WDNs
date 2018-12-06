function [constraints,obj_temp,unreached] = SafeWaterObj4MPC(X,XX0,base,verify,TankRef,unreached,IndexInVar)
    TankHeadIndex = IndexInVar.TankHeadIndex;
    h_start_index = min(TankHeadIndex);
    h_end_index = max(TankHeadIndex);
    H = X(h_start_index:h_end_index);
    h0 = XX0(h_start_index:h_end_index);
    f_mono = [];
    constraints = [];
    [~,m] = size(TankHeadIndex);
    obj_temp = 1.0;
    

    for i = 1:m
        if(h0(i,1) < TankRef(1,i)+ 0.5)
            %obj
            %delta_h =  TankRef(i) - h0(i);
            obj_temp = obj_temp * H(i,1)^(-1) * base^(TankRef(1,i)+0.5);
            if(h0(i,1) < TankRef(1,i))
                unreached = unreached + 1;
            end
        else
             cons = (H(i,1)^(-1) * base^(TankRef(1,i))<=1);
             constraints = [constraints;cons];
            %constraint
            %             monomial_temp = 1.0;
            %             monomial_temp = monomial_temp * H(i) * base^(-TankRef(i))* Aux_Var(i)^(1);
            %             f_mono = [f_mono;monomial_temp];
        end
    end
        

    
    
%     [m,~] = size(f_mono);
%     if(verify == 0)
%         constraints = [constraints;f_mono == ones(m,1);];
%     else
%         constraints = [constraints;f_mono];
%     end
end