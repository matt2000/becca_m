function task = restore( task )

filename = [task.restore_filename_prefix task.backup_filename_postfix];
if exist(filename,  'file')
    load(filename);
    disp(['Restored ' task.dir ' to time step ' num2str(task.step_ctr) ]);
    
    task.cumulative_reward = 0;
end
