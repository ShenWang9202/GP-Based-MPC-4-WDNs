function constraints = BoundsConst4MPC(k,X,base,X0,iter,TankMax,TankMin,PumpStatus,IndexInVar)
    constraints = [];
    % SOURCE HEAD
    SOURCE_HEAD =  base.^(X0(IndexInVar.ReservoirHeadIndex));
    % Tank min and max Head
    TANK_HEAD = base.^(X0(IndexInVar.TankHeadIndex));
    TANK_MAX = base.^(TankMax);
    TANK_MIN = base.^(TankMin);
    CurrentSpeed = base.^(X0(IndexInVar.PumpSpeedIndex));
    CurrentOpenness = base.^(X0(IndexInVar.ValveOpennessIndex));
    SpeedMax = Constants4WDN.SpeedMax;
    SpeedMin = Constants4WDN.SpeedMin;
    s_start_index = min(IndexInVar.PumpSpeedIndex);
    s_end_index = max(IndexInVar.PumpSpeedIndex);
    s = X0(s_start_index:s_end_index);
	OpenMax = Constants4WDN.OpenMax;
    OpenMin = Constants4WDN.OpenMin;
% 
%     
%     for j = IndexInVar.JunctionHeadIndex
%         %elev = base^(Elevation(j));
%         elev = base^(0);
%         constraints = [constraints;
%             X(j)^(-1) * elev <= 1;
%             ];
%     end
    
    % fix the head of source
    ind = 1;
    for j = IndexInVar.ReservoirHeadIndex
        constraints = [constraints;
            X(j) == SOURCE_HEAD(ind);];
        ind = ind + 1;
    end
    
    % fix the head of tank of the first. for the
    
    ind = 1;
    for j = IndexInVar.TankHeadIndex
        if(k==1)
            constraints = [constraints;
                X(j) == TANK_HEAD(ind);];
        else
            if(iter >=3)
                constraints = [constraints;
                    X(j) <= TANK_MAX(ind);
                    X(j)^(-1) <= TANK_MIN(ind);
                    ];
            end
        end
        ind = ind +1;
    end


    % Flow through Pumps are non-negatvie
    ind = 1;
    for j = IndexInVar.PumpFlowIndex
        if(PumpStatus(ind))
            constraints = [constraints;
                X(j)^(-1) <= 1;];
        else
            constraints = [constraints;
                X(j) == 1;];
        end
        ind = ind + 1;
    end
    % Pump speed should be [0,1]  
    ind = 1;
    for j = IndexInVar.PumpSpeedIndex
        if(k==1)
            constraints = [constraints;
                X(j) == CurrentSpeed(ind);
                ];
        else
            if(PumpStatus(ind))
                constraints = [constraints;
                    X(j) <= base^(SpeedMax);
                    X(j)^(-1) * base^(SpeedMin) <=1;
                    ];
            else
                constraints = [constraints;
                    X(j) == 1;
                    ];
            end
        end
        ind = ind +1;
    end
    
    % degree of open of valve should be [0,1]  
    ind = 1;
    for j = IndexInVar.ValveOpennessIndex
        if(k==1)
            constraints = [constraints;
                X(j) == CurrentOpenness(ind);
                ];
        else
            constraints = [constraints;
                X(j) <= base^(OpenMax);
                X(j)^(-1) * base^(OpenMin) <=1;
                ];
        end
        ind = ind +1;
    end
end