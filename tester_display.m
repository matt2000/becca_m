
% periodically provides updates to the user on the status of the task 
if (mod( task.step_ctr + 1 , task.REPORTING_BLOCK_SIZE) == 0)
    c = fix( clock);
    disp(['time step '  num2str(task.step_ctr + 1) ...
        ', ' num2str(task.agent.num_groups) ' groups, at ' ...
        num2str(c(4), '%02d') ':' num2str(c(5), '%02d') ...
        ':' num2str(c(6), '%02d') ])    
    
    task = task_display( task);
end

% updates the task history log
task = task_log_hist( task);  

