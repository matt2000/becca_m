function task = task_log_hist(task)

task.step_ctr = task.step_ctr + 1;

if (mod( task.step_ctr , task.BACKUP_PERIOD) == 0)
    filename = [task.backup_filename_prefix task.backup_filename_postfix];    
    save( filename, 'task')    
    disp(['agent data saved at ' num2str(task.step_ctr) ' time steps'])
end
