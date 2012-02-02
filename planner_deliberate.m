function agent = planner_deliberate( agent)
% Deliberates, choosing goals based on the current working memory.
% It finds the transition that is best suited based on:
%   1) similarity
%   2) count
%   3) expected reward
%   4) not already having a strong goal that matches the cause
% It chooses cause of the winning transition as the goal for the timestep.

model = agent.model;

% decays goals both by a fixed fraction and by the amount that the feature
% is currently active. Experiencing a goal feature causes the goal to be
% achieved, and the passage of time allows the goal value to fade.
for k = 1: agent.num_groups,
    agent.goal{k} = agent.goal{k} .* (1 - agent.feature_activity{k});
    agent.goal{k} = agent.goal{k} .* (1 - agent.GOAL_DECAY_RATE);
end

% Calculates the value associated with each effect
goal_value = zeros( 1, model.last_entry);
for k = 2:agent.num_groups,
    goal_value = goal_value + ...
        sum( agent.model.effect{k}(:, 1:model.last_entry) .* ...
        (agent.goal{k} * ones( 1, model.last_entry)), 1);
end

% Sets maximum goal value to 1.
goal_value = min( goal_value, 1);
reward_value = model.reward_map( 1:model.last_entry) - agent.reward;

% Combines goal-based and reward-based value, bounded by one.
% The result is a value for each transition
value = util_bounded_sum(goal_value, reward_value);

% Each transition's count and its similarity to the working memory also
% factor in to its vote
count_weight = util_sigm( log( model.count( 1:model.last_entry) + 1) / 3);

similarity = util_similarity( ...
    agent.working_memory, model.hist, 1:model.last_entry);

% TODO: Raise similarity by some power to focus on more similar transitions?

% TODO: Introduce the notion of reliability? That is, when a transition is
% used for planning, whether the intended plan is executed?

% TODO: Address the lottery problem? (Reliability is one possible solution)
% This is the problem in which less common, but rewarding, transitions are
% selected over more common transitions. The distinguishing factor should
% not be the count, but the reliability of the transition. Fixing the
% lottery problem may make BECCA less human-trainable.

% TODO: Add recency? This is likely to be useful when rewards change over
% time. 

% Scales the vote by the distance between the cause and any current goals
goal_dist = zeros( 1, model.last_entry);
for k = 2:agent.num_groups,
    goal_dist_group = max (model.cause{k}(:,1:model.last_entry) - ...
        agent.goal{k} * ones( 1, model.last_entry));
    goal_dist = max( goal_dist, goal_dist_group);
end

% %%% DEBUG
% % Scales the vote by the distance between the cause and any currently
% % active features
% feature_dist = zeros( 1, model.last_entry);
% for k = 2:agent.num_groups,
% %     feature_dist_group = max (model.cause{k}(:,1:model.last_entry) - ...
% %         agent.feature_activity{k} * ones( 1, model.last_entry));
%     feature_dist_group = max (model.cause{k}(:,1:model.last_entry) - ...
%         agent.attended_feature{k} * ones( 1, model.last_entry));
%     feature_dist = max( feature_dist, feature_dist_group);
% end
% %%%

% DEBUG
transition_vote = value .* similarity .* goal_dist.^4;
% transition_vote = count_weight .* value .* similarity .* goal_dist.^4;
% transition_vote = count_weight .* value .* similarity .* goal_dist.^4 ...
%     .* feature_dist.^4;
[max_transition_vote max_transition_indx] = max(transition_vote);


if (max_transition_vote > 0)
    for k = 2:agent.num_groups,
        if ~isempty( find ...
                (agent.model.cause{k}(:, max_transition_indx), 1));
            max_goal_feature = find ...
                (agent.model.cause{k}(:, max_transition_indx));
            max_goal_group = k;
            agent.goal{max_goal_group}(max_goal_feature) = ...
                util_bounded_sum( ...
                agent.goal{max_goal_group}(max_goal_feature), ...
                value(max_transition_indx) * agent.STEP_DISCOUNT); 

            if (agent.debug_flag == 1)
%                 max_goal_group
%                 max_goal_feature
%                 agent.goal{max_goal_group}'
%                 keyboard
            end

        end
    end
end

% primitive action goals can be fulfilled immediately
agent.planner.action = zeros( size( agent.planner.action));
if ~isempty (agent.goal{3} > 0)
    agent.planner.act_flag = 1;

    agent.planner.action( agent.goal{3} > 0) = 1;
    agent.goal{3} = zeros( size( agent.goal{3}));
end