function constraints =  objective_mono_approxi(X_init,base,href,Aux_Var,verify)

    X = sym('X',[2 1]);%X(1) = p X(2)=z
    %href = 838.8;
    Href = base^(href);
    h8 = X_init(8);
    X0 = [base^(h8 - href);0.001]% near p = 0.97, z = 0.001
    f = [(X(1) - 1)^2 / X(2)];
    jac = jacobian(f,X);
    jac_value = subs(jac,X,X0);
    jac_value = double(jac_value);
    [m,n] = size(jac);
    f_cofficient = subs(f,X,X0);
    f_cofficient = double(f_cofficient)
    a_matirx = zeros(m,n);
    for i = 1:m
        for j = 1:n
            a_matirx(i,j) = X0(j) / f_cofficient(i) * jac_value(i,j);
        end
    end
    a_matirx
    [m,n] = size(a_matirx);
    obj_mono = [];
    for i = 1:m
        monomial_shen = 1.0;
        for j = 1:n
            monomial_shen = monomial_shen * ((Aux_Var(j)/X0(j))^a_matirx(i,j));
            %monomial_shen = monomial_shen * ((Aux_Var(j))^a_matirx(i,j))
        end
        obj_mono = [obj_mono;f_cofficient(i) * monomial_shen] ;
        %obj_mono = [obj_mono; monomial_shen];
    end
    
    if(verify == 0)
        constraints = obj_mono <= ones(m,1);
    else
        constraints = obj_mono;
    end

end