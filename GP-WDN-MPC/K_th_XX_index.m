function index = K_th_XX_index(k,type,XX_size)
    switch type
        case 'z_k'
            index = 1:7;
            index = index + (k-1)* XX_size;
        case 'x_k'
            index = 8:8;
            index = index + (k-1)* XX_size;
        case 'w_k'
            index = 9:15;
            index = index + (k-1)* XX_size;
        case 'u_k'
            index = 16:17;
            index = index + (k-1)* XX_size;
        case 'speed_k'
            index = 18:18;
            index = index + (k-1)* XX_size;
    end
end