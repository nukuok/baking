function [lower, upper] = determine_final_time_region(column, ...
    index1, index2, final_point_number)
    if index1 < index2
        lower = index1;
        upper = index2;
    else
        lower = index2;
        upper = index1;
    end
    
    current_point_number = upper - lower + 1;
    if current_point_number < final_point_number
        before_lower = floor((final_point_number - current_point_number) / 2);
        after_lower = ceil((final_point_number - current_point_number) / 2);
        [lower, unmoved] = extend_region(column, lower, - before_lower);
        [upper, unmoved] = extend_region(column, upper, after_lower + unmoved);
        lower = extend_region(column, lower, - unmoved);
    end
end