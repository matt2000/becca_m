function [agent feature_vote] = ...
                agent_add_feature(agent, new_feature, k, feature_vote)

has_dummy = (norm (agent.feature_map.map{k} (1,:)) == 0);
agent.feature_added = 1;

feature_vote{k} = [feature_vote{k}; 0;];
agent.feature_stimulation{k} = [agent.feature_stimulation{k}; 0;];
agent.feature_activity{k} = [agent.feature_activity{k}; 0;];
agent.working_memory{k} = [agent.working_memory{k}; 0;];
agent.previous_working_memory{k} = [agent.previous_working_memory{k}; 0;];
agent.attended_feature{k} = [agent.attended_feature{k}; 0;];
agent.goal{k} = [agent.goal{k}; 0;];

% if dummy feature is still in place, removes it
if (has_dummy)

    feature_vote{k}         = feature_vote{ k}( 2:end);
    agent.feature_stimulation{k} = agent.feature_stimulation{ k}( 2:end);
    agent.feature_activity{k} = agent.feature_activity{ k}( 2:end);
    agent.working_memory{k} = agent.working_memory{ k}( 2:end);
    agent.previous_working_memory{k} = ...
        agent.previous_working_memory{ k}( 2:end);
    agent.attended_feature{k} = agent.attended_feature{ k}( 2:end);
    agent.goal{k} = agent.goal{ k}( 2:end);
end

agent.grouper     = grouper_add_feature( ...
                    agent.grouper, k, has_dummy);
agent.feature_map = feature_map_add_feature( ...
                    agent.feature_map, k, has_dummy, new_feature);
agent.model       = model_add_feature( ...
                    agent.model, k, has_dummy);
% agent.planner     = planner_add_feature( ...
%                     agent.planner, k, has_dummy);
       