function [XXPROC,CostPROC] = BinarySearch(tankref,k,XX0,NumberofX,d,Node_Demand,Hp,MassMatrixIndexCell,EnergyPipeMatrixIndex,EnergyPumpMatrixIndex,EnergyValveMatrixIndex,PumpStatus,ValveStatus,PricePatternVal24h,IndexInVar)
searchZone = [0 Hp];
pumpstatusInital = repmat(ones(size(PumpStatus)),Hp,1);

PumpStatusHp = [PumpStatus;pumpstatusInital]
%PumpStatusHp = repmat(PumpStatus,Hp+1,1);
%     PumpStatusHp = [     0     0;
%      0     0;
%      1     1;
%      1     1;
%      1     1;
%      0     0;
%      1     1];
searchSolution = cell(Hp,2);
pump_turnoff = zeros(1,Hp);
searchIndex = 0;
feasibleIndex = 0;
indexSave = 1;
[~,TankCount] = size(IndexInVar.TankHeadIndex);
allowedFailureSafety = TankCount*1;
SearchedBefore = 0;
unreached_before_save = 0;
NonEmptyCell = 0;
while(searchZone(1) < searchZone(2)-1)
    % close searchZone/2 pump
    searchIndex = searchIndex + 1;
    numberofpump_turnoff = round(sum(searchZone)/2)
    pump_turnoff(1,searchIndex) = numberofpump_turnoff;
    [iter,XXIter,CostIter,NosolutionFlag,numberofpump_turnoff_updated,unreached_before] = GP4WDN(tankref,k,XX0,NumberofX,d,Node_Demand,Hp,MassMatrixIndexCell,EnergyPipeMatrixIndex,EnergyPumpMatrixIndex,EnergyValveMatrixIndex,PumpStatusHp,ValveStatus,PricePatternVal24h,numberofpump_turnoff,allowedFailureSafety,SearchedBefore,unreached_before_save,IndexInVar);
    SearchedBefore = 1;
    unreached_before_save = unreached_before;
    if(~NosolutionFlag)
        feasibleIndex = feasibleIndex + 1;
        searchZone(1) = numberofpump_turnoff;
        %update solutions into cell;
        searchSolution{feasibleIndex,1} = XXIter;
        searchSolution{feasibleIndex,2} = CostIter;
        NonEmptyCell = 1;
        if(numberofpump_turnoff_updated < numberofpump_turnoff)
            break;
        end
    else
        searchZone(2) = numberofpump_turnoff;
    end
end
% pick up the smallest solution.
if(NonEmptyCell)
    CostIterTemp = searchSolution{1,2};
    MinCost = CostIterTemp(end);
    for i = 2:feasibleIndex
        CostIterTemp = searchSolution{i,2};
        if(~isempty(CostIterTemp) && MinCost > CostIterTemp(end))
            MinCost = CostIterTemp(end);
            indexSave = i;
        else
            disp('empty CostIterTemp');
        end
        
    end
    XXPROC = searchSolution{indexSave,1};
    CostPROC = searchSolution{indexSave,2};
    PlotXX_tight(XXPROC,Hp,IndexInVar,k)
else
    XXPROC = XX0;
    CostPROC = 0;
end

end

