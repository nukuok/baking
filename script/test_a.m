function [line_a, line_b] = test_a(A)
    v_lines = A;
    time_region = 100;
    row_number = length(v_lines) - time_region + 1;
    target_matrix = zeros(row_number, time_region);
    for ii = 1:row_number
        target_matrix(ii,:) = v_lines(ii:ii+time_region-1);
    end
    line_a = zeros(row_number,1);
    line_b = zeros(row_number,1);
    for ii = 1: row_number
        target_line = target_matrix(ii,:);
        if target_line(end) > target_line(1)
            line_a(ii) = test_a_a(target_line);
        else
            line_b(ii) = test_a_a(target_line);
        end
    end
    line_a = [zeros(floor(time_region/2),1);line_a];
    line_b = [zeros(floor(time_region/2),1);line_b];
end

function result = test_a_a(x)
    len = length(x);
    y = zeros(1,len);
    y(1) = x(1);
    y(len) = x(len);
    for ii = 2:len-1
        y(ii) = y(1) + (y(end) - y(1)) * (ii - 1) / len;
    end
    result = sqrt(sum(abs(x-y).^2));
end