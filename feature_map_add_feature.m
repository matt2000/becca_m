function feature_map = feature_map_add_feature(...
    feature_map, k, has_dummy, new_feature)

feature_map.map{k}= [feature_map.map{k}; new_feature'];

% if dummy feature is still in place, removes it
if (has_dummy)
    feature_map.map{k}= feature_map.map{k}( 2:end,:);
end
       