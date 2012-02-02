function task = task_display( task )

% figure(9)
% clf
% plot( task.row_hist, 'k.')    
% figure(10)
% clf
% plot( task.col_hist, 'k.')    

task.reward_history = [task.reward_history; task.cumulative_reward;];
figure(8)
plot(task.reward_history)
task.cumulative_reward = 0;

task_show_features(task)

if (0)
    disp('attended_feature')
    for ctr = 1: length( task.agent.attended_feature),
        indx = find( task.agent.attended_feature{ctr});
        if (~isempty( indx))
            disp([' group ' num2str(ctr) '  element ' num2str(indx)]);
        end
    end
end

%shows the cause and effect used
if (0)
    disp('cause and effect')
    max_reward_indx = task.agent.planner.max_reward_indx;
    if (~isempty( max_reward_indx))
        for k = 2:task.agent.num_groups,
            disp(['cause number ' num2str(max_reward_indx) ...
                ' for group ' num2str(k)])
            task.agent.model.cause{k}(:, max_reward_indx)
            disp('effect')
            task.agent.model.effect{k}(:, max_reward_indx)
        end
    end
end

drawnow;
