% A general reinforcement learning agent, modeled on human neurophysiology 
% and performance.  Takes in a time series of 
% sensory input vectors and a scalar reward and puts out a time series 
% of motor commands.  
% New features are created as necessary to adequately represent the data.

function agent = agent_step( agent, ...
    sensory_input, basic_feature_input, reward)

agent.step_ctr = agent.step_ctr + 1;

agent.sensory_input = sensory_input;
agent.basic_feature_input = basic_feature_input;

% looks only at the *change* in reward as reward
agent.reward = reward;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature creator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Breaks inputs into groups and creates new feature groups when warranted.
% [agent.grouper grouped_input group_added] = ...
%     grouper_step( agent.grouper, agent.sensory_input, ...
%     agent.basic_feature_input, agent.feature_activity);
% TODO: add actions to sensed features
[agent.grouper grouped_input group_added] = ...
    grouper_step( agent.grouper, agent.sensory_input, ...
    agent.basic_feature_input, agent.action, agent.feature_activity);
if (group_added)
    agent = agent_add_group( agent, ...
        length( grouped_input{ length( grouped_input)})); 
end

% Interprets inputs as features and updates feature map when appropriate.
% Assigns agent.feature_activity.
agent = agent_update_feature_map( agent, grouped_input);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reinforcement learner
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
agent.previous_attended_feature = agent.attended_feature;
% Attends to a single feature. Updates agent.attended_feature.
agent = agent_attend( agent);

% Performs leaky integration on attended feature to get 
% working memory.
agent.pre_previous_working_memory = agent.previous_working_memory;
agent.previous_working_memory = agent.working_memory;
agent.working_memory = agent_integrate_state( ...
    agent.previous_working_memory, agent.attended_feature, ...
    agent.WORKING_MEMORY_DECAY_RATE);

% associates the reward with each transition
% agent.model = model_train(agent.model, agent.feature_activity, ...
%                             agent.previous_working_memory, ...
%                             agent.reward);
agent.model = model_train(agent.model, agent.feature_activity, ...
                            agent.pre_previous_working_memory, ...
                            agent.previous_attended_feature, ...
                            agent.reward);

% Reactively chooses an action.
% TODO: make reactive actions habit based, not reward based
% also make reactive actions general
% reactive_action = planner_select_action( ...
%         agent.model, agent.feature_activity);

% only acts deliberately on a fraction of the time steps
if rand(1) > agent.planner.OBSERVATION_FRACTION
    % occasionally explores when making a deliberate action.
    % Sets agent.planner.action
    if rand(1) < agent.planner.EXPLORATION_FRACTION
        if (agent.debug_flag)
            disp('EXPLORING')
        end
        agent.planner = planner_explore(agent.planner);
    else
        if (agent.debug_flag)
            disp('DELIBERATING')
        end
        % Deliberately choose features as goals, in addition to actions.
        agent = planner_deliberate( agent);  
    end
else
    agent.planner.action = zeros( size( agent.planner.action));
end

% DEBUG
% agent.action = util_bounded_sum( reactive_action, agent.planner.action);
agent.action = agent.planner.action;

% %debug
% disp('========================')
% disp('wm:');
% agent.working_memory{2}'
% disp('fa:');
% agent.feature_activity{2}'
% disp('ra:');
% reactive_action'
% disp('da:');
% agent.planner.action'
% disp('aa:');
% agent.action'

