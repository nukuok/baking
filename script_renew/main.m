%% add_script_path
addpath('io')
addpath('preprocess_00_data_split')
addpath('preprocess_01_tobit')

%% CONFIG
global CONFIG;
gen_config

%%
data_list = get_data_list('data_list_modified');
for ii = 1:length(data_list)

  input_filename = data_list{ii};
  origin_A = file_input(input_filename(1:end-1));
  As = data_split_equal_interval(origin_A);

  for jj = 1:length(As)
    data_set = As{jj};
    part_speed = data_set(4,:);
    part_spacing = data_set(7,:);
    part_acc = data_set(14,:);

    if sum(part_acc <0.1) == 0
      continue
    end

    [part_delta, part_tau] = tobit4_lsqlin(part_speed, part_spacing, part_acc);
  end

end
