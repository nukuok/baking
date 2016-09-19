function time_region = extract_time_region_by_v(A, view_length)
    v_column = A;
    % y = arrayfun(@(x) x^2,1:10)
    column_direction = arrayfun(@(ii) up_or_down(v_column, ii, view_length), ...
        [1:(length(v_column) - view_length)]);
    time_region = column_direction;
end
    
