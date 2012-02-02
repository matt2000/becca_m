% Takes in 'new_cause' and 'new_effect' 
% to train the model of the environment.

% TODO: udpate comments to reflect new representation
function model = model_train( model, new_effect, new_hist, new_cause, reward)

num_groups = length(new_cause);

% Checks to see whether the new entry is already in the library 
% TODO: make the similarity threshold a function of the count? This would
% allow often-observed transitions to require a closer fit, and populate
% the model space more densely in areas where it accumulates more
% observations.
transition_similarity = util_similarity( ...
    new_hist, model.hist, 1:model.last_entry);

% If the cause doesn't match, the transition doesn't match
cause_group = 0;
cause_feature = 0;
for k = 2:num_groups,
    if ~isempty( find( new_cause{k}, 1))
         cause_group = k;
         cause_feature = find( new_cause{k});
    end
end

match_indx = [];
if (cause_group)
    transition_similarity = transition_similarity .* ...
        model.cause{cause_group}(cause_feature, 1:model.last_entry);
    match_indx = find( transition_similarity > model.SIMILARITY_THRESHOLD);                    
end

%if context and cause are sufficiently different, 
%adds a new entry to the model library
if isempty(match_indx) 
    model.last_entry = model.last_entry + 1;
    matching_transition_indx = model.last_entry;
    for k = 2:num_groups,
        model.hist{k} (:, model.last_entry) = new_hist{k};
        model.cause{k} (:, model.last_entry) = new_cause{k};
        model.effect{k}(:, model.last_entry) = new_effect{k};
    end
    model.count(matching_transition_indx) =  1;
    current_update_rate = 1;
    
%otherwise increments a nearby entry
else                
    [sim_val, matching_transition_indx] = max( transition_similarity);
    
    model.count(matching_transition_indx) = ...
        model.count(matching_transition_indx) + 1;

    % modifies cause and effect
    % making the update rate a function of count allows updates to occur
    % more rapidly when there is little past experience to contradict them
    current_update_rate = (1 - model.UPDATE_RATE) ./ ...
        model.count(matching_transition_indx) + model.UPDATE_RATE;
    current_update_rate = min( 1, current_update_rate);
    
    for k = 2:num_groups,
        model.effect{k}(:, matching_transition_indx) = ...
            model.effect{k}(:, matching_transition_indx) * ... 
            (1 - current_update_rate) + ...
            new_effect{k} * current_update_rate;
        % TODO: update cause as well?
%         model.cause{k} (:, matching_transition_indx) = ;
    end
end

%Performs credit assignment on the trace
% updates the transition trace
model.trace_indx = [model.trace_indx(2:end) ...
    matching_transition_indx];

% updates the reward trace
model.trace_reward = [model.trace_reward(2:end) reward];

credit = model.trace_reward(1);
for i = 2:model.TRACE_LENGTH,
    credit = util_bounded_sum( credit, model.trace_reward(i) * ...
                                (1 - model.TRACE_DECAY_RATE) .^ (i - 1));
end

% updates the reward associated with the last entry in the trace
update_indx = model.trace_indx(1);
max_step_size = credit - model.reward_map( update_indx);

% % without assigning credit to the trace
% update_indx = matching_transition_indx;
% max_step_size = reward - model.reward_map( update_indx);

model.reward_map( update_indx) = ...
    model.reward_map( update_indx) + ...
    max_step_size .* current_update_rate;


%%%%%%%%%%%%%%%%%%%%%%%%%        
model.clean_count = model.clean_count + 1;

% cleans out the library
if (model.last_entry >= model.MAX_ENTRIES)
    model.clean_count = model.CLEANING_PERIOD + 1;
end
if (model.clean_count > model.CLEANING_PERIOD)

    model.count(1:model.last_entry) = model.count(...
        1:model.last_entry) - 1./model.count(1:model.last_entry) ;
    forget_indx = find (model.count(1:model.last_entry) < eps);

    for k = 2:num_groups,
        model.hist{k}  (:, forget_indx) = [];
        model.cause{k} (:, forget_indx) = [];
        model.effect{k}(:, forget_indx) = [];
    end
    model.count(forget_indx) = [];
    model.reward_map(forget_indx) = [];

    model.clean_count = 0;
    model.last_entry = model.last_entry - length(forget_indx);
    if (model.last_entry ==0) model.last_entry = 1; end

    %debug
    disp(['@model.train: Library cleaning out ' ...
        num2str(length(forget_indx)) ' entries to ' ...
        num2str(model.last_entry) ' entries.']);

end

% pads the library if it has shrunk too far
if (size(model.effect{2}, 2) < model.MAX_ENTRIES * 1.1)

    for k = 2:num_groups,
        model.hist{k}  = horzcat( model.hist{k},  ...
            zeros( size( model.effect{k}, 1), model.MAX_ENTRIES));
        model.cause{k}  = horzcat( model.cause{k},  ...
            zeros( size( model.effect{k}, 1), model.MAX_ENTRIES));
        model.effect{k} = horzcat( model.effect{k}, ...
            zeros( size( model.effect{k}, 1), model.MAX_ENTRIES));
    end
    model.count = horzcat(model.count, zeros(1, model.MAX_ENTRIES));
    model.reward_map = horzcat(...
        model.reward_map, zeros(1, model.MAX_ENTRIES));
end
