function c_estimate = C_Estimate_Valve(X0,base,q_pipe_start_index,q_pipe_end_index)
    Headloss_valve_R = 4.127E-4; % only one valve now.
    q_valve = X0(q_pipe_start_index:q_pipe_end_index,1);
    c_estimate = [];
    [m,~] = size(q_valve);
    for i = 1:m
        c_estimate = [c_estimate;base^((Headloss_valve_R*abs(q_valve(i))^(0.852))*q_valve(i))];
    end
end
