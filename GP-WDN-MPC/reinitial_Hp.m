function i_th_pump = reinitial_Hp(Xdiverge,XCurrent,IndexInVar)

    s_start_index = min(IndexInVar.PumpSpeedIndex);
    s_end_index = max(IndexInVar.PumpSpeedIndex);
    s_diverge =Xdiverge(s_start_index:s_end_index);
    s_current =XCurrent(s_start_index:s_end_index);
    
    % which pumps control which tanks
    tankshead_start_index = min(IndexInVar.TankHeadIndex);
    tankshead_end_index = max(IndexInVar.TankHeadIndex);
    
    TankHead_diverge = Xdiverge(tankshead_start_index:tankshead_end_index);
    refhead = [Constants4WDN.ReferenceHead1;Constants4WDN.ReferenceHead2];
    % which pump
    i_th_pump = [];
    [m,~] = size(s_current);
    for i = 1:m
        if(s_current(i)<s_diverge(i) && TankHead_diverge(3-i) > refhead(3-i))% if speed down &&　water level is reached
            i_th_pump = [i_th_pump;i];
        end
    end
    
end