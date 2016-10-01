function [R_va, R_Sa]= calculate_R_va_and_R_sa(part_speed, part_A, delta, tau)
  [e_r_l, e_r_u] = extract_region_in_data_part(part_speed);
  %% e_r_l = e_r_l + region_for_tobit_head - 1;
  %% e_r_u = e_r_u + region_for_tobit_head - 1;
  % fprintf(fid, 'region_head, %d, region_tail, %d\n', e_r_l, e_r_u);

  e_r_length = e_r_u - e_r_l + 1;
  
  eA = part_A;

  % 1 time
  % 4 following_speed
  % 6 followed_speed
  % 7 spacing
  % 13 following_position
  % 14 acc
  B = [eA([1,4,6],:); eA(7,:) - delta - tau * eA(4,:) ; eA(14,:)];
  R_va = zeros(100,1);
  R_Sa = zeros(100,1);
  % for jj = 1:e_r_length
  for jj = 1:e_r_length-30
    R_va(jj) = calculate_R_va(B,jj);
    R_Sa(jj) = calculate_R_sa(B,jj);
  end
end
