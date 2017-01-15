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
out_file_dir = '/home/nukuok/Desktop/baking/script_for_new_data/oval_20170112_merge_n_all_fix_arc/';
[s, m, mi] = mkdir(out_file_dir);
out_file_path = sprintf('%sresult.csv', out_file_dir);
fid = fopen(out_file_path, 'w');

Vehicle = 1;
Allobj = [];
%%
data_list = get_data_list('/home/nukuok/Desktop/baking/script_for_new_data/filelist_20170108');

for ii = 1:6

  input_filename = data_list{ii};
  fprintf('Dealing with %s', input_filename);
  origin_A = file_input2(input_filename(1:end-1));
  temp_index = origin_A(2,:) > 2918;
  origin_A = origin_A(:,temp_index);

  [As, index_pairs] = data_split_dynamic_20170112_1(origin_A, 5);

  consider = ones(length(As),1);
  contained = zeros(length(As),1);
  consider2 = ones(length(As),1);
  for jj = length(As):-1:1
    data_set = As{jj};
    data_length = length(data_set);
    merged_num = index_pairs(jj,3)
    if data_length > 10 * merged_num
      part_time = data_set(1,:);
      part_speed = data_set(3,:);
      part_spacing = data_set(4,:);

      figure
      hold on
      plot(origin_A(3,:),origin_A(4,:),'gx','linewidth',2)
      
      oXs = part_speed;
      oYs = part_spacing;
      plot(oXs, oYs, 'bx', 'linewidth', 3);

      result = oval_fit5_20170108(oXs, oYs);
      object = oval_equation_diff5(result(1),result(2),result(3),result(4),result(5),oXs,oYs);
      period = part_time(end) - part_time(1);
      [delta, fi, arc, omega, alpha_bar, beta_bar] = oval_find_T_20170112(result(1),result(2),result(3),result(4),result(5),oXs,oYs,period);
      % T = As{jj}(1,end) - As{jj}(1,1);
      % delta_T = delta * T;
      T = 2 * pi / omega;
      
      [Xs,Ys] = oval_points(result, 0.05);
      plot(Xs,Ys,'r')
      plot(result(3), result(4), 'rx', 'linewidth', 1)
      plot(origin_A(3,1),origin_A(4,1),'blackv','linewidth',3)


      distance_matrix = []
      for kk = 1:length(part_speed)
	distance_from_pkk = sqrt((part_speed - part_speed(kk)) .^ 2 + (part_spacing - part_spacing(kk)) .^ 2);
	% distance_from_pkk = distance_from_pkk / max(distance_from_pkk);
	distance_matrix = [distance_matrix; distance_from_pkk];
      end

      local_max_points = max_pick(distance_matrix);
      local_max_num = sum(sum(local_max_points));
      if local_max_num > 4
	consider(jj) = 0;
      end
      for kk = length(As):-1:jj+1
	if index_pairs(kk,1) <= index_pairs(jj,1) & index_pairs(jj,2) <= index_pairs(kk,2) & consider(kk) == 1
	  contained(jj) = kk;
	  consider2(jj) = 0;
	  break
	end
      end
      
      text(origin_A(3,1),origin_A(4,1)+3,int2str(local_max_num),'Color','red','FontSize',14);
      if contained(jj) == 0
	text(origin_A(3,1),origin_A(4,1)+8,'Independent','Color','red','FontSize',14);
      else
	text(origin_A(3,1),origin_A(4,1)+8,strcat('Contained in:', int2str(contained(jj))),'Color','red','FontSize',14);
      end
      
      text(origin_A(3,1),origin_A(4,1)+3,int2str(local_max_num),'Color','red','FontSize',14);
      png_name = sprintf('%s%03d-%02d.png', out_file_dir, ii, jj);
      print('-dpng','-r300', png_name)
      
      figure;
      hold on
      % surf(distance_matrix,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
      % view([0 90]);
      contourf(distance_matrix)
      colormap(flipud(gray));
      colorbar;
      % axis([0 size(distance_matrix,1) 0 size(distance_matrix,1)]);
      axis([1 size(distance_matrix,1) 1 size(distance_matrix,1)]);
      colorbar;

      [r,c] = find(local_max_points);
      plot(r,c,'ro','linewidth',3);
      
      png_name = sprintf('%s%03d-%02d-distance.png', out_file_dir, ii, jj);
      print('-dpng','-r300', png_name)

      pause(0.1)
      close all
      pause(0.1)

      point_length = length(As{jj});
      fprintf(fid, 'total_id, %d, data_file,%s,file_id,%d,part_id,%d,start_point,%d,end_point,%d,point_num,%d,object,%f,a,%f,b,%f,h,%f,k,%f,theta,%f,delta_T,%f,arc,%f,T,%f,fi,%f,omega,%f, alpha_bar, %f, beta_bar, %f, merged,%d,local_max_num,%d,consider,%d,contained,%d,consider2,%d\n', ...
	      Vehicle, input_filename(1:end-1), ii, jj, index_pairs(jj,1), index_pairs(jj,2), point_length, object, result(1),result(2),result(3),result(4),result(5),delta,arc,T,fi,omega, alpha_bar, beta_bar,merged_num,local_max_num,consider(jj),contained(jj),consider2(jj));

      Vehicle = Vehicle + 1;
    end
  end
end

fclose(fid);
