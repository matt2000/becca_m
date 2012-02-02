function action = planner_select_action( model, current_state)
% Chooses a deliberative action based on the current feature activities.
% Finds the weighted expected reward for the actions across all model 
% entries. Then executes the actions with a magnitude that is a function 
% of the expected reward associated with each.
%
% It's a low-level all-to-all planner, capable of executing many plans in
% parallel. Even conflicting ones.

% When goals are implemented, combine the reward value 
% associated with each model
% entry with the goal value associated with it.
effect_values = model.reward_map( 1:model.last_entry);

% Create a shorthand for the variables to keep the code readable.
model_actions = model.cause{3}(:, 1:model.last_entry);
count_weight = log( model.count( 1:model.last_entry) + 1);
value = effect_values;
similarity = util_similarity( ...
    current_state, model.cause, 1:model.last_entry);

% The reactive action is a weighted average of all actions. Actions 
% that are expected to result in a high value state and actions that are
% similar to the current state are weighted more heavily. All actions 
% computed in this way will be <= 1.
weights = count_weight .* value .* similarity;

% debug
% Picks closest weight only.
max_indx = find( weights == max( weights));
max_indx = max_indx( ceil( rand( length( max_indx))));

weights = zeros( size( weights));
weights( max_indx) = 1;

w_pos = weights > 0;
w_neg = weights < 0;

sizer = ones( size(  model_actions(:,1)));
weight_mat = sizer * weights; 
action_pos = ...
    sum( model_actions( :,w_pos) .* weight_mat( :,w_pos), 2) ./ ...
            (sum( weight_mat( :,w_pos), 2) + eps);
action_neg = ...
    sum( model_actions( :,w_neg) .* weight_mat( :,w_neg), 2) ./ ...
            (sum( weight_mat( :,w_neg), 2) + eps);

action = action_pos - action_neg;

% Sets a floor for action magnitudes. Negative actions are not defined.
action( action < 0) = 0;
