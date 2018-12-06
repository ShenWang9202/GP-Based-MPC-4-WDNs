function [Xreturn,PumpStatusHpSetup,numberofpump_turnoff_updated]= TurnOffPumps(numberofpump_turnoff,XCurrent,Xinit,CurrentK,Hp,PumpStatusHp,PricePatternVal24h,IndexInVar)

    NumberofX1 = IndexInVar.NumberofX;
    ElectricityPrice= [];
    for i = 1:Hp
        ElectricityPrice = [ElectricityPrice; PricePatternVal24h(mod(CurrentK-1+i-1,24)+1)];
    end

    PumpStatusHpSetup = PumpStatusHp;

    Xreturn = Xinit;
    %     Xdiverge = Xdiverge(NumberofX+1:end); % ingore the current step
    %     XCurrent = XCurrent(NumberofX+1:end); % ingore the current step


    ithpump = [];
    ithHp = 0;
    CandidateHp = [];
    ithPumpCell = cell(1,Hp);
    % Obtain candidate
    cellindex = 1;
    for i = 2:Hp+1
        SingleXIndexVector = ((i - 1) * NumberofX1 + 1):(i * NumberofX1);
        ithpump = CandidateHorizen(XCurrent(SingleXIndexVector,:),IndexInVar);
        if (isempty(ithpump))
            continue;
        else
            CandidateHp = [CandidateHp i];
            ithPumpCell{1,cellindex} = ithpump;
        end
        cellindex = cellindex + 1;
    end
    [~,n] = size(CandidateHp);
    CandidatePrice = zeros(1,n);
    for i = 1:n
        CandidatePrice(i) = PricePatternVal24h(mod(CurrentK-1+CandidateHp(i)-1,24)+1);
    end

    [Candiprice,cadindex] = sort(CandidatePrice,'descend');
    Candiprice
    cadindex
    n
    if(n > numberofpump_turnoff)
        n = numberofpump_turnoff;
        numberofpump_turnoff_updated = numberofpump_turnoff;
    else
        numberofpump_turnoff_updated = n;
    end
    n
    CandidateHpTemp = zeros(1,n);
    ithPumpCellTemp = cell(1,n);

    for i = 1:n
        CandidateHpTemp(i) = CandidateHp(cadindex(i));
        ithPumpCellTemp{1,i} = ithPumpCell{1,cadindex(i)};
    end
    disp('Candidate Hp to close');
    CandidateHp = CandidateHpTemp
    disp('Candidate Pump to close');
    ithPumpCell = ithPumpCellTemp

    for j = 1:n
        ithHp = CandidateHp(j);
        ithpump = ithPumpCell{1,j};
        [m,~] = size(ithpump);
        startindex = NumberofX1*(ithHp-1) + 1;
        s_start_index = min(IndexInVar.PumpSpeedIndex);
        q_pump_start_index = min(IndexInVar.PumpFlowIndex);
        for i = 1:m
            PumpStatusHpSetup(ithHp,ithpump(i)) = 0;
            Xreturn(startindex + s_start_index-1 + ithpump(i)-1) = 0;
%             Xreturn(startindex + q_pump_start_index-1+ithpump(i)-1) = 0;
        end
    end

    % initial all  tank as initial head

    for i = 1:Hp+1
        h_tank_start_index = min(IndexInVar.TankHeadIndex);
        [~,n] = size(IndexInVar.TankHeadIndex);
        for j = 1:n
            startindex = NumberofX1*(i-1) + 1;
%             Xreturn(startindex + h_tank_start_index-1 + j-1) = Xinit(startindex + h_tank_start_index-1 + j-1);
        end
    end
end
