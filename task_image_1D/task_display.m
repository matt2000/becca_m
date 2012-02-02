function task = task_display(task)

figure(10)
clf
plot( task.col_hist, 'k.')    
xlabel('time step')
ylabel('position (pixels)')

task.reward_history = [task.reward_history; task.cumulative_reward;];
figure(8)
plot(task.reward_history)
xlabel(['block number (' num2str(task.REPORTING_BLOCK_SIZE) ...
    ' time steps per block)'])
ylabel('reward for the block')

task.cumulative_reward = 0;

task_show_features(task)
drawnow;
