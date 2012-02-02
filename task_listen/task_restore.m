function task = task_restore( task)

filename = [task.restore_filename_prefix task.backup_filename_postfix];
if exist(filename,  'file')
    % restores variables
    load(filename);
    disp(['Restored task_watch to time step ' num2str(task.step_ctr) ]);
    
    % wipes world model clean
    %task.agent.model.last_entry = 1;
    
end
