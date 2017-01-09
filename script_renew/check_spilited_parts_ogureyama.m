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
out_file_dir = 'result_20161226_ogureyama_deltaT/';
[s, m, mi] = mkdir(out_file_dir);
out_file_path = sprintf('%sresult.csv', out_file_dir);
fid = fopen(out_file_path, 'w');

Vehicle = 1;
Allobj = [];
%%
data_list = get_data_list('data_list_modified');
for ii = [1,5,8,9,12,13,14,17,21,24,36,40,41,45]
% for ii = [5,45]


  input_filename = data_list{ii};
  fprintf('Dealing with %s', input_filename);
  origin_A = file_input(input_filename(1:end-1));

  BND = get_BND(input_filename);
  [si, siu] = calculate_si_siu_t2lb(origin_A, BND);

  % As = data_split_equal_interval([origin_A;si';siu']);
  [As, index_pairs] = data_split_manual2([origin_A;si';siu'], ii);
  index_pairs
  % for jj = 1:1
  % for jj = 6:6
  % for jj = 4:4
  for jj = 1:length(As)
    data_set = As{jj};
    data_length = length(data_set);
    part_speed = data_set(4,:);
    part_spacing = data_set(7,:);
    part_acc = data_set(14,:);

    figure
    hold on
    plot(origin_A(4,:),origin_A(7,:),'g')
    plot(origin_A(4,1),origin_A(7,1),'blackv','linewidth',3)
    
    oXs = part_speed;
    oYs = part_spacing;
    plot(oXs, oYs, 'bx', 'linewidth', 3);

    result = oval_fit4(oXs, oYs)
    [delta, fi, arc] = oval_find_T(result(1),result(2),result(3),result(4),result(5),oXs,oYs);
    T = As{jj}(1,end) - As{jj}(1,1);
    delta_T = delta * T;

    [Xs,Ys] = oval_points(result, 0.05);
    plot(Xs,Ys,'r')
    plot(result(3), result(4), 'rx', 'linewidth', 1)

    png_name = sprintf('%s%03d-%02d.png', out_file_dir, ii, jj);
    print('-dpng','-r300', png_name)
    close all
    pause(0.1)

    fprintf(fid, 'total_id, %d, data_file,%s,file_id,%d,part_id,%d,start_point,%d,end_point,%d,a,%f,b,%f,h,%f,k,%f,theta,%f,delta_T,%f,arc,%f,T,%f,fi,%f\n', ...
	    Vehicle, input_filename(1:end-1), ii, jj, index_pairs(jj,1), index_pairs(jj,2), result(1),result(2),result(3),result(4),result(5),delta_T,arc,T,fi);

    Vehicle = Vehicle + 1;
  end
end

fclose(fid);
