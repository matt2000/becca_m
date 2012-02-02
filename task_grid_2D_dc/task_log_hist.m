function task = task_log_hist (task)

task.step_ctr = task.step_ctr + 1;
task.motor_output_hist = [task.motor_output_hist; task.action';];
task.cumulative_reward = task.cumulative_reward + task.reward;

%debug
% if ~isempty( find( task.simple_state ~= 4))
%     disp('-----------------------------not rewarded---');
%     task.simple_state
% end
% find(task.action)

if (mod( task.step_ctr , task.BACKUP_PERIOD) == 0)
    filename = [task.backup_filename_prefix task.backup_filename_postfix];
    save( filename, 'task')
    disp(['agent data saved at ' num2str(task.step_ctr) ' time steps'])
end

if (task.animate_flag)
    new_avatar_x = task.avatar_x - 1 + task.simple_state(2);
    new_avatar_y = task.avatar_y - 1 + task.simple_state(1);
    set(task.agent_patch, 'XData', new_avatar_x, 'YData', new_avatar_y);
    drawnow
end
    