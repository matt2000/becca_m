function feature_map = feature_map_initialize( state_length, ...
                    basic_feature_length, action_length)

feature_map.NEW_FEATURE_MARGIN = 0.3;    % real, 0 <= x <= 1
feature_map.NEW_FEATURE_MIN_SIZE = 0.2;  % real, 0 <= x

feature_map.map{1} = eye( state_length);
feature_map.map{2} = eye( basic_feature_length);
feature_map.map{3} = eye( action_length);
