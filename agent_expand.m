function this_feature = agent_expand(agent, this_feature)

% Expands higher-level features into basic features and raw sensory inputs.
% This allows the feature to be expressed in terms of the sensory
% information that activates it. It is conceptually similar to the retinal
% receptive fields for neurons in V1.
%
% The input variable 'this_feature' is the feature or feature set to be
% expanded. If this_feature has only one non-zero element in all its
% groups, then the expanded feature represents the receptive field for that
% feature. If it has multiple non-zero elements, for instance, all the
% active features at one point in time, then the expanded feature
% represents the collective perception BECCA has of its environment at that
% time.

% Expands any active features, group by group, starting at the
% highest-numbered group and counting down. 
% Features from higher numbered groups always expand into lower numbered
% groups. Counting down allows for a cascading expansion of high-level
% features into their lower level component parts, until they are
% completely broken down into raw sensory and basic feature inputs.
% 'k' is a group counter variable.
for k = length(this_feature):-1:4,

    % Checks whether there are any nonzero elements in 'this_feature{k}' 
    % that need to be expanded.
    if (~isempty( find( this_feature{k})))
    
        % Finds contributions of all lower groups to the current group,
        % again counting down to allow for cascading downward projections.
        % 'kp' is a group counter variable, specific to propogating 
        % downward projections.
        for kp = k-1:-1:1,
            relevant_input_map_elements = ...
                find( agent.grouper.input_map{k}(:,2) == kp);
            relevant_inputs = agent.grouper.input_map{k}...
                (relevant_input_map_elements,1);

            % Checks whether there are any relevant inputs to project back
            % to group 'kp'
            if (~isempty( relevant_inputs))
            
                % Expands each feature element of group 'k' down to 
                % the lower level features that it consists of.
                % 'f' is a counter variable for the features within group
                % 'k'
                for f = 1:size( this_feature{k}, 1)
                    
                    % Checks whether the current feature 'f' in group 'k' 
                    % is nonzero.
                    if (this_feature{k}(f) ~= 0)
                        
                        % Translates the feature element to its separate
                        % lower level input elements one by one.

                        % 'propogation_strength' is the amount that
                        % each element in the feature map contributes
                        % to the feature being expanded. The square
                        % root is included to offset the squaring that
                        % occurs during the upward voting process. (See
                        % agent_update_feature_map.m) 
                        propogation_strength = ...
                            sqrt( agent.feature_map.map{k} ...
                            ( f, relevant_input_map_elements)');

                        % 'propogated_activation' is the propogation
                        % strength scaled by the activity of the
                        % high-level feature being expanded.
                        propogated_activation = ...
                             propogation_strength * this_feature{k}(f);

                        % The lower-level feature is incremented 
                        % according to the 'propogated_activation'. The
                        % incrementing is done nonlinearly to ensure
                        % that the activity of the lower level features
                        % never exceeds 1.
                        this_feature{kp}( relevant_inputs) = ...
                            util_bounded_sum(...
                            this_feature{kp}( relevant_inputs), ...
                            propogated_activation);
                    end
                end
            end
        end
        
        %eliminates the original representation of the feature,
        %now that it is expressed in terms of lower level features
        this_feature{k} = zeros( size( this_feature{k}));
    end
end