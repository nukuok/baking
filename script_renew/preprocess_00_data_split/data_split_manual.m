function [As, index_pairs] = data_split_manual(A, file_id)
  global CONFIG

  data_regions = data_regions_wrap();

  [file_num, file_parts] = size(data_regions);

  index_pairs = []
  for ii = 1:file_parts
      if length(data_regions{file_id, ii}) == 0
          break
      end
      data_start = data_regions{file_id, ii}(1);
      data_end = data_regions{file_id, ii}(2);
      As{ii} = A(:,data_start:data_end);
      index_pairs = [index_pairs;data_start,data_end];
  end
end

