function data_region_second = data_regions_wrap2()
    data_regions_first = data_region();
    [data_num, data_max_parts] = size(data_regions_first);

    data_region_second = data_regions_first;

    data_region_needed = {};
    data_region_needed{data_num} = [];
    data_region_needed{1} = {[1],[2],[3],[4]};
    data_region_needed{5} = {[1],[3],[4]};
    data_region_needed{8} = {[1]};
    data_region_needed{9} = {[1],[2],[3]};
    data_region_needed{12} = {[1],[2,3],[4]};
    data_region_needed{13} = {[1],[2],[3]};
    data_region_needed{14} = {[1],[2]};
    data_region_needed{17} = {[1,2]};
    data_region_needed{21} = {[1]};
    data_region_needed{24} = {[1],[2],[3]};
    data_region_needed{36} = {[1],[2],[3]};
    data_region_needed{40} = {[1],[2,3]};
    data_region_needed{41} = {[1],[2],[3]};
    data_region_needed{45} = {[1],[2]};

    data_region_second = data_region_needed;
end
