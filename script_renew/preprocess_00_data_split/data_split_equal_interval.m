function As = data_split_equal_interval(A)
  global CONFIG
  SPLIT_LENGTH = CONFIG.data_split_equal_interval.split_length;

  data_length = length(A(1,:));
  split_num = ceil(data_length / SPLIT_LENGTH);
  As = cell(1,split_num);
  for ii = 1:split_num
    split_head = SPLIT_LENGTH * (ii - 1) + 1;
    if ii == split_num
      split_tail = data_length;
    else
      split_tail = SPLIT_LENGTH * ii;
    end
    As{ii} = A(:,split_head:split_tail);
  end
end

  
