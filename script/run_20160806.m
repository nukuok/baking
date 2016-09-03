 data_list = get_data_list('/home/nukuok/Desktop/20160802/data_list_modified');
 VIEW_REGION = 11;
 EXTRACT_REGION_LENGTH = 100;
 
 for ii = 1:length(data_list)
    input_filename = data_list{ii};
    origin_A = file_input(input_filename(1:end-1));
    column = origin_A(4,:);
    region_updown = extract_time_region_by_v(column,VIEW_REGION);
    time_region = region_part_length(region_updown);
    % plot(max(origin_A(4,:)) + time_region/100);
    
    delta_x = zeros(3,1);
    x = zeros(3,1);
    for ii_dr = [1:3]
        [delta_x(ii_dr), x(ii_dr)] = max(time_region);
        time_region(x(ii_dr)) = - time_region(x(ii_dr));
    end

    region_lower = extend_region(column, x(1), - VIEW_REGION);
    region_higher = extend_region(column, x(1) + delta_x(1), + VIEW_REGION);
    [dummy, min_index] = min(column(region_lower:region_higher));
    [dummy, max_index] = max(column(region_lower:region_higher));
    min_index = min_index + region_lower;
    max_index = max_index + region_lower;
    
    [extracted_region_lower, extracted_region_upper] = ...
        determine_final_time_region(column, min_index, max_index, EXTRACT_REGION_LENGTH);
    
    draw_result
    
    
 end