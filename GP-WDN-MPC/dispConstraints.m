function dispConstraints(constraints_flow,constraints_PressurePipe,constraints_PressureValve,constraints_PressurePump,constraints_Tank,constraints_bounds)
diary myDiaryConstraints1    



    constraints = constraints_flow;
    [m,~] = size(constraints);
    disp('constraints_flow');
    for i = 1:m
        constraints(i)
    end

    constraints = constraints_PressurePipe;
    [m,~] = size(constraints);
    disp('constraints_PressurePipe');
    for i = 1:m
        constraints(i)
    end
constraints = constraints_PressureValve;
    [m,~] = size(constraints);
    disp('constraints_PressureValve');
    for i = 1:m
        constraints(i)
    end
    
    constraints = constraints_PressurePump;
    [m,~] = size(constraints);
    disp('constraints_PressurePump');
    for i = 1:m
        constraints(i)
    end

    constraints = constraints_Tank;
    [m,~] = size(constraints);
    disp('constraints_Tank');
    for i = 1:m
        constraints(i)
    end

    constraints = constraints_bounds;
    [m,~] = size(constraints);
    disp('constraints_bounds');
    for i = 1:m
        constraints(i)
    end
    
%     constraints = constraints_Smoothness;
%     [m,~] = size(constraints);
%     disp('constraints_Smoothness');
%     for i = 1:m
%         constraints(i)
%     end
    
%     constraints = constraints_SaftyWater;
%     [m,~] = size(constraints);
%     disp('constraints_SaftyWater');
%     for i = 1:m
%         constraints(i)
%     end
    
    diary off
end