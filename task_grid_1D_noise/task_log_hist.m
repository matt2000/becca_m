function task = task_log_hist (task)

task.step_ctr = task.step_ctr + 1;
task.motor_output_hist = [task.motor_output_hist; task.action';];
task.cumulative_reward = task.cumulative_reward + task.reward;

if (mod( task.step_ctr , task.BACKUP_PERIOD) == 0)
    filename = [task.backup_filename_prefix task.backup_filename_postfix];
    save( filename, 'task')
    disp(['agent data saved at ' num2str(task.step_ctr) ' time steps'])
end

if (task.display_features_flag)
    state_img = '...';
    state_img( task.world_state) = 'O';
    disp(state_img)
end
