%% add_script_path
addpath('io')
addpath('preprocess_00_data_split')
addpath('preprocess_01_tobit')
addpath('preprocess_02_calculate_R')
addpath('process_cross_entropy')

%% CONFIG
global CONFIG;
gen_config;

%% output
out_file_dir = 'result_20161001/';
[s, m, mi] = mkdir(out_file_dir);
out_file_path = sprintf('%sresult.csv', out_file_dir);
fid = fopen(out_file_path, 'w');

Vehicle = 1;
Allobj = [];
%%
data_list = get_data_list('data_list_modified');
for ii = 1:length(data_list)
% for ii = 9:9
% for ii = 5:5

  input_filename = data_list{ii};
  fprintf('Dealing with %s', input_filename);
  origin_A = file_input(input_filename(1:end-1));

  BND = get_BND(input_filename);
  [si, siu] = calculate_si_siu_t2lb(origin_A, BND);

  As = data_split_equal_interval([origin_A;si';siu']);

  % for jj = 1:1
  % for jj = 6:6
  % for jj = 4:4
  for jj = 1:length(As)
    data_set = As{jj};
    data_length = length(data_set);
    part_speed = data_set(4,:);
    part_spacing = data_set(7,:);
    part_acc = data_set(14,:);

    if sum(part_acc <0.1) == 0
      continue
    end

    [part_delta, part_tau] = tobit4_lsqlin(part_speed, part_spacing, part_acc);
    [part_R_va, part_R_sa] = calculate_R_va_and_R_sa(part_speed, data_set, part_delta, part_tau);
    [deltat_head, deltat_tail] = determine_deltat_region(part_R_va, part_R_sa, data_length);
    
    [sample, partiton] = make_init_sample(deltat_head, deltat_tail);
    max_iter = CONFIG.MaxIteration;
    same_to_Con = CONFIG.sampling.Con;
    pregamma = CONFIG.sampling.pregamma;
    con = 0;
    preprms = [];
    for iteration = 1:max_iter
      [sample, pregamma, preprms, con, partition, sample_here] = ...
      sampling(sample, data_set, data_length, partiton, iteration, ...
	       deltat_head, deltat_tail, part_tau, part_delta, con, pregamma,preprms);
      if con == same_to_Con
	break
      end
    end
    fprintf(fid, 'total_id, %d, data_file,%s,file_id,%d,part_id,%d,alpha1,%f,alpha2,%f,beta,%f,time,%f,delta,%f,tau,%f\n', ...
	    Vehicle, input_filename(1:end-1), ii, jj, preprms(1), preprms(2), preprms(3), preprms(4),part_delta, part_tau);
    %% ii, jj, iteration, partition, input_filename,
    out_dir_part = create_output_folder(out_file_dir, ii, jj);
    Allobj = output_figure(out_dir_part, partition, preprms, data_set, ...
		  sample, part_delta, part_tau, sample_here, Vehicle, Allobj);
    Vehicle = Vehicle + 1;
  end
end

fclose(fid);
