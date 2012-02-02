function agent = agent_attend( agent)
% Selects a feature from feature_activity to attend to.

agent.SALIENCE_NOISE = 0.1;

max_salience_val = 0;
max_salience_group = 1;
max_salience_indx = 1;

% salience is a combination of feature activity magnitude, goal magnitude,
% and a small amount of noise
for k = 1:length( agent.feature_activity),
    agent.attended_feature{k} = zeros( size( agent.feature_activity{k}));
    
    salience{k} = agent.SALIENCE_NOISE .* ...
        rand( size( agent.feature_activity{k}));
    salience{k} = salience{k} + agent.feature_activity{k} .* ...
        (1 + agent.goal{k});

    % Picks the feature with the greatest salience.
    [max_val max_indx] = max( salience{k});

    if (max_val >= max_salience_val)
        max_salience_val = max_val;
        max_salience_group = k;
        max_salience_indx = max_indx;
    end
    
    if agent.planner.act_flag
        deliberate_action_indx = find( agent.planner.action);
        if ~isempty( deliberate_action_indx)

            %ensures that exploratory actions will be attended
            max_salience_val = 10;
            max_salience_group = 3;
            max_salience_indx = deliberate_action_indx;
        end
        agent.planner.explore_flag = 0;
    end
end

% debug
if (agent.debug_flag == 1)
    disp(['attended--group:' num2str(max_salience_group) ', feature:' ...
        num2str(max_salience_indx) ', value:' num2str(max_salience_val)])
end

agent.attended_feature{max_salience_group}(max_salience_indx) = 1;
