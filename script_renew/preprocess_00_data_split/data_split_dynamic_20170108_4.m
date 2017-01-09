function [As, index_pairs_all] = data_split_dynamic_20170108_4(A,min_length)
  add_column = @(Vector, value) [Vector, ones(size(Vector,1),1) * value]

  angle_calc = @(x,y) x(1)*y(2) - x(2)*y(1);
  std_vec_calc = @(x) x/norm(x);
  sin_value_calc = @(x,y) angle_calc(x,y)/(norm(x) * norm(y));
  cos_value_calc = @(x,y) x*y'/(norm(x) * norm(y));

  As = {};
  line = A([3,4],:);
  vector = line(:,2:end) - line(:,1:end-1);
  vector_length = size(vector,2);

  cos_value_line = zeros(1,vector_length-1);
  sin_value_line = zeros(1,vector_length-1);
  for ii = 1:vector_length-1
    cos_value_line(ii) = cos_value_calc(vector(:,ii)', vector(:,ii+1)');
    sin_value_line(ii) = sin_value_calc(vector(:,ii)', vector(:,ii+1)');
  end

  figure
  plot(line(1,:), line(2,:))
  hold on
  plot(line(1,1), line(2,1), 'blackv', 'LineWidth', 3)
  
  current = 2;
  index_pairs=[];
  sin_err_count = 0;
  cos_err_count = 0;
  for ii = 1:vector_length-1
    if sin_value_line(ii) > 0.0 | cos_value_line(ii) < 0.5 | ii == vector_length-1
      if ii - current >= min_length
	sin_err_count = 0;
	cos_err_count = 0;
	index_pairs=[index_pairs;current, ii];
	plot(line(1,current:ii), line(2,current:ii), 'r')
	plot(line(1,current), line(2,current), 'ro', 'LineWidth',2)
	plot(line(1,ii), line(2,ii), 'bo', 'LineWidth',2)
      end
      current = ii + 1;
    end
    % end
  end
  As = {};

  As_length = size(index_pairs,1);
  % As = cell(1,As_length);
  for ii = 1:As_length
    As{ii} = A(:,index_pairs(ii,1):index_pairs(ii,2));
  end

  row = size(index_pairs,1);
  index_pairs_group = {}
  index_pairs_group{1} = add_column(index_pairs,1);
  to_merge = 10
  for ii = 2:to_merge
    if row < ii
      break
    else
      index_pairs_group{ii} = add_column([index_pairs(1:end-ii+1,1),index_pairs(ii:end,2)],ii);
    end
  end

  index_pairs_all = []
  for ii = 1:to_merge
    index_pairs_all = [index_pairs_all;index_pairs_group{ii}];
  end

  As_length_total = size(index_pairs_all,1);
  for ii = As_length + 1:As_length_total
    As{ii} = A(:,index_pairs_all(ii,1):index_pairs_all(ii,2));
  end

end
