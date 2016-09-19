function frac = calculate_R_Sa(B, k)
    len_all = length(B);
    x_i_all = B(4,1:len_all - k);
    y_i_all = B(5,1 + k:len_all);
    x_k_bar = sum(x_i_all) / length(x_i_all);
    y_k_bar = sum(y_i_all) / length(y_i_all);
    
    frac_u = sum((x_i_all - x_k_bar) .* (y_i_all - y_k_bar));
    frac_d1 = sqrt(sum((x_i_all - x_k_bar) .^ 2));
    frac_d2 = sqrt(sum((y_i_all - y_k_bar) .^ 2));
    
    frac = frac_u / (frac_d1 * frac_d2);
end
