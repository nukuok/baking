addpath('/home/nukuok/Desktop/baking/script_renew/io')

out_file_dir = 'result_20161218/';
[s, m, mi] = mkdir(out_file_dir);

data_list = get_data_list('filelist.txt');
data_name = get_data_list('filelist');

% for ii = 1:26
for ii = 1:30

  input_filename = data_list{ii};
  fprintf('Dealing with %s', input_filename);
  origin_A = file_input2(input_filename(1:end-1));
  [sort_A, index] = sort(origin_A(1,:));
  sorted_A = [origin_A(1,index);origin_A(2,index)]';

  data_length = length(sorted_A);
  sorted_A = [sorted_A; 0, 0];

  A = sorted_A(1:end-1,1);
  
  pre_B = [sorted_A(3:data_length,1)-sorted_A(2:data_length-1,1)];  A1 = -mean(pre_B)
  B = [0;0;[sorted_A(3:data_length,1)-sorted_A(2:data_length-1,1)]];

  pre_C = ([sorted_A(3:end,1) - sorted_A(1:end-2,1)] > 0.1) .* ([sorted_A(2:data_length,1) - sorted_A(1:data_length-1,1)] + A1);
  C = [0;cumsum(pre_C)];

  D = A - C;

  E = sorted_A(1:end-1,2);

  F = 5564 - E;

  G = 70 + D * 80 * 1000 / 3600;

  pre_H = -(E(3:end) - E(1:end-2))./(D(3:end) - D(1:end-2));
  H = [-(E(2) - 5564)/(D(2) - 0); pre_H ; 0];

  I = ones(data_length, 1) * 80 * 1000 / 3600;

  J = G - F;
  
  title = sprintf('%f,time_interval,0,t_fixed,distanceAlongRoad,x_f,x_l,v_f,v_l,s',A1);

  out_file_path = sprintf('%sdata_%02d.csv', out_file_dir, ii);
  fid = fopen(out_file_path, 'w');
  fprintf(fid, '%s\n',title);
  fclose(fid);
  dlmwrite(out_file_path,[A,B,C,D,E,F,G,H,I,J], '-append','precision', 9);

  figure
  plot(F,J,'linewidth',2)
  %axis([-1000,6000,min(J)-20,max(J)+20]);
  axis([-1000,6000,0,350]);
  out_fig_path = sprintf('%sdata_%02d_figure_1.png', out_file_dir, ii);
  print('-dpng','-r300', out_fig_path);
  
  figure
  plot(H,J,'x')
  %axis([-10,50,min(J)-20,max(J)+20]);
  axis([-10,50,0,350]);
  out_fig_path = sprintf('%sdata_%02d_figure_2.png', out_file_dir, ii);
  print('-dpng','-r300', out_fig_path);
  
  close all
  pause(0.1)
end
