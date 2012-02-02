function agent = agent_display( agent )
%display internal aspects of BECCA's operation

% TODO: Add model feedback

VARS = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displays basic_feature_input
if(1)
    disp('---basic feature input---');
    agent.basic_feature_input
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displays sensory_input
if(1)
    disp('---sensory input---');
    agent.sensory_input
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displays reward
if(1)
    disp('---reward---');
    agent.reward
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displays action
if(1)
    figure(72);
    bar(agent.action);
    axis ([0 length(agent.action)+1 0 1])
    title('action commanded')
end

figure(71);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displays previous_feature_activity
if(1)
    this_var = 1;
    for k = 2:agent.num_groups,
        subplot(agent.num_groups-1, VARS, VARS * (k-2) + this_var)
        bar(agent.previous_feature_activity{k})
        axis ([0 length(agent.previous_feature_activity{k})+1 0 1])
 %       ylabel(['grp ' num2str(k) ])
        if (k == 2)
            title('previous feature activity');
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displays feature_activity
if(1)
    this_var = 2;
    for k = 2:agent.num_groups,
        subplot(agent.num_groups-1, VARS, VARS * (k-2) + this_var)
        bar(agent.feature_activity{k})
        axis ([0 length(agent.feature_activity{k})+1 0 1])
 %       ylabel(['grp ' num2str(k) ])
        if (k == 2)
            title('feature activity');
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displays predicted_features
if(0)
    this_var = 5;
    for k = 2:agent.num_groups,
        subplot(agent.num_groups-1, VARS, VARS * (k-2) + this_var)
        bar(sum(agent.predicted_features{k}, 2)/agent.model.last_entry)
        axis ([0 length(agent.predicted_features{k})+1 0 1])
%        ylabel(['grp ' num2str(k) ])
        if (k == 2)
            title('predicted features');
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displays plan
if(0)
    this_var = 6;
    for k = 2:agent.num_groups,
        subplot(agent.num_groups-1, VARS, VARS * (k-2) + this_var)
        bar(agent.planner.plan{k})
        axis ([0 length(agent.planner.plan{k})+1 0 1])
 %       ylabel(['grp ' num2str(k) ])
        if (k == 2)
            title('planner.plan');
        end
    end
end

%agent.model.display_n_best(10);

pause