function [As, index_pairs] = data_split_manual2_20170128(A, file_id)
  global CONFIG

  line = A([4,7],:);
  % figure
  % plot(line(2,:), line(1,:))
  % hold on
  % plot(line(2,1), line(1,1), 'blackv', 'LineWidth', 3)

  data_region_first = data_region();
  data_regions_second = data_regions_wrap2();

  data_parts = {}
  for ii = 1:5
    data_parts{ii} = data_region_first{file_id,ii}
  end
  data_parts_needed = data_regions_second{file_id}
  
  index_pairs = []

  if length(data_parts_needed) == 0
    As = {}
  else
    As = {}
    for jj = 1:length(data_parts_needed)
      temp_A = [];
      parts_group = data_parts_needed{jj}
      if length(parts_group) == 0
	continue
      end

      for ii = 1:length(parts_group)
	parts_group
	ii
	part_id = parts_group(ii)
	c_A = A(:,data_parts{part_id}(1):data_parts{part_id}(2));
	size(c_A)
	size(temp_A)
	temp_A = [temp_A,c_A];
      end
      id_start = data_parts{parts_group(1)}(1)
      id_end = data_parts{parts_group(end)}(2)
      index_pairs = [index_pairs; id_start, id_end]

      % plot(A(7,id_start:id_end), A(4,id_start:id_end), 'r')
      % plot(A(7,id_start), A(4,id_start), 'ro', 'LineWidth',2)
      % plot(A(7,id_end), A(4,id_end), 'bo', 'LineWidth',2)

      As{jj} = temp_A
    end
  end
end
