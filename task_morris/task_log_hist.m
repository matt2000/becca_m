function task = task_log_hist( task)

task.row_hist = [task.row_hist; task.row_pos;];
task.col_hist = [task.col_hist; task.col_pos;];
task.cumulative_reward = task.cumulative_reward + task.reward;

task.step_ctr = task.step_ctr + 1;

if (mod( task.step_ctr , task.BACKUP_PERIOD) == 0)
    filename = [task.backup_filename_prefix task.backup_filename_postfix];
    save( filename, 'task')
    disp(['agent data saved at ' num2str(task.step_ctr) ' time steps'])
end

if rand(1) < task.SHOW_PERCEPTION_FRAC
    task_show_perception(task);
end
