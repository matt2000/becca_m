function feature_output = util_wta( feature_input);

% performs winner-take-all on primed_vote to get feature_output
%
% no WTA is performed on group 1, the raw sensory group, group 2, the 
% hard-wired feature group, or group 3, motor group.  
% All motor commands pass through to become feature outputs.
num_groups = length(feature_input);

feature_output{2} = feature_input{2};
feature_output{3} = feature_input{3};
for k = 4:num_groups,
    [val indx] = max( abs(feature_input{k}));
    feature_output{k} = zeros( size(feature_input{k}));
    feature_output{k}(indx) = feature_input{k}(indx);
end
