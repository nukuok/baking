CONFIG = struct();
CONFIG.extract_region_in_data_part.view_region = 11;
CONFIG.extract_region_in_data_part.extract_region_length = 100;
CONFIG.data_split_equal_interval.split_length = 200;
CONFIG.make_init_sample.sample1 = 500;
CONFIG.make_init_sample.sample2 = 300;
CONFIG.make_init_sample.sample3 = 500;
CONFIG.make_init_sample.numPrms = 4;
CONFIG.MaxIteration = 1000;
CONFIG.sampling.NumSample = 5000;
CONFIG.sampling.Rho = 0.01;
CONFIG.sampling.Con = 3;
CONFIG.sampling.alpha = 0.5;
CONFIG.sampling.pregamma = 100;
CONFIG.sampling.same = 0;
CONFIG.pi = 3.1415926538979;

%% addpath('yaml')
%% config_yaml = YAML.dump(CONFIG)		      
%% YAML.write('config.yml', config_yaml)
%% config_yaml = YAML.read('config.yml')
%% CONFIG = config.load(config_yaml)
