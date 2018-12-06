function [Xreturn,nosolution,PumpStatusHpSetup,ithHp] = reinitial(XCurrent,Xdiverge,XX0,CurrentK,Hp,PumpStatusHp,PricePatternVal24h,InfeasibleCounter,IndexInVar)
    closepump = 3;
    nosolution = 0;
%     PumpSpeedIndex = IndexInVar.PumpSpeedIndex;
    NumberofX1 = IndexInVar.NumberofX;
%     PumpFlowIndex = IndexInVar.PumpFlowIndex;
%     ReservoirHeadIndex = IndexInVar.ReservoirHeadIndex;
     
%     WindowStart = mod(CurrentK-1+0,24)+1;
%     WindowEnd = mod(CurrentK-1+Hp-1,24)+1;
%     PricePatternVal24h(WindowStart:WindowEnd)
    ElectricityPrice= [];
    for i = 1:Hp
        ElectricityPrice = [ElectricityPrice; PricePatternVal24h(mod(CurrentK-1+i-1,24)+1)];
    end
 
    PumpStatusHpSetup = PumpStatusHp;
    
    Xreturn =[];
%     Xdiverge = Xdiverge(NumberofX+1:end); % ingore the current step
%     XCurrent = XCurrent(NumberofX+1:end); % ingore the current step
    
   
    ithpump = [];
    ithHp = 0;
    % choose the first one speed which is less than min speed.
    if(closepump == 1)
        
        % from 1 to i-1 th Hp, should use current solution
        Xreturn = XCurrent;
        
        for i = 1:Hp
            SingleXIndexVector = ((i - 1) * NumberofX1 + 1):(i * NumberofX1);
            ithpump = reinitial_Hp(Xdiverge(SingleXIndexVector,:),XCurrent(SingleXIndexVector,:),IndexInVar);
            if (isempty(ithpump))
                continue;
            else
                ithHp = i;
                break;
            end
        end
        
        
        startindex = NumberofX1*(ithHp) + 1;
        
        % from the i+1 th hp to the end, should use original solution
        Xreturn(startindex:end) = Xdiverge(startindex:end);
        
        % for the i th, we need to set the pump status as closed, and the pump
        % flow gonna be zeros.
        
        
        [m,~] = size(ithpump);
        % variable =
        % [ head of Junction;
        %   head of reservior;
        %   head of tank;
        %   flow of pipe;
        %   flow of pump;
        %   flow of valve;
        %   speed of pump;]
        startindex = NumberofX1*(ithHp-1) + 1;
        endindex = NumberofX1*(ithHp);
        s_start_index = min(IndexInVar.PumpSpeedIndex);
        s_end_index = max(IndexInVar.PumpSpeedIndex);
        q_pump_start_index = min(IndexInVar.PumpFlowIndex);
        q_pump_end_index = max(IndexInVar.PumpFlowIndex);
        
        for i = 1:m
            PumpStatusHpSetup(ithHp,i) = 0;
            Xreturn(startindex + s_start_index-1 + ithpump(i)-1) = 0;
            Xreturn(startindex + q_pump_start_index-1+ithpump(i)-1) = 0;
        end
        
    end
    % close the expensive one.
    if(closepump == 2)
        max_price = -1000;
        % from 1 to i-1 th Hp, should use current solution
        Xreturn = Xdiverge;
        for i = 1:Hp
            SingleXIndexVector = ((i - 1) * NumberofX1 + 1):(i * NumberofX1);
            ithpump = reinitial_Hp(Xdiverge(SingleXIndexVector,:),XCurrent(SingleXIndexVector,:),IndexInVar);
            if (isempty(ithpump))
                continue;
            else
                % all price pattern must be positive
                temp = PricePatternVal24h(mod(CurrentK-1+i-1,24)+1);
                if(temp > max_price)
                    max_price = temp;
                    ithHp = i;
                end
                
            end
        end
        
        
        [m,~] = size(ithpump);
        % variable =
        % [ head of Junction;
        %   head of reservior;
        %   head of tank;
        %   flow of pipe;
        %   flow of pump;
        %   flow of valve;
        %   speed of pump;]
        startindex = NumberofX1*(ithHp-1) + 1;
        endindex = NumberofX1*(ithHp);
        s_start_index = min(IndexInVar.PumpSpeedIndex);
        s_end_index = max(IndexInVar.PumpSpeedIndex);
        q_pump_start_index = min(IndexInVar.PumpFlowIndex);
        q_pump_end_index = max(IndexInVar.PumpFlowIndex);
        
        for i = 1:m
            PumpStatusHpSetup(ithHp,i) = 0;
            Xreturn(startindex + s_start_index-1 + ithpump(i)-1) = 0;
            Xreturn(startindex + q_pump_start_index-1+ithpump(i)-1) = 0;
        end
        
    end
    
    % close all of the selected pumps.
    if(closepump == 3)
        CandidateHp = [];
        ithPumpCell = cell(1,Hp);
        % from 1 to i-1 th Hp, should use current solution
        if isempty(Xdiverge)
            Xreturn = XCurrent;
            for i = 1:Hp
                SingleXIndexVector = ((i - 1) * NumberofX1 + 1):(i * NumberofX1);
                ithpump = reinitial_Hp1(XCurrent(SingleXIndexVector,:),IndexInVar);
                if (isempty(ithpump))
                    continue;
                else
                    CandidateHp = [CandidateHp i];
                    ithPumpCell{1,i} = ithpump;
                end
            end
        else
            Xreturn = Xdiverge;
            for i = 1:Hp
                SingleXIndexVector = ((i - 1) * NumberofX1 + 1):(i * NumberofX1);
                ithpump = reinitial_Hp(Xdiverge(SingleXIndexVector,:),XCurrent(SingleXIndexVector,:),IndexInVar);
                if (isempty(ithpump))
                    continue;
                else
                    CandidateHp = [CandidateHp i];
                    ithPumpCell{1,i} = ithpump;
                end
            end
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
        % choose the most expensive n Hp to close pump
        n = 2;%round(n/(2*InfeasibleCounter));
        n
        if(n ==0)
            disp('already use up');
            nosolution = 1;
            return;
        end
        CandidateHpTemp = zeros(1,n);
        ithPumpCellTemp = cell(1,n);
        
        for i = 1:n
            CandidateHpTemp(i) = CandidateHp(cadindex(i));
            ithPumpCellTemp{1,i} = ithPumpCell{1,cadindex(i)};
        end
        
        CandidateHp = CandidateHpTemp;
        ithPumpCell = ithPumpCellTemp;
        
        for j = 1:n
            ithHp = CandidateHp(j);
            ithpump = ithPumpCell{1,j};
            [m,~] = size(ithpump);
            % variable =
            % [ head of Junction;
            %   head of reservior;
            %   head of tank;
            %   flow of pipe;
            %   flow of pump;
            %   flow of valve;
            %   speed of pump;]
            startindex = NumberofX1*(ithHp-1) + 1;
            s_start_index = min(IndexInVar.PumpSpeedIndex);
            q_pump_start_index = min(IndexInVar.PumpFlowIndex);
            
            
            for i = 1:m
                PumpStatusHpSetup(ithHp,ithpump(i)) = 0;
                Xreturn(startindex + s_start_index-1 + ithpump(i)-1) = 0;
                Xreturn(startindex + q_pump_start_index-1+ithpump(i)-1) = 0;
            end
        end
        
    end
 
    % initial all  tank as initial head 
    
    for i = 1:Hp+1
        h_tank_start_index = min(IndexInVar.TankHeadIndex);
        [~,n] = size(IndexInVar.TankHeadIndex);
            for j = 1:n
                startindex = NumberofX1*(i-1) + 1;
                Xreturn(startindex + h_tank_start_index-1 + j-1) = XX0(startindex + h_tank_start_index-1 + j-1);
            end
    end
    
    

end