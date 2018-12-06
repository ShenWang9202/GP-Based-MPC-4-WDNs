function d_k_i = Demand_k_hp(i,Demand)
    %Hp = 2;
    % i = 0:Hp-1
    % current step
    %d_k_i = [Demand(k+i,7) Demand(k+i,1:6) Demand(k+i,8)]';
    d_k_i = [Demand(1:6) Demand(8)]'; % demand node 2 to node 7, when
end