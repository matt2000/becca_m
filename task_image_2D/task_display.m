function task = task_display(task)

figure(9)
clf
plot( task.row_hist, 'k.')    
ylabel('vertical position (pixels)')
xlabel('time step')
figure(10)
clf
plot( task.col_hist, 'k.')    
ylabel('horizontal position (pixels)')
xlabel('time step')

task.reward_history = [task.reward_history; task.cumulative_reward;];
figure(8)
plot(task.reward_history)
task.cumulative_reward = 0;
xlabel(['block number (' num2str(task.REPORTING_BLOCK_SIZE) ...
    ' time steps per block)'])
ylabel('reward for the block')
task_show_features( task);
%agent_display;
drawnow;
