CONFIG = struct();
CONFIG.VIEW_REGION = 11;
CONFIG.EXTRACT_REGION_LENGTH = 100;
CONFIG.data_split_equal_interval.split_length = 200;

%% addpath('yaml')
%% config_yaml = YAML.dump(CONFIG)		      
%% YAML.write('config.yml', config_yaml)
%% config_yaml = YAML.read('config.yml')
%% CONFIG = config.load(config_yaml)
