function feature_map = feature_map_add_group(feature_map, group_length)

num_groups = length( feature_map.map);
feature_map.map{num_groups + 1} =  zeros( 1, group_length);
