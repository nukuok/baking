function okko = merge_check_20170115(A, index_pairs_1)
  angle_calc = @(x,y) x(1)*y(2) - x(2)*y(1);
  sin_value_calc = @(x,y) angle_calc(x,y)/(norm(x) * norm(y));

  pairs_length = size(index_pairs_1,1);
  okko = ones(pairs_length,1);

  line = A([3,4],:);

  for ii = 2:pairs_length
    vec1 = line(:,index_pairs_1(ii-1,2)) - line(:,index_pairs_1(ii-1,1));
    vec2 = line(:,index_pairs_1(ii,2)) - line(:,index_pairs_1(ii,1));

    sin_value = sin_value_calc(vec1, vec2);
    if sin_value > 0.0
      okko(ii) = 0;
    end

  end
