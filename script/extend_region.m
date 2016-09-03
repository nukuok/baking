function [new_point, unmoved] = extend_region(column, old_point, move)
    column_length = length(column);
    new_point = old_point + move;
    unmoved = 0;
    if new_point < 1
        unmoved = 1 - new_point;
        new_point = 1;
    elseif new_point > column_length
        unmoved = new_point - column_length;
        new_point = column_length;
    end
end