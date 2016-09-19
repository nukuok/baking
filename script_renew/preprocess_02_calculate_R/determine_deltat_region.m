function [deltat_head, deltat_tail] = determine_deltat_region(part_R_va, part_R_sa, data_set_len)
  deltat_head = 1;
  deltat_tail = data_set_len;

  for ii = 1:length(part_R_sa)
    if part_R_sa(ii) >= 0.8
      deltat_head = ii;
      deltat_tail = ii;
      break
    end
  end

  for jj = ii+1:length(part_R_sa)
    if part_R_sa(jj) < 0.8
      break
    else
      deltat_tail = jj;
    end
  end
  
  for ii = 1:length(part_R_va)
    if part_R_va(ii) >= 0.8
      deltat_head = ii;
      deltat_tail = ii;
      break
    end
  end

  for jj = ii+1:length(part_R_va)
    if part_R_va(jj) < 0.8
      break
    else
      deltat_tail = jj;
    end
  end

end
