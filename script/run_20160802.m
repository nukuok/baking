 data_list = get_data_list('/home/nukuok/Desktop/20160802/data_list_modified');
 for ii = 1
    input_filename = data_list{ii};
    origin_A = file_input(input_filename(1:end-1));
    figure
    plot(origin_A(4,:),'r')
    [line_pos, line_neg] = test_a(origin_A(4,:));
    hold on
    plot(mean(origin_A(4,:))+line_pos/3)
    plot(mean(origin_A(4,:))-line_neg/3)
 end