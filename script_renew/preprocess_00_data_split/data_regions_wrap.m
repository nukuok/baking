function data_region_second = data_regions_wrap()
    data_regions_first = data_region();
    [data_num, data_max_parts] = size(data_regions_first);

    data_region_second = data_regions_first;

    data_region_needed = {};
    data_region_needed{data_num} = [];
    data_region_needed{1} = [4];
    data_region_needed{5} = [4];
    data_region_needed{8} = [1];
    data_region_needed{12} = [2,3];
    data_region_needed{9} = [2,3];
    data_region_needed{13} = [2];
    data_region_needed{14} = [1,2];
    data_region_needed{17} = [1,2];
    data_region_needed{21} = [1];
    data_region_needed{24} = [2,3];
    data_region_needed{36} = [2,3];
    data_region_needed{40} = [2,3];
    data_region_needed{41} = [3];
    data_region_needed{45} = [1];


    for ii = 1:data_num
        if length(data_region_needed{ii}) == 0
            continue
        end
        current_regions = {};
        for jj = 1:data_max_parts
            if length(data_regions_first{ii,jj}) == 0
                continue
            end
            current_regions{jj} = data_regions_first{ii,jj};
            data_region_second{ii,jj} = [];
        end
        data_start = current_regions{data_region_needed{ii}(1)}(1);
        data_end = current_regions{data_region_needed{ii}(end)}(end);
        data_region_second{ii,1} = [data_start, data_end];
    end
end
