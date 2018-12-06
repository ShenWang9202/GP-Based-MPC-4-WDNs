function obj = objectfun(XX,x_safe,Num_XX0,Hp)
    obj = 0;
    % Hp >= 1
    assert(Hp>=1, ['Hp = ' num2str(Hp) '<1 is impossible!']);
    baseIndex = 2;
    for i = 0:(Hp-1)
       obj = obj + (XX((K_th_XX_index(baseIndex+i,'x_k',Num_XX0))) - x_safe)^2;
    end
end