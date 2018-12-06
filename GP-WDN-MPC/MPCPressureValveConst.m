function [constraints,c_estimate,ValveFlagOut] = MPCPressureValveConst(X,EnergyValveMatrixIndex,X_init,base,d,verify,NumberX0,Hp,ValveFlag,XXSolution,iter,IndexInVar)

    [m,n] = size(X);
    if (verify)
        X = sym('X',[m,n]);
    end
    constraints = [];
    c_estimate =[];
    
    ValveIndex = d.getLinkValveIndex;
    constraints_Valve_pressure = [];
    c_estimate_valve = [];
    ValveFlagOut = [];
    if ~isempty(ValveIndex)
        ValveTypesString = d.getLinkType(ValveIndex);
        ValveSetting = d.getLinkSettings(ValveIndex);
        NodeElevations = d.getNodeElevations;
        CurrentLinkStatus = d.getLinkStatus;
        ValveStatus = CurrentLinkStatus(:,ValveIndex);
        FlowUnits = d.getFlowUnits;
        for i = 1:(Hp+1)
            single = ((i - 1) * NumberX0 + 1):(i * NumberX0);
            [const,c_estimate_value,ValveFlagOutSingle] = PressureValveConst4MPC(X(single,:),EnergyValveMatrixIndex,X_init(single,:),base,NodeElevations,ValveSetting,ValveTypesString,verify,ValveStatus,ValveFlag(i,:),XXSolution(single,:),FlowUnits,iter,IndexInVar);
            ValveFlagOut = [ValveFlagOut;ValveFlagOutSingle];
            constraints = [constraints;const];
            c_estimate = [c_estimate;c_estimate_value];
        end
    end
    
end