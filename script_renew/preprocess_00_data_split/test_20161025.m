addpath('io')
addpath('preprocess_00_data_split')
addpath('preprocess_01_tobit')
addpath('preprocess_02_calculate_R')
addpath('process_cross_entropy')

data_list = get_data_list('data_list_modified');
out_dir = '/home/nukuok/Desktop/baking/script_renew/split_test_figure_20161025/'

for ii = 1:length(data_list)
  input_filename = data_list{ii};
  origin_A = file_input(input_filename(1:end-1));
  [a,b] = data_split_dynamic_0(origin_A,100);
  png_name = strcat(out_dir, sprintf('%03d', ii));
  print('-dpng','-r300', png_name);
  close all
  pause(0.1)
end
