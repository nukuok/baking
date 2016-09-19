function result = region_part_length(A_column)
    column = A_column;
    start_value = column(1);
    end_value = column(end);
    column_length = length(column);
    for ii = [1:column_length]
        if column(ii) == start_value
            column(ii) = 0;
        else
            break
        end
    end
    for ii = [column_length:-1:1]
        if column(ii) == end_value
            column(ii) = 0;
        else
            break
        end
    end

    result = zeros(size(column));
    current_index = 1;
    current_value = 0;

    for ii = [1:length(result)]
        if column(ii) == 0
            continue
        elseif column(ii) == current_value
            result(current_index) = 1 + result(current_index);
        else
            current_value = column(ii);
            current_index = ii;
            % result(current_index) = 1 + result(current_index);
        end
    end
end