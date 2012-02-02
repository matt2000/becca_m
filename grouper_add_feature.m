function grouper = grouper_add_feature(grouper, k, has_dummy)
%adds a feature to group k

grouper.previous_input{k} = [grouper.previous_input{k}; 0;];

if (has_dummy)
    grouper.previous_input{k} = grouper.previous_input{ k}( 2:end);
    
    grouper.correlation( grouper.indx_map{k}, :) = 0;
    grouper.correlation( :, grouper.indx_map{k}) = 0;
    grouper.propensity( grouper.indx_map{k}, :) = 0;
    grouper.propensity( :, grouper.indx_map{k}) = 0;
else
    grouper.last_entry = grouper.last_entry + 1;
    grouper.indx_map{k} = ...
        vertcat( grouper.indx_map{k}, grouper.last_entry);   
    grouper.indx_map_inv( grouper.last_entry,:) = ...
        [length(grouper.indx_map{k}) k];
end

lmnt_indx_corr = [];
for k2 = 1:k-1,
        lmnt_indx = grouper.indx_map{k2}...
            (grouper.input_map{k}( (find( grouper.input_map{k}(:,2) == k2)), 1));
        lmnt_indx_corr = vertcat(lmnt_indx_corr, lmnt_indx(:));
end
lmnt_indx_corr = lmnt_indx_corr(:);

%propogate unallowable combinations with inputs 
grouper.combination(grouper.last_entry, lmnt_indx_corr) = 0;
grouper.combination(lmnt_indx_corr, grouper.last_entry) = 0;
