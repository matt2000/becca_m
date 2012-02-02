function agent = agent_update_feature_map( agent, grouped_input)

agent.feature_added = 0;
num_groups = length(grouped_input);
for k = 2:num_groups,
    
    if (norm (agent.feature_map.map{k} (1,:)) == 0)        
        margin = 1;
    else
        
        similarity_vals = util_similarity( grouped_input{k}, ...
            agent.feature_map.map{k}', ...
            1:size(agent.feature_map.map{k}', 2) );
        margin = 1 - max( similarity_vals);
    end
    
    % initializes feature_vote for basic features.
    if (k  == 2)
        feature_vote{k} = grouped_input{k};
        margin = 0;
    end
    % initializes feature_vote for basic motor actions.  
    if (k  == 3)
        % makes these all zero
        % actions, even automatic ones, don't originate in this way. 
        feature_vote{k} = zeros(size(grouped_input{k}));
        margin = 0;
    end
    
    % Calculates the feature votes for all feature in group 'k'.
    if (k > 3)
        if (size( agent.feature_map.map{k}, 1) > 0)

            % This formulation of voting was chosen to have the
            % property that if the group's contributing inputs are are 1,
            % it will result in a feature vote of 1.
            feature_vote{k} = sqrt( ...
                (agent.feature_map.map{k}.^2) * grouped_input{k});            
        end
    end
    
    if (( margin > agent.feature_map.NEW_FEATURE_MARGIN) && ...
         (norm( grouped_input{k}) > ...
         agent.feature_map.NEW_FEATURE_MIN_SIZE) && ...
         agent.grouper.features_full == 0 )
        
        % This formulation of feature creation was chosen to have 
        % the property that all feature magnitudes are 1. In other words, 
        % every feature is a unit vector in the vector space formed by its 
        % group.
        new_feature = grouped_input{k} / norm( grouped_input{k});    
        [agent feature_vote] = ...
            agent_add_feature(agent, new_feature, k, feature_vote);        
    end
end

% TODO: boost winner up closer to 1? This might help numerically propogate 
% high-level feature activity strength. Otherwise it might attentuate and 
% disappear for all but the strongest inputs. See related TODO note at end
% of grouper_step.
agent.feature_activity = util_wta(feature_vote);
