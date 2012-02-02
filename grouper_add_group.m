function grouper = grouper_add_group(grouper)

num_groups = length( grouper.previous_input);

grouper.previous_input{ num_groups + 1} = zeros(1);
