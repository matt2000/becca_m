function task = task_log_hist(task)

task.step_ctr = task.step_ctr + 1;

if (mod( task.step_ctr , task.BACKUP_PERIOD) == 0)
    filename = [task.backup_filename_prefix task.backup_filename_postfix];
    save( filename, 'task')
    disp(['agent data saved at ' num2str(task.step_ctr) ' time steps'])
end


if (task.animate_flag)
    
    figure(6)
    subplot(1,3,1)
    sensed_image = reshape( task.sensory_input, ...
        task.fov_span, task.fov_span);
    %remaps [-1, 1] to [0, 4/5] for display
    sensed_image = (sensed_image+1)/2.5;
    %remaps [0, 1] to [0, 4/5] for display
    sensed_image = (sensed_image)/1.25;
    image(sensed_image * 256)
    
    subplot(1,3,2)
    image(task.fov)
    title('agent field of view')
    axis equal

    
    subplot(1,3,3)
    col_vals = 1:size(task.data,1);
    row_vals1 = ones(size(col_vals)) * ...
        (task.col_pos - floor( task.fov_wid/2));
    row_vals2 = ones(size(col_vals)) * ...
        (task.col_pos + ceil ( task.fov_wid/2));
    data_temp = task.data;
    data_temp(col_vals, row_vals1) = 0;
    data_temp(col_vals, row_vals2) = 0;
    image(data_temp)
    drawnow
end

if (length( task.agent.feature_activity) > 3)
    if (rand(1) < 0.1)
        task_show_perception( task);
    end
end
