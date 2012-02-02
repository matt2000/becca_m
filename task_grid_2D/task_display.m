function task = task_display (task)

task.reward_history = [task.reward_history; task.cumulative_reward;];
task.cumulative_reward = 0;

figure(2)
plot(task.reward_history)
ylabel('reward per block');
xlabel(['block number (' num2str(task.REPORTING_BLOCK_SIZE) ...
    ' time steps per block)']);
drawnow
