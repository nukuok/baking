function data_list = get_data_list(data_list_filename)
    fid = fopen(data_list_filename, 'r');
    data_list = {};
%    for ii = [1:58]
    for ii = [1:26]
        line = fgets(fid);
        data_list{end+1} = line;
    end
    fclose(fid);
