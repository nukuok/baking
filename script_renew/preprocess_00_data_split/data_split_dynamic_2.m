function [As, index_pairs] = data_split_dynamic_2(A,min_length)
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
    % if sin_value_line(ii) > 0.1 | cos_value_line(ii) < 0.5 | ii == vector_length-1
    %   sin_err_count = sin_err_count + 1
    %   if sin_err_count >= 3 | sin_value_line(ii) > 0.05 | cos_value_line(ii) < 0.5 | ii == vector_length-1
    if sin_value_line(ii) > 0.05 | cos_value_line(ii) < 0.5 | ii == vector_length-1
      cos_err_count = cos_err_count + 1;
      if cos_err_count >= 3 | sin_value_line(ii) > 0.05 | cos_value_line(ii) < 0.5 | ii == vector_length-1
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
    end
  end
  As_length = size(index_pairs,1);
  As = cell(1,As_length);
  for ii = 1:As_length
    As{ii} = A(:,index_pairs(ii,1):index_pairs(ii,2));
  end
end
