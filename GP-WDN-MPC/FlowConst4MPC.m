function constraints = FlowConst4MPC(X,MassMatrixCell,Demand,verify,IndexInVar)
    % For nodes like source or tanks shouldn't have mass equations.
%     h_start_index = min(IndexInVar.JunctionHeadIndex);
%     h_end_index = max(IndexInVar.TankHeadIndex);
    q_start_index = min(IndexInVar.PipeFlowIndex);
    if(isempty(IndexInVar.ValveFlowIndex))
        q_end_index = max(IndexInVar.PumpFlowIndex);
    else
        q_end_index = max(IndexInVar.ValveFlowIndex);
    end
%     s_start_index = min(IndexInVar.PumpSpeedIndex);
%     s_end_index = max(IndexInVar.PumpSpeedIndex);
    
    Q = X(q_start_index:q_end_index);
    [m,~] = size(MassMatrixCell);
    f_mono = [];
    for i = 1:m
        monomial_temp = 1.0;
        PostiveMatrixIndex = cell2mat(MassMatrixCell(i,1));
        [~,n] = size(PostiveMatrixIndex);
        for j = 1:n
            monomial_temp = monomial_temp * (Q(PostiveMatrixIndex(j)))^(1);
        end
        NegativeMatrixIndex = cell2mat(MassMatrixCell(i,2));
        [~,n] = size(NegativeMatrixIndex);
        for j = 1:n
            monomial_temp = monomial_temp * (Q(NegativeMatrixIndex(j)))^(-1);
        end
        f_mono = [f_mono; Demand(i)^(-1)* monomial_temp] ;
    end
    [m,~] = size(f_mono);
    if(verify == 0)
        constraints = f_mono == ones(m,1);
    else
        constraints = f_mono;
    end
    
end