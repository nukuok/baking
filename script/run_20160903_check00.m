 data_list = get_data_list('/home/nukuok/Desktop/20160802/data_list_modified');
 % VIEW_REGION = 11;
 % EXTRACT_REGION_LENGTH = 100;
 
 for ii = 1:length(data_list)
    input_filename = data_list{ii};
    origin_A = file_input(input_filename(1:end-1));
    % input_filename = '/home/nukuok/Desktop/20160802/data/ID2_RND3_BND1_VEC1_SPD85.csv'
    % origin_A = file_input(input_filename);
    speed = origin_A(4,:);
    spacing = origin_A(7,:);
    acc = origin_A(14,:);
    
    fg = figure;
    hold on;
    for jj = 1:length(speed)
        if abs(acc(jj)) < 0.1
            plot(speed(jj), spacing(jj), 'bo')
        else
            plot(speed(jj), spacing(jj), 'yo')
        end
    end
    
    save_name = sprintf('/home/nukuok/Desktop/20160802/figure_speed_spacing/%d.png', ii);
    saveas(fg,save_name);
    close(fg);
 end
