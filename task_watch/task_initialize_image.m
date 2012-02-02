function task = task_initialize_image(task)

image_found = 0;
while ~image_found
    filename = task.imgNames( ceil( rand(1) * task.imgCount)).name;
    if length(filename) > 4
        if strmatch('.jpg', filename(end-3:end))
            image_found = 1;
        end
    end
end

task.data = imread( filename);
if (length(size(task.data)) == 3)
    task.data = sum(task.data,3) / 3;
end
task.data = cast(task.data, 'double');

FOV_FRACTION = 0.5;
task.fov_hgt = min( size(task.data,1), size(task.data,2)) * FOV_FRACTION;
task.fov_wid = task.fov_hgt;

task.col_min = ceil( task.fov_wid/2) + 1;
task.col_max = size(task.data,2) - ceil( task.fov_wid/2) - 1;
task.row_min = ceil( task.fov_hgt/2) + 1;
task.row_max = size(task.data,1) - ceil( task.fov_hgt/2) - 1;

task.block_wid = floor(task.fov_wid/ (task.fov_span + 2));
task.block_hgt = floor(task.fov_hgt/ (task.fov_span + 2));
task.MAX_STEP_SIZE = task.fov_hgt;


if (( task.block_wid < 1) || ( task.block_hgt < 1))
    task = initialize_image( task);
end
