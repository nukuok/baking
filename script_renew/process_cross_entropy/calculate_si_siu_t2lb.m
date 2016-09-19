function [si, siu] = calculate_si_siu_t2lb(data_set, BND)
  x1 = data_set(13, :);
  x1_len = length(x1);
  gt = zeros(x1_len, 1);
  si = zeros(x1_len, 1);
  siu = zeros(x1_len, 1);
  if BND == '1'
    for igh=1:x1_len
      if x1(igh) < 653
	gt(igh) = -2.980 + 2.980 * x1(igh) / 653;
      else
	gt(igh) = 0 + 2.999 * (x1(igh) - 653) / 1452;
      end
      si(igh) = sin(gt(igh)/100);
      siu(igh) = sin(-2.980/100);
    end
  elseif BND == '2'
    for igh=1:x1_len
      if x1(igh) < 1452
	gt(igh) = -2.999 + 2.999 * x1(igh) / 1452;
      else
	gt(igh) = 0 + 2.943 * (x1(igh) - 1452) / 653;
      end
      si(igh) = sin(gt(igh)/100);
      siu(igh) = sin(-2.999/100);
    end
  end

end
