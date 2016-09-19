function [result, partition] = make_init_sample(deltat_length)
  global CONFIG
  numPrms = CONFIG.make_init_sample.numPrms;
  sample1 = CONFIG.make_init_sample.sample1;
  sample2 = CONFIG.make_init_sample.sample2;
  sample3 = CONFIG.make_init_sample.sample3;
  NumPrms = CONFIG.make_init_sample.numPrms + 1;

  NumSample = CONFIG.sampling.NumSample;
  Rho = CONFIG.sampling.Rho;
  alpha = CONFIG.sampling.alpha;
  
  result = cell(numPrms,1);
  partition = [sample1, sample2, sample3, deltat_length];
  
  for ii = 1:numPrms
    result{ii} = 1/partition(ii) * ones(partition(ii), 1);
  end

  tic;
  
  fprintf('--------------(Patameter Information)--------------\n')
  fprintf('NUMBER OF SAMPLES = '); fprintf('%u\n',NumSample)
  fprintf('RHO = '); fprintf('%f\n',Rho)
  fprintf('ALPHA = '); fprintf('%f\n',alpha)
  fprintf('--------------(Iteration Information)--------------\n');
  fprintf('ITERATION    BEST           GAMMA          TIME\n');
  
end  
