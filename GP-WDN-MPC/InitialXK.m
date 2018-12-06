function XX0 = InitialXK(NumberofX,Hp,ReservoirIndex,TankIndex,PumpIndex,CurrentLinkSettings,k,PipeFLowAverage,LastTimeSolution,CurrentHead,IndexInVar)
    XK = zeros(NumberofX,1);
    XX0 = zeros((Hp+1)*NumberofX,1);
    CurrentSpeed = CurrentLinkSettings(PumpIndex)
    InitialSpeed = ones(size(PumpIndex));
    

    XK(IndexInVar.PumpFlowIndex) = PipeFLowAverage(IndexInVar.PumpFlowIndex);
    XK(IndexInVar.PipeFlowIndex) = PipeFLowAverage(IndexInVar.PipeFlowIndex);
    XK(IndexInVar.ValveFlowIndex) = PipeFLowAverage(IndexInVar.ValveFlowIndex);
    XK(IndexInVar.ReservoirHeadIndex) = CurrentHead(ReservoirIndex);
    XK(IndexInVar.TankHeadIndex,:) = CurrentHead(TankIndex);
    XK(IndexInVar.PumpSpeedIndex) = InitialSpeed;
    XK(IndexInVar.ValveOpennessIndex) = 1;
    XX0 = repmat(XK,Hp+1,1);

    
    
%     if (k == 1)
%         %XK(IndexInVar.PumpSpeedIndex) = Solution(IndexInVar.PumpSpeedIndex,k);
%         %              XK(IndexInVar.PumpFlowIndex) = Solution(IndexInVar.PumpFlowIndex,k);
%         %XK(IndexInVar.PipeFlowIndex) = Solution(IndexInVar.PipeFlowIndex,k);
%         %XK(IndexInVar.ValveFlowIndex) = Solution(IndexInVar.ValveFlowIndex,k);
%         XK(IndexInVar.PumpFlowIndex) = PipeFLowAverage(IndexInVar.PumpFlowIndex);
%         XK(IndexInVar.PipeFlowIndex) = PipeFLowAverage(IndexInVar.PipeFlowIndex);
%         XK(IndexInVar.ValveFlowIndex) = PipeFLowAverage(IndexInVar.ValveFlowIndex);
%         XK(IndexInVar.ReservoirHeadIndex) = CurrentHead(ReservoirIndex);
%         XK(IndexInVar.TankHeadIndex,:) = CurrentHead(TankIndex);
%         XK(IndexInVar.PumpSpeedIndex) = CurrentSpeed;
%         XK(IndexInVar.ValveOpennessIndex) = 1;
%         XX0 = repmat(XK,Hp+1,1);
% %     else 
% %         XX0(1:Hp*NumberofX,1) = LastTimeSolution(1+NumberofX:end,1);% may lead to no solution?
% %         XX0(Hp*NumberofX+1:end,1) = LastTimeSolution(Hp*NumberofX+1:end,1);
%     end
    XX0(IndexInVar.TankHeadIndex,1) = CurrentHead(TankIndex);
    XX0(IndexInVar.ReservoirHeadIndex) = CurrentHead(ReservoirIndex);
    XX0(IndexInVar.PumpSpeedIndex) = CurrentSpeed;
    XX0(IndexInVar.ValveOpennessIndex) = 1;
end