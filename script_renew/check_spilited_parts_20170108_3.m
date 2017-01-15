%% add_script_path
addpath('io')
addpath('preprocess_00_data_split')
addpath('preprocess_01_tobit')
addpath('preprocess_02_calculate_R')
addpath('preprocess_03_oval_fit')
addpath('process_cross_entropy')
addpath('/home/nukuok/Desktop/baking/script_for_new_data/')


%% CONFIG
global CONFIG;
gen_config;

%% output
% out_file_dir = '/home/nukuok/Desktop/baking/script_for_new_data/oval_20170108_2/';
% out_file_dir = '/home/nukuok/Desktop/baking/script_for_new_data/oval_20170108_3/';
% out_file_dir = '/home/nukuok/Desktop/baking/script_for_new_data/oval_20170108_4/';
out_file_dir = '/home/nukuok/Desktop/baking/script_for_new_data/oval_20170108_6/';
[s, m, mi] = mkdir(out_file_dir);
out_file_path = sprintf('%sresult.csv', out_file_dir);
fid = fopen(out_file_path, 'w');

Vehicle = 1;
Allobj = [];
%%
data_list = get_data_list('/home/nukuok/Desktop/baking/script_for_new_data/filelist_20161224');

for ii = 1:26

  input_filename = data_list{ii};
  fprintf('Dealing with %s', input_filename);
  origin_A = file_input2(input_filename(1:end-1));
  temp_index = origin_A(2,:) > 2918;
  origin_A = origin_A(:,temp_index);

  [As, index_pairs] = data_split_dynamic_20170108_stage_one(origin_A, 20);

  split_more = [3,1;4,4;9,3;11,3;12,1;13,2;14,2;15,4;16,1;17,3;18,4;19,1;21,2;25,2];

  Xs = origin_A(3,:);
  Ys = origin_A(4,:);
  distance_matrix = []
  for kk = 1:length(Xs)
    distance_from_pkk = sqrt((Xs - Xs(kk)) .^ 2 + (Ys - Ys(kk)) .^ 2);
     % distance_from_pkk = distance_from_pkk / max(distance_from_pkk);
    distance_matrix = [distance_matrix; distance_from_pkk];
  end      
  figure;
  surf(distance_matrix,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
  view([0 90]);
	% axis([0 size(distance_matrix,1) 0 size(distance_matrix,1)]);
  axis([1 size(distance_matrix,1) 1 size(distance_matrix,1)]);
  colorbar;

  png_name = sprintf('%s%03d-oval-distance.png', out_file_dir, ii);
  print('-dpng','-r300', png_name)

  pause(0.1);
  close all;
  
%   for jj = 1:length(As)
%     % if jj == split_more(split_more(:,1) == ii, 2)
%     % if abs(jj - split_more(split_more(:,1) == ii, 2)) <= 1
%     if 1
%       data_set = As{jj};
%       data_length = length(data_set);
%       part_speed = data_set(3,:);
%       part_spacing = data_set(4,:);
% 
%       figure
%       hold on
%       plot(origin_A(3,:),origin_A(4,:),'gx','linewidth',2)
%       
%       oXs = part_speed;
%       oYs = part_spacing;
%       plot(oXs, oYs, 'bx', 'linewidth', 3);
% 
%       result = oval_fit5(oXs, oYs);
%       [delta, fi, arc] = oval_find_T(result(1),result(2),result(3),result(4),result(5),oXs,oYs);
%       T = As{jj}(1,end) - As{jj}(1,1);
%       delta_T = delta * T;
%       
%       [Xs,Ys] = oval_points(result, 0.05);
%       plot(Xs,Ys,'r')
%       plot(result(3), result(4), 'rx', 'linewidth', 1)
%       plot(origin_A(3,1),origin_A(4,1),'blackv','linewidth',3)
% 
%       png_name = sprintf('%s%03d-%02d.png', out_file_dir, ii, jj);
%       print('-dpng','-r300', png_name)
% 
%       distance_matrix = []
%       for kk = 1:length(part_speed)
% 	distance_from_pkk = sqrt((part_speed - part_speed(kk)) .^ 2 + (part_spacing - part_spacing(kk)) .^ 2);
% 	% distance_from_pkk = distance_from_pkk / max(distance_from_pkk);
% 	distance_matrix = [distance_matrix; distance_from_pkk];
%       end
%       figure;
%       surf(distance_matrix,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
%       view([0 90]);
%       % axis([0 size(distance_matrix,1) 0 size(distance_matrix,1)]);
%       axis([1 size(distance_matrix,1) 1 size(distance_matrix,1)]);
%       colorbar;
% 
%       png_name = sprintf('%s%03d-%02d-distance.png', out_file_dir, ii, jj);
%       print('-dpng','-r300', png_name)
% 
%       distance_matrix = []
%       for kk = 1:length(Xs)
% 	distance_from_pkk = sqrt((Xs - Xs(kk)) .^ 2 + (Ys - Ys(kk)) .^ 2);
% 	% distance_from_pkk = distance_from_pkk / max(distance_from_pkk);
% 	distance_matrix = [distance_matrix; distance_from_pkk];
%       end      
%       figure;
%       surf(distance_matrix,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
%       view([0 90]);
%       % axis([0 size(distance_matrix,1) 0 size(distance_matrix,1)]);
%       axis([1 size(distance_matrix,1) 1 size(distance_matrix,1)]);
%       colorbar;
% 
%       png_name = sprintf('%s%03d-%02d-oval-distance.png', out_file_dir, ii, jj);
%       print('-dpng','-r300', png_name)
%       
%       pause(0.3)
%       close all
% 
%       fprintf(fid, 'total_id, %d, data_file,%s,file_id,%d,part_id,%d,start_point,%d,end_point,%d,a,%f,b,%f,h,%f,k,%f,theta,%f,delta_T,%f,arc,%f,T,%f,fi,%f\n', ...
% 	      Vehicle, input_filename(1:end-1), ii, jj, index_pairs(jj,1), index_pairs(jj,2), result(1),result(2),result(3),result(4),result(5),delta_T,arc,T,fi);
%     end
  Vehicle = Vehicle + 1;
end

fclose(fid);
