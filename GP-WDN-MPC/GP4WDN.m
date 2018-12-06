%function [Xsolution,iter,XX,Error] = GP4WDN(tankref,CurrentK,XX0,NumberX0,d,NodeDemand,Hp,MassMatrixCell,EnergyPipeMatrixIndex,EnergyPumpMatrixIndex,PumpStatus,CostCoeff,IndexInVar)
function [iter,XX,CostIter,NosolutionFlag,numberofpump_turnoff_updated,unreached_all_before] = GP4WDN(tankref,CurrentK,XX0,NumberX0,d,NodeDemand,Hp,MassMatrixCell,EnergyPipeMatrixIndex,EnergyPumpMatrixIndex,EnergyValveMatrixIndex,PumpStatusHp,ValveStatus,PricePatternVal24h,numberofpump_turnoff,allowedFailureSafety,SearchedBefore,unreached_before_save,IndexInVar)
    base = 1.005;
    Demand = base.^NodeDemand;
    %% Elevation
    TankIndex = d.getNodeTankIndex;
    TankMax = d.getNodeTankMaximumWaterLevel(TankIndex);
    TankMin = d.getNodeTankMinimumWaterLevel(TankIndex);
    TankElevation = d.getNodeElevations(TankIndex);
    TankMax = TankMax + TankElevation;
    TankMin = TankMin + TankElevation;
    unreached_all = 0;
    verify = 0;
    vn = NumberX0 * (Hp+1);
    gpvar W(vn)
    gpvar z
    [TankCount,~] = size(IndexInVar.TankHeadIndex);
    %AuxTankCount = Hp;
    %gpvar Aux_Var(AuxTankCount)% Smoothness of control action
    TankRef = tankref;
    XX = [];
    XX = [XX;XX0];
    Error = [];
    c_estimate_value = [];
    iter = 0;
    STEP = 1;
    unreached_all_before = 0;
    unreached_all_after = 0;
    K = [];
    cost_Hp = [];
    CostIter = [];
    stableIteration = Constants4WDN.stableIteration;
    StartCloseIteration = Constants4WDN.StartCloseIteration;
%     Xdiverge =[];
%     cost_Hp_diverge=[];
%     costdiverge=1000000000;
    MaxIter = Constants4WDN.MaxIter;
    MaxErr = Constants4WDN.MaxErr;
    ValveFlag = repmat(ValveStatus,Hp+1,1);
    valveflagchage = [];
    feasibleornot = cell(MaxIter,1);
    NosolutionFlag = 0;
    ClosePumpsFlag = 0;
    Closed = 0;
    numberofpump_turnoff_updated = numberofpump_turnoff;
    while(iter<=MaxIter)
        iter = iter + 1;
        if(ClosePumpsFlag || SearchedBefore)
            % find numberofpump_turnoff to turn off
            [Xreturn,PumpStatusHpSetup,numberofpump_turnoff_updated] = TurnOffPumps(numberofpump_turnoff,XX0,XX(:,1),CurrentK,Hp,PumpStatusHp,PricePatternVal24h,IndexInVar);
            disp('before applying turn off');
            PumpStatusHp
            disp('after applying turn off');
            PumpStatusHp = PumpStatusHpSetup
            XX0 = Xreturn;
            ValveFlag = repmat(ValveStatus,Hp+1,1);
            iter = 1;
            ClosePumpsFlag = 0;
            if(SearchedBefore)
                unreached_all_before = unreached_before_save;
            end
            SearchedBefore = 0;
            Closed = 1;
            if(numberofpump_turnoff_updated==0)
                break;
            end
        end
        valveflagchage = [valveflagchage;ValveFlag];
        %         if (iter >=5 && STEP >=3)
        %             STEP = 0;
        %             k = (XX(:,iter) - XX(:,iter - 2))/2  * 1 ;
        %             %XX0 = k * 2 + XX(:,iter);
        %             K = [K k];
        %         end
        %% Constraints for conversion of flow, pipe, pump and Tank
        constraints_flow = MPCFlowConst(W,MassMatrixCell,Demand,verify,Hp,NumberX0,XX0,base,IndexInVar);
        [constraints_PressurePipe,c_estimate_pipe] = MPCPressurePipeConst(W,EnergyPipeMatrixIndex,XX0,base,d,verify,NumberX0,Hp,IndexInVar);
        %X,EnergyValveMatrixIndex,X_init,base,d,verify,NumberX0,Hp,ValveFlag,XXSolution,iter,IndexInVa
        [constraints_PressureValve,c_estimate_valve,ValveFlag] = MPCPressureValveConst(W,EnergyValveMatrixIndex,XX0,base,d,verify,NumberX0,Hp,ValveFlag,XX,iter,IndexInVar);
        constraints_PressurePump = MPCPressurePumpConst(W,EnergyPumpMatrixIndex,XX0,base,verify,NumberX0,Hp,PumpStatusHp,IndexInVar);
        constraints_Tank = MPCTankConst(W,d,NumberX0,Hp,base,verify,IndexInVar);

        %% Additional Constraints
        constraints_bounds = MPCBoundsConst(W,XX0,NumberX0,Hp,base,verify,iter,TankMax,TankMin,PumpStatusHp,IndexInVar);

        %% objective
        obj = 0;
        obj = obj + z;
        constraints = [];
        constraints = [
                constraints_flow;
                constraints_PressurePipe;
                constraints_PressureValve;
                constraints_PressurePump;
                constraints_Tank;
                constraints_bounds;
                z <=1;
            ];

        if (iter >=stableIteration)
            % Safty Water
            [objfunc_SaftyWater,constraints_SaftyWater,unreached_all] = MPCObjSafeWater(W,XX0,NumberX0,Hp,base,TankRef,verify,IndexInVar);
            constraints = [constraints;
                constraints_SaftyWater;
                ];
            obj = obj  + objfunc_SaftyWater; % +  objfunc_Smoothness;
            if(Closed==0)
                unreached_all_before = unreached_all;
            else
                unreached_all_after = unreached_all;
            end
        end

        obj
        [obj_value, solution, status] = gpsolve(obj,constraints);
        status
        feasibleornot{iter,1} = status;
        obj_value
        % show final objective
        disp(['Final Objective: ' num2str(obj_value)])
        iter
        %         Aux_array = cell2mat(solution(1,2))
        if(strcmp(status, 'Infeasible'))
            NosolutionFlag = 1;
            break;
        else
            idx = find(strcmp(solution, 'W'));
            W_array = cell2mat(solution(idx,2));
            %         Aux_solution = full(Aux_array)
            W_array = full(W_array);
            Xsolution = zeros(vn,1);
            Xsolution = mylog(base,W_array);
            checkoutSolution(Xsolution,Hp,IndexInVar);
            XX0 = Xsolution;
        end
        cost_Hp  = CalculateCost(Xsolution,CurrentK,Hp,PumpStatusHp,PricePatternVal24h,EnergyPumpMatrixIndex,NumberX0,IndexInVar);
        cost = sum(sum(cost_Hp));
        CostIter = [CostIter;cost];

        if (iter >=StartCloseIteration && ~Closed)
            %iterdiverge = iter;
            %Xdiverge = Xsolution; % before we go and minize cost, we just save the solution for recovering later.
            %costdiverge = cost;
            %cost_Hp_diverge = cost_Hp;
            ClosePumpsFlag = 1;
        end
        
        XX = [XX XX0];
        c_estimate_value = [c_estimate_value;c_estimate_pipe;c_estimate_valve;];
        %C_estimate = [C_estimate c_estimate_value];
        Iteration_Error = norm(abs(XX(:,end)-XX(:,end-1)));
        Error = [Error Iteration_Error];
        STEP = STEP +1;
        
        if(Closed && iter >=stableIteration)
            unreached_all = unreached_all_after-unreached_all_before
            if(unreached_all > allowedFailureSafety)
                NosolutionFlag = 1;
                break;
            end
        end
    end
    if(NosolutionFlag)
        if(ClosePumpsFlag==0)
            disp('no solution before closing pumps, please modify the goal or turn less pumps off');

        else
            disp('after closing pumps, no solution');
        end
        return;
    end


end

