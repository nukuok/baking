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
out_file_dir_parent = '/home/nukuok/Desktop/baking/script_for_new_data/result_20170128_ogureyama/';
[s, m, mi] = mkdir(out_file_dir_parent);

Vehicle = 1;
Allobj = [];
%%
data_list = get_data_list('data_list_modified');

for ii = [1,5,8,9,12,13,14,17,21,24,36,40,41,45]

  out_file_dir = sprintf('%s%02d/', out_file_dir_parent, ii)
  [s, m, mi] = mkdir(out_file_dir);
  out_file_path = sprintf('%sresult.csv', out_file_dir);
  fid = fopen(out_file_path, 'w');
  
  input_filename = data_list{ii};
  fprintf('Dealing with %s', input_filename);
  origin_A = file_input_20170122(input_filename(1:end-1));

  png_name = sprintf('%s%03d-split.png', out_file_dir, ii);
  [As, index_pairs] = data_split_manual2_20170128(origin_A, ii);
  % box on;
  % grid on;
  % grid minor;
  % print('-dpng','-r300', png_name)

  % png_name = sprintf('%s%03d-split-ranged.png', out_file_dir, ii);
  % xlabel('Spacing (m)')
  % ylabel('Speed (m/s)')
  % xlim([0 100]);
  % ylim([15 30]);
  % box on;
  % grid on;
  % grid minor;
  % print('-dpng','-r300', png_name)

  consider = ones(length(As),1);
  contained = zeros(length(As),1);
  consider2 = ones(length(As),1);

  fig = figure(1);
  set(fig,'Position', [100,100,350,280]);
  % figure('Position', [100,100,500,300]);
  hold on
  maing = gca;

  for mamek = 10:20:250
    plot([mamek,mamek],[-10,50],'color',[0.8,0.8,0.8],'linewidth',0.5);
  end
  for mamek = 20:20:260
    plot([mamek,mamek],[-10,50],'color',[0.5,0.5,0.5],'linewidth',0.5);
  end
  % for mamek = 1:2:31
  %   plot([0,500],[mamek,mamek],'black:','linewidth',0.1);
  % end
  for mamek = 0:2:32
    plot([-10,500],[mamek,mamek],'color',[0.5,0.5,0.5],'linewidth',0.5);
  end

  % plot([75,75],[0,50],'color',[0.8,0.8,0.8],'linewidth',3);
  % plot([80,80],[0,50],':','color',[0.8,0.8,0.8],'linewidth',3);
  % plot([85,85],[0,50],'color',[0.8,0.8,0.8],'linewidth',3);
  p2 = plot([75,75],[-10,50],'--','color',[0.4,0.4,0.9],'linewidth',2);
  p1 = plot([80,80],[-10,50],'color',[0.4,0.4,0.9],'linewidth',2);
  plot([85,85],[-10,50],'--','color',[0.4,0.4,0.9],'linewidth',2);
  legend([p2,p1], 'preceding car''s speed', 'light stimulus'' speed', 'Location', 'southwest');
  legend boxoff;

  plot(origin_A(7,:),origin_A(4,:),'y.','linewidth',2)
  plot(origin_A(7,1),origin_A(4,1),'bv','linewidth',3)

  to_plot_oval_x = [];
  to_plot_oval_y = [];
  to_plot_oval_center = [];
  
  for jj = length(As):-1:1
    jj
    data_set = As{jj};
    part_time = data_set(1,:);
    part_speed = data_set(4,:);
    part_spacing = data_set(7,:);

    oXs = part_speed;
    oYs = part_spacing;


    plot(oYs, oXs, 'gx', 'linewidth', 1);

    
    distance_matrix = [];
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

    if 1
      data_length = length(data_set);
      % merged_num = index_pairs(jj,3)
      % if data_length > 10 * merged_num
      if 1
	result = oval_fit4_20170122(oXs, oYs);
	object = oval_equation_diff5(result(1),result(2),result(3),result(4),result(5),oXs,oYs);
	period = part_time(end) - part_time(1);
	[delta, fi, arc, omega, alpha_bar, beta_bar] = oval_find_T_20170112(result(1),result(2),result(3),result(4),result(5),oXs,oYs,period);
        % T = As{jj}(1,end) - As{jj}(1,1);
        % delta_T = delta * T;
	T = 2 * pi / omega;
      
	[Xs,Ys] = oval_points_20170128(result, 0.05);

	%% figure(1)
	% figure(1);
	% maing = gca;
	% plot(Ys,Xs,'r','linewidth',1)
	% plot(result(4), result(3), 'rx', 'linewidth', 1)
	to_plot_oval_x = [to_plot_oval_x; Xs];
	to_plot_oval_y = [to_plot_oval_y; Ys];
	to_plot_oval_center = [to_plot_oval_center; [result(4), result(3)]];
	
	%% plot([result(4),Ys(1)], [result(3),Xs(1)], 'r--', 'linewidth', 1)

	%% text(origin_A(4,1),origin_A(3,1)+1,int2str(local_max_num),'Color','red','FontSize',14);
	%% if contained(jj) == 0
	%%   text(origin_A(4,1),origin_A(3,1)+2,'Independent','Color','red','FontSize',14);
	%% else
	%%   text(origin_A(4,1),origin_A(3,1)+2,strcat('Contained in:', int2str(contained(jj))),'Color','red','FontSize',14);
	%% end

	xlabel('                                                        Spacing (m)', 'FontSize', 20)
	ylabel('                                            Speed (m/s)', 'FontSize', 20)

	xlim([0 140]);
	ylim([0 30]);

	% maing.XTick = [0:20:140];
	% maing.YTick = [0:2:30];

	% set(maing,'XTick',[0:20:140]);
	% set(maing,'YTick',[0:2:30]);

	%% text(origin_A(4,1),origin_A(3,1)+2,int2str(local_max_num),'Color','red','FontSize',14);
	png_name = sprintf('%s%03d-%02d.png', out_file_dir, ii, jj);
	%% print('-dpng','-r300', png_name)
	
	xlim([0 250]);
	ylim([0 32]);

	set(maing,'XTick',[0:20:250]);
	set(maing,'YTick',[0:2:32]);
	set(maing,'fontsize',18);
	set(maing,'fontname','arial');
	set(maing,'linewidth',2);

	% maing.XTick = [0:20:250];
	% maing.YTick = [0:2:32];

	box on;

	png_name = sprintf('%s%03d-%02d-ranged.png', out_file_dir, ii, jj);
	%% print('-dpng','-r300', png_name)


	% relative speed
	vectorA = part_speed - 22.22222222;
	% acc
	vectorB = (vectorA(3:end) - vectorA(1:end-2))/0.2;
	vectorA = vectorA(2:end-1);

	len_R_line = length(vectorB);
	R_line = zeros(len_R_line - 100,1);
	for k = 1:len_R_line - 100
	  R_line(k) = calculate_R_20170122(vectorA, vectorB, k);
	end

	% relation
	% figure;
	% hold on;
	% 
	% plot(R_line, 'linewidth', 2)
	% 
	% plot([0 length(R_line)], [-0.9 -0.9], '--');
	% plot([0 length(R_line)], [0.9 0.9], '--');
	% 
	% R_line_relation = R_line > 0.9;
	% R_line_relation2 = R_line < -0.9;
	% [R_max, R_max_index] = max(R_line);
	% [R_min, R_min_index] = min(R_line);
	% 
	% R_range = 1:length(R_line);
	% plot(R_range(R_line > 0.9), R_line(R_line > 0.9), 'g', 'linewidth', 3);
	% plot(R_range(R_line < -0.9), R_line(R_line < -0.9), 'g', 'linewidth', 3);
	% 
	% plot(R_max_index, R_max, 'ro');
	% tttt = sprintf('Max %0.3f', R_max);
	% text(R_max_index, R_max - 0.1, tttt,'Color','red','FontSize',14);
	% plot(R_min_index, R_min, 'ro');
	% tttt = sprintf('Min %0.3f', R_min);
	% text(R_min_index, R_min + 0.1, tttt,'Color','red','FontSize',14);
	% 
	% xlabel('time (1/10 s)')
	% ylabel('Relation')
	% ylim([-1 1]);
	% 
	% png_name = sprintf('%s%03d-%02d-relation.png', out_file_dir, ii, jj);
	% print('-dpng','-r300', png_name)

	% xlim([0 length(R_line)]);

	% png_name = sprintf('%s%03d-%02d-relation-ranged.png', out_file_dir, ii, jj);
	% print('-dpng','-r300', png_name)

	% out_file_path_relation = sprintf('%s%03d-%02d-relation.csv', out_file_dir, ii, jj);
	% fid2 = fopen(out_file_path_relation, 'w');
	% 
	% fprintf(fid2, 'time, shifted_time, acc, related_speed, relation, >0.9, <-0.9\n');

	
	% % for mm = index_pairs(jj, 1) + 1 : index_pairs(jj, 2) - 1
	% for mm = 1:length(vectorB)
	%   if mm == R_max_index
	%     fprintf(fid2, '%0.1f,%0.1f,%f,%f,%f,max_here,%d\n', ...
	% 	    origin_A(1, mm + index_pairs(jj, 1)), mm * 0.1, vectorA(mm), vectorB(mm), ...
	% 	    R_line(mm),R_line_relation2(mm));
	%   elseif mm == R_min_index
	%     fprintf(fid2, '%0.1f,%0.1f,%f,%f,%f,%d, min_here\n', ...
	% 	    origin_A(1, mm + index_pairs(jj, 1)), mm * 0.1, vectorA(mm), vectorB(mm), ...
	% 	    R_line(mm),R_line_relation(mm));
	%   elseif mm <= length(R_line_relation)
	%     fprintf(fid2, '%0.1f,%0.1f,%f,%f,%f,%d, %d\n', ...
	% 	    origin_A(1, mm + index_pairs(jj, 1)), mm * 0.1, vectorA(mm), vectorB(mm), ...
	% 	    R_line(mm),R_line_relation(mm), R_line_relation2(mm));
	%   else
	%     fprintf(fid2, '%0.1f,%0.1f,%f,%f\n', ...
	% 	    origin_A(1, mm + index_pairs(jj, 1)), mm * 0.1, vectorA(mm), vectorB(mm));
	%   end
	% end
	% 
	% fclose(fid2)

	% distance
	% figure;
	% hold on
	% contourf(distance_matrix)
	% colormap(flipud(gray));
	% colorbar;
	% % axis([0 size(distance_matrix,1) 0 size(distance_matrix,1)]);
	% axis([1 size(distance_matrix,1) 1 size(distance_matrix,1)]);
	% colorbar;
	% 
	% [r,c] = find(local_max_points);
	% plot(r,c,'ro','linewidth',3);
	% 
	% png_name = sprintf('%s%03d-%02d-distance.png', out_file_dir, ii, jj);
	% print('-dpng','-r300', png_name)

	point_length = length(As{jj});
	fprintf(fid, 'total_id, %d, data_file,%s,file_id,%d,part_id,%d,start_point,%d,end_point,%d,point_num,%d,object,%f,a,%f,b,%f,h,%f,k,%f,theta,%f,delta_T,%f,arc,%f,T,%f,fi,%f,omega,%f, alpha_bar, %f, beta_bar, %f, merged,%d,local_max_num,%d,consider,%d,contained,%d,consider2,%d\n', ...
		Vehicle, input_filename(1:end-1), ii, jj, index_pairs(jj,1), index_pairs(jj,2), point_length, object, result(1),result(2),result(3),result(4),result(5),delta,arc,T,fi,omega, alpha_bar, beta_bar,merged_num,local_max_num,consider(jj),contained(jj),consider2(jj));
      end

      % pause(0.1)
      % close all
      % pause(0.1)

      Vehicle = Vehicle + 1;
    end
  end
  figure(1);
  maing = gca;
  for mamekk2 = 1:size(to_plot_oval_center,1)
    plot(to_plot_oval_y(mamekk2,:),to_plot_oval_x(mamekk2,:),'black','linewidth',1)
    plot(to_plot_oval_center(mamekk2,1), to_plot_oval_center(mamekk2,2), 'blackx', 'linewidth', 3)
  end

  xlim([0 140]);
  ylim([0 30]);

  fig = gcf;
  set(fig,'PaperUnits','centimeters');
  set(fig,'PaperPosition', [0 0 23 15]);

  png_name = sprintf('%s%03d-range1.png', out_file_dir, ii);
  print('-dpng', '-r80',png_name)

  xlim([0 250]);
  ylim([0 32]);
  png_name = sprintf('%s%03d-range2.png', out_file_dir, ii);
  print('-dpng', '-r80', png_name)

  close all
  fclose(fid);
end

