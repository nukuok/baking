%% add_script_path
addpath('io')
addpath('preprocess_00_data_split')
addpath('preprocess_01_tobit')
addpath('preprocess_02_calculate_R')
addpath('preprocess_03_oval_fit')
addpath('process_cross_entropy')


%% CONFIG
global CONFIG;
gen_config;

%% output
out_file_dir = 'result_20161107/';
[s, m, mi] = mkdir(out_file_dir);
out_file_path = sprintf('%sresult.csv', out_file_dir);
fid = fopen(out_file_path, 'w');

Vehicle = 1;
Allobj = [];
%%
data_list = get_data_list('data_list_modified');
% for ii = 1:length(data_list)
% for ii = [1,8,9,18,21,24,42]
for ii = [8]
% for ii = 5:5

  input_filename = data_list{ii};
  fprintf('Dealing with %s', input_filename);
  origin_A = file_input(input_filename(1:end-1));

  BND = get_BND(input_filename);
  [si, siu] = calculate_si_siu_t2lb(origin_A, BND);

  % As = data_split_equal_interval([origin_A;si';siu']);
  [As, index_pairs] = data_split_dynamic_0([origin_A;si';siu'],100);

  % for jj = 1:1
  % for jj = 6:6
  % for jj = 4:4
  for jj = 1:length(As)
    data_set = As{jj};
    data_length = length(data_set);
    part_speed = data_set(4,:);
    part_spacing = data_set(7,:);
    part_acc = data_set(14,:);

    [oXs, oYs] = oval_points([2,1,2,2,pi/4]);
    %% %% result = oval_fit(part_speed, part_spacing)
    %% figure
    %% plot(oXs, oYs, 'rx')
    %% 
    %% figure
    %% result = oval_fit2(oXs, oYs)
    %% oval_points2(result)

    figure
    hold on
    % plot(part_speed, part_spacing, 'rx')
    plot(oXs, oYs, 'rx')
    result = oval_fit(oXs, oYs)
    [Xs,Ys] = oval_points(result);
    plot(Xs,Ys,'b')
  end
end

fclose(fid);
