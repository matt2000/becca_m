function task = task_display (task)

task.reward_history = [task.reward_history; task.cumulative_reward;];
task.cumulative_reward = 0;
plot(task.reward_history)
drawnow

end