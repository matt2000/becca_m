function grouper = grouper_initialize( state_length, action_length, ...
    basic_feature_length, MAX_NUM_FEATURES)
                    
grouper.INPUT_DECAY_RATE = 1.0;
grouper.PROPENSITY_UPDATE_RATE = 10 ^ (-3); % real, 0 < x < 1
grouper.MAX_PROPENSITY = 0.1;
grouper.GROUP_DISCOUNT = 0.5;
grouper.NEW_GROUP_THRESHOLD = 0.3;     % real,  x >= 0
grouper.MIN_SIG_CORR = 0.05;  % real,  x >= 0
grouper.MAX_GROUP_SIZE = 100;
grouper.MAX_NUM_FEATURES = MAX_NUM_FEATURES;

grouper.features_full = 0;
grouper.filename_postfix = '_grouper.mat';

grouper.correlation = zeros( grouper.MAX_NUM_FEATURES);
grouper.combination = ones( grouper.MAX_NUM_FEATURES) - ...
    eye( grouper.MAX_NUM_FEATURES);
grouper.propensity = zeros( grouper.MAX_NUM_FEATURES);
grouper.groups_per_feature = zeros( grouper.MAX_NUM_FEATURES, 1);
grouper.feature_vector = zeros(grouper.MAX_NUM_FEATURES ,1);
grouper.indx_map_inv = zeros( grouper.MAX_NUM_FEATURES, 2);

%grouper.input_map   %maps input groups to feature groups
%grouper.indx_map    %maps input groups to correlation indices
%grouper.indx_map_inv%maps correlation indices to input groups

%initializes group 1
grouper.previous_input{1}= zeros( state_length, 1);
grouper.input_map{1} = horzcat( cumsum(ones( state_length, 1)), ...
                                 ones( state_length, 1) );
grouper.indx_map{1} = cumsum( ones( state_length, 1));
grouper.indx_map_inv( 1:state_length, :) = ...
    horzcat( cumsum( ones( state_length, 1)), ones( state_length, 1));
grouper.last_entry = state_length;

%initializes group 2
grouper.previous_input{2}= zeros( basic_feature_length, 1);
grouper.input_map{2} = horzcat( cumsum(ones( basic_feature_length, 1)), ...
                                 2 * ones( basic_feature_length, 1) );
grouper.indx_map{2} = ...
    cumsum( ones( basic_feature_length, 1)) + grouper.last_entry;                             
grouper.indx_map_inv( grouper.last_entry + 1: ...
                  grouper.last_entry + basic_feature_length, :) = ...
    horzcat( cumsum( ones( basic_feature_length, 1)), ...
    2 * ones( basic_feature_length, 1));
grouper.last_entry = basic_feature_length + grouper.last_entry;

%initializes group 3
grouper.previous_input{3}= zeros( action_length, 1);
grouper.input_map{3} = horzcat( cumsum(ones( action_length, 1)), ...
                                 3 * ones( action_length, 1) );
grouper.indx_map{3} = ...
    cumsum( ones( action_length, 1)) + grouper.last_entry;                             
grouper.indx_map_inv( grouper.last_entry + 1: ...
                  grouper.last_entry + action_length, :) = ...
    horzcat( cumsum( ones( action_length, 1)), ...
    3 * ones( action_length, 1));
grouper.last_entry = action_length + grouper.last_entry;
