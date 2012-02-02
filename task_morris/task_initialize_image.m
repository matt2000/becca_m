function task = task_initialize_image(task)

filename = task.imgNames( ceil( rand(1) * task.imgCount)).name;
task.data = imread( filename);
if (length(size(task.data)) == 3)
    task.data = sum(task.data,3) / 3;
end
task.data = cast(task.data, 'double');

%task.fov_hgt = min( size(task.data,1) / 2, size(task.data,2) / 2);
task.fov_hgt = min( 9 * size(task.data,1) / 10, 9 * size(task.data,2) / 10);
%task.fov_hgt = min( size(task.data,1), size(task.data,2));
task.fov_wid = task.fov_hgt;
%task.MAX_STEP_SIZE = 2 * task.fov_wid;
task.MAX_STEP_SIZE = task.fov_wid;

% Adds a border around the image.
task.BORDER_WID = round( task.fov_wid / 2);
task.data_pad = 128 * ones( size( task.data) + 2 * task.BORDER_WID);
task.data_pad( task.BORDER_WID + (1: size( task.data,1)), ...
    task.BORDER_WID + (1: size( task.data,2))) = task.data;
task.data = task.data_pad;

task.col_min = ceil( task.fov_wid/2) + 1;
task.col_max = size(task.data,2) - ceil( task.fov_wid/2) - 1;
task.row_min = ceil( task.fov_hgt/2) + 1;
task.row_max = size(task.data,1) - ceil( task.fov_hgt/2) - 1;

task.block_wid = floor(task.fov_wid/ (task.fov_span + 2));
task.block_hgt = floor(task.fov_hgt/ (task.fov_span + 2));

% constructs the image with the target
scaled_target = util_scale_im( task.target_data, task.fov_wid);
%scaled_target = util_scale_im( task.target_data, 3 * task.fov_wid / 4);
%scaled_target = util_scale_im( task.target_data, task.fov_wid / 2);

task.TARGET_ROW = round( task.row_min + task.BORDER_WID + ...
    rand(1) * (task.row_max - task.row_min - 2 * task.BORDER_WID));
task.TARGET_COL = round( task.col_min + task.BORDER_WID + ...
    rand(1) * (task.col_max - task.col_min - 2 * task.BORDER_WID));

% hides the target image if HIDE_TARGET flag is nonzero. This is useful for
% exposing the agent to natural images, particularly at first when it is
% building groups and features.
if ~task.HIDE_TARGET
    task.data = util_paste_im( scaled_target, ...
        task.data, task.TARGET_ROW, task.TARGET_COL);
end
    
if (( task.block_wid < 1) || ( task.block_hgt < 1))
    task = task_initialize_image( task);
end

if (0)
    figure(2)
    image(task.data)
    axis equal
    drawnow
end
