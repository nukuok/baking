function [sample, pregamma, preprms, con, partition, sample_here] = ...
	 sampling(sample, data_set, data_len, partition, iteration, ...
		  deltat_head, deltat_tail, part_tau, part_delta, con, pregamma, preprms)
  global CONFIG
  NumSample = CONFIG.sampling.NumSample;
  NumPrms = CONFIG.make_init_sample.numPrms;
  Rho = CONFIG.sampling.Rho;
  alpha = CONFIG.sampling.alpha;
  same = CONFIG.sampling.same;
  same_to_Con = CONFIG.sampling.Con;
  
  v1 = data_set(4, :);
  v0 = data_set(6, :);
  detv = v0 - v1;
  a1 = data_set(14, :);
  x1 = data_set(13, :);
  space = data_set(7, :);
  x0 = x1 + space;
  ss0 = part_delta;
  ss1 = part_tau;
  si = data_set(15, :);
  siu = data_set(16, :);
  t2lb = 1;
  TTime = length(v1);
  s = data_set(7,:)';
  
  deltat_length = max(1, deltat_tail - deltat_head);
  sample_here = rand(NumSample,NumPrms+1);
  Cum_p = cell(NumPrms, 1);
  for ii = 1:NumPrms
    for jj = 1:length(sample{ii})
      Cum_p{ii}(jj, 1) = sum(sample{ii}(1:jj));
    end
  end
  
  for gn = 1:NumSample
    for ii = 1:NumPrms
      [dummy,prms(ii)] = min(abs(Cum_p{ii}-sample_here(gn,ii)));
    end
    prms2(gn,:) = prms;

    prms(1) = (prms(1)-1)/partition(1)*1;
    prms(2) = (prms(2)-1)/partition(2)*0.3;
    prms(3) = (prms(3)-1)/partition(3)*1;
    if deltat_tail ~= deltat_head
      prms(4) = int64((prms(4)-1)/partition(4)*deltat_length);
    end
      
    if iteration > 1 && gn == 1
      prms = preprms;
    end

    s_sim = zeros(data_len, 1);
    detv_sim = zeros(data_len, 1);
    a1_sim = zeros(data_len, 1);
    v1_sim = zeros(data_len, 1);
    x1_sim = zeros(data_len, 1);

    % start = prms(4)+deltat_head+1;
    if deltat_head ~= deltat_tail
      start = prms(4) + deltat_head + 1;
      to_minus = deltat_head;
    else
      start = prms(4) + 1;
      to_minus = 0;
    end
    % gn = gn
    % size(Cum_p{4})
    % size(sample_here(gn,4))
    % prms(4)
    
    % s_x0 = size(x0)
    % s_x1 = size(x1)
    % s_sum = size(s_sim)
    % start = start
    % t2lb_b = t2lb
    
    s_sim(1:start)=x0(1:start)-x1(1:start);
    detv_sim(1:start)=detv(1:start);
    a1_sim(1:start) = a1(1:start);
    v1_sim(1:start) = v1(1:start);
    x1_sim(1:start) = x1(1:start);

    for rr = start+1:TTime
      
      if rr >= t2lb
	a1_sim(rr) = prms(1)*detv_sim(rr-prms(4)-to_minus) + ...
		     prms(2)*s_sim(rr-prms(4)-to_minus) - ...
		     prms(2)*(ss1*v1_sim(rr-prms(4)-to_minus)+ss0) - ...
		     prms(3)*9.8*(si(rr)-siu(rr));
      else
	a1_sim(rr) = prms(1)*detv_sim(rr-prms(4)-to_minus) + ...
		     prms(2)*s_sim(rr-prms(4)-to_minus) - ...
		     prms(2)*(ss1*v1_sim(rr-prms(4)-to_minus)+ss0);
      end
      v1_sim(rr) = v1_sim(rr-1) + a1_sim(rr-1)*(1/10);
      x1_sim(rr) = x1_sim(rr-1) + ((v1_sim(rr)+v1_sim(rr-1))/2)*(1/10);
      
      detv_sim(rr-1) = v0(rr-1) - v1_sim(rr-1);
      s_sim(rr) = x0(rr) - x1_sim(rr);
    end

    obj1 = (s(start+1:TTime)-s_sim(start+1:TTime)).^(2)./abs(s(start+1:TTime))*(1/10);
    obj1 = sum(obj1)/(TTime-start);
    obj2 = sum(abs(s(start+1:TTime)))/(TTime-start);
    obj2 = 1/obj2;
    objFunc = sqrt(obj2*obj1);

    sample_here(gn,2:NumPrms+1) = prms(1:NumPrms);   
    sample_here(gn,1) = objFunc;
  end

  [dummy,order] = sort(sample_here(:,1),'ascend');
  sample_here = sample_here(order,:);
  prms2 = prms2(order,:);
  preprms = sample_here(1,2:NumPrms+1);

  Best = sample_here(1,1);
  BestObj(iteration,:) = sample_here(1,:);
  gamma = sample_here(round(Rho*NumSample),1);

  if gamma == pregamma
    con = con + 1;    
  else
    con = 0;
  end
  if con == same_to_Con
    return;
  end
  
  pregamma = gamma;
  
  sample_here = sample_here(1:round(Rho*NumSample),:);
  prms2 = prms2(1:round(Rho*NumSample),:);

  for ii = 1:NumPrms
    p2 = zeros(partition(ii),1);
    for jj = 1:round(Rho*NumSample)
      p2(prms2(jj, ii),1) = p2(prms2(jj, ii),1) + 1;
    end
    sample{ii} = (1-alpha)*sample{ii} + alpha*p2/jj;
  end

  % 確率分布の表示
  % if mod(Iteration,5) == 0
    % subplot(2,3,1); bar(p{1}); title('T1');
    % subplot(2,3,2); bar(p{2}); title('T2');
    % subplot(2,3,3); bar(p{3}); title('T3');
    % subplot(2,3,4); bar(p{4}); title('alpha1');
    % subplot(2,3,5); bar(p{5}); title('alpha2');
    % subplot(2,3,6); bar(p{6}); title('alpha3');
    % pause(0.1)
  % end
  % 結果の表示
  TIME = toc;
  fprintf('  %u          %3.3e      %3.3e      %f\n', iteration, Best, gamma, TIME);

end
% sample_here(1,NumPrms+1)=prms(4)+deltat_head;

