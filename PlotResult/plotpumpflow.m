PumpFlowInd = IndexInVar.PumpFlowIndex;
PumpSpeedInd = IndexInVar.PumpSpeedIndex;
NumberofX = IndexInVar.NumberofX;
[~,k] = size(PumpFlowInd);
%XXPROC = XX;
[~,n] = size(XXPROC);
for j = 1:1
    pumpflow = PumpFlowInd(j);
    pumpspeed = PumpSpeedInd(j);
    flowdiverge1 = [];
    speeddiverge1 = [];
    flowclose = [];
    %speedclose = [];
    for i = 1:Hp
        flowdiverge1 = [flowdiverge1;XXPROC(pumpflow+(i-1)*NumberofX,:)];
        speeddiverge1 = [speeddiverge1;XXPROC(pumpspeed+(i-1)*NumberofX,:)];
        %flowclose = [flowclose;XXPROC(pumpflow+(i-1)*NumberofX,iterdiverge+1)];
        %speedclose = [speedclose;XXPROC(pumpspeed+(i-1)*NumberofX,:)];
    end
end

for j = 2:2
    pumpflow = PumpFlowInd(j);
    pumpspeed = PumpSpeedInd(j);
    flowdiverge2 = [];
    speeddiverge2 = [];
    flowclose = [];
    %speedclose = [];
    for i = 1:Hp
        flowdiverge2 = [flowdiverge2;XXPROC(pumpflow+(i-1)*NumberofX,:)];
        speeddiverge2 = [speeddiverge2;XXPROC(pumpspeed+(i-1)*NumberofX,:)];
        %flowclose = [flowclose;XXPROC(pumpflow+(i-1)*NumberofX,iterdiverge+1)];
        %speedclose = [speedclose;XXPROC(pumpspeed+(i-1)*NumberofX,:)];
    end
end