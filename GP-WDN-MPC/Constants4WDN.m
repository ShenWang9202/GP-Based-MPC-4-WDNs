classdef Constants4WDN
    properties( Constant = true )
        Hp = 6;
        SpeedMax = 1;
        SpeedMin = 0.3;
        OpenMax = 1;
        OpenMin = 0;
        MaxHead1 = 859.89999;
        %ReferenceHead1 = 858.89999;
        ReferenceHead1 = 854;
        MaxHead2 = 1170.45;
        %ReferenceHead2 = 1152.45;
        ReferenceHead2 = 1150.45;
        %Delta_t = 3600;%seconds 0.5hour
        MaxIter = 7;
        stableIteration = 3;
        MaxErr = 0.5;
        StartCloseIteration = 5;
        SimulationTime = 24;
        PriceBase = 0.05; % get this from epanet software
        %PriceBase = 0.5; % get this from epanet software
        
        % Energy effiency parameter;
        %pump 170
        A1 = 60;
        B1 = 0.05;
        C1 = -3.125E-5;
        %pump 172
        %pump 172
        A2 = 50;
        B2 = 0.03;
        C2 = -7.5E-6;

        
        pi = 3.141592654;
        GPMperCFS= 448.831;
        AFDperCFS= 1.9837;
        MGDperCFS= 0.64632;
        IMGDperCFS=0.5382;
        LPSperCFS= 28.317;
        M2FT = 3.28084;
        LPS2GMP = 15.850372483753;
        LPMperCFS= 1699.0;
        CMHperCFS= 101.94;
        CMDperCFS= 2446.6;
        MLDperCFS= 2.4466;
        M3perFT3=  0.028317;
        LperFT3=   28.317;
        MperFT=    0.3048;
        PSIperFT=  0.4333;
        KPAperPSI= 6.895;
        KWperHP=   0.7457;
        SECperDAY= 86400;
        SpecificGravity = 1;
        %% for GP_WDN.m
        TankIndex = 8;
        PumpIndex = 9;
        SpeedIndexInXX0 = 18;
        % 
        Head_Reservior = 700;
        Reservior_index = 1;
        ReferenceHead = 838.8;
        Delta_t = 1800;%seconds 0.5hour
    end
end

%https://www.mathworks.com/matlabcentral/answers/358826-best-method-to-define-constants-used-by-several-functions
