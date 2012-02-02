function agent = agent_initialize(state_length, ...
                            basic_feature_length, ...
                            action_length, MAX_NUM_FEATURES)

agent.state_length = state_length;
agent.basic_feature_length = basic_feature_length;
agent.action_length = action_length;

agent.sensory_input = [];
agent.basic_feature_input = [];
agent.reward = 0;

agent.GOAL_DECAY_RATE = 0.05;   % real, 0 < x <= 1
agent.STEP_DISCOUNT = 0.5;      % real, 0 < x <= 1

% Rates at which the feature activity and working memory decay.
% Setting these equal to 1 is the equivalent of making the Markovian 
% assumption about the task--that all relevant information is captured 
% adequately in the current state.
agent.WORKING_MEMORY_DECAY_RATE = 0.4;      % real, 0 < x <= 1
% also check out agent.grouper.INPUT_DECAY_RATE, set in grouper_initialize

agent.grouper = grouper_initialize( state_length, ...
            action_length, basic_feature_length, MAX_NUM_FEATURES);
agent.feature_map = feature_map_initialize( state_length, ...
            basic_feature_length, action_length);
agent.model = model_initialize( basic_feature_length, action_length);
agent.planner = planner_initialize( action_length);
                            
agent.step_ctr = 0;
agent.num_groups = 3;
agent.feature_added = [];        
agent.debug_flag = 0;

%initializes random number generator
RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));

% The first group is dedicated to raw sensor information. None of it is
% passed on directly as features. It must be correlated and combined before
% it can emerge as part of a feature. As a result, most of the variables
% associated with this group are empty
agent.feature_activity{1}= [];

% The second group is dedicated to basic features.
agent.feature_activity{2}= zeros( agent.basic_feature_length, 1);

% The third group is dedicated to basic actions.
agent.feature_activity{3}= zeros( agent.action_length, 1);

% Initializes other variables containing the full feature information.
agent.attended_feature = agent.feature_activity;
agent.working_memory = agent.feature_activity;
agent.previous_working_memory = agent.feature_activity;
agent.goal = agent.feature_activity;

agent.action = zeros( agent.action_length, 1);
