function task = task_restore( task)

filename = [task.restore_filename_prefix task.backup_filename_postfix];
if exist(filename,  'file')
    load(filename);
    disp(['Restored ' task.dir ' to time step ' num2str(task.step_ctr) ]);
    
    task.cumulative_reward = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sets up the display. This has to be done after the restore operation in
% order to create a valid figure handle.
long_gray_colormap = [[0:255]' [0:255]' [0:255]']./255;
figure(1) 
clf
set(1, 'Position', [610 73 660 645]);

colormap(long_gray_colormap);

% makes checkerboard
row_mat = cumsum( ones(task.world_size, 1)) * ones(1, task.world_size);
col_mat = ones(task.world_size, 1) * cumsum( ones(1, task.world_size));
cb_mat = mod(row_mat + col_mat, 2);
cb_mat = cb_mat * 100;
image(cb_mat)

wid = 0.2;
target_x = [task.target_col + wid;
            task.target_col + wid;
            task.target_col - wid;
            task.target_col - wid;
            task.target_col + wid;];
target_y = [task.target_row + wid;
            task.target_row - wid;
            task.target_row - wid;
            task.target_row + wid;
            task.target_row + wid;];
task.target_patch = patch( target_x, target_y, 'g');
obstacle_x = [task.obstacle_col + wid;
            task.obstacle_col + wid;
            task.obstacle_col - wid;
            task.obstacle_col - wid;
            task.obstacle_col + wid;];
obstacle_y = [task.obstacle_row + wid;
            task.obstacle_row - wid;
            task.obstacle_row - wid;
            task.obstacle_row + wid;
            task.obstacle_row + wid;];
task.obstacle_patch = patch( obstacle_x, obstacle_y, 'r');
task.avatar_x = [1 ;
            1 + wid;
            1 ;
            1 - wid;
            1 ;];
task.avatar_y = [1 + wid;
            1 ;
            1 - wid;
            1 ;
            1 + wid;];
task.agent_patch = patch( task.avatar_x, task.avatar_y, 'b');
axis equal
hold on
xlabel('Red position is punished. Green position is rewarded.')

drawnow
