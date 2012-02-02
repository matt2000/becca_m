function agent = agent_add_group(agent, group_length)

% adds a new group to the agent
agent.num_groups = agent.num_groups + 1;
agent.feature_stimulation{agent.num_groups} = zeros(1);
agent.feature_activity{agent.num_groups} = zeros(1);
agent.working_memory{agent.num_groups} = zeros(1);
agent.previous_working_memory{agent.num_groups} = zeros(1);
agent.attended_feature{agent.num_groups} = zeros(1);
agent.goal{agent.num_groups} = zeros(1);

agent.feature_map = feature_map_add_group( agent.feature_map, ...
    group_length);
agent.grouper = grouper_add_group( agent.grouper);
agent.model = model_add_group( agent.model);
% agent.planner = planner_add_group( agent.planner);
