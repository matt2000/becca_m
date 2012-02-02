function integrated_state = agent_integrate_state( ...
    previous_state, new_state, decay_rate)

num_groups = length(new_state);
for k = 2:num_groups,
    integrated_state{k} = util_bounded_sum(...
        previous_state{k} * (1 - decay_rate), new_state{k});
end