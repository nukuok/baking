function [extracted_region_lower, extracted_region_upper] = extract_region_in_data_part(column)
global CONFIG
  
 VIEW_REGION = CONFIG.extract_region_in_data_part.view_region;
 EXTRACT_REGION_LENGTH = CONFIG.extract_region_in_data_part.extract_region_length;
 % column = origin_A(4,:);
 region_updown = extract_time_region_by_v(column,VIEW_REGION);
 time_region = region_part_length(region_updown);
 % plot(max(origin_A(4,:)) + time_region/100);
 
 delta_x = zeros(1,1);
 x = zeros(1,1);
 [delta_x(1), x(1)] = max(time_region);
 time_region(x(1)) = - time_region(x(1));
 
 region_lower = extend_region(column, x(1), - VIEW_REGION);
 region_higher = extend_region(column, x(1) + delta_x(1), + VIEW_REGION);
 [dummy, min_index] = min(column(region_lower:region_higher));
 [dummy, max_index] = max(column(region_lower:region_higher));
 min_index = min_index + region_lower;
 max_index = max_index + region_lower;
 
 [extracted_region_lower, extracted_region_upper] = ...
     determine_final_time_region(column, min_index, max_index, EXTRACT_REGION_LENGTH);
    
 % draw_result
 end
 
