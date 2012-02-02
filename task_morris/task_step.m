function task = task_step( task )

task.action = task.agent.action;

% restarts task when appropriate
if task.sample_ctr == 0
    task.col_pos = ceil( rand(1) * (task.col_max - task.col_min)) + ...
                            task.col_min;
    task.row_pos = ceil( rand(1) * (task.row_max - task.row_min)) + ...
                            task.row_min;
end

task.sample_ctr = task.sample_ctr + 1;

if task.sample_ctr >= task.DURATION
    task.sample_ctr = 0;
    task = task_initialize_image( task);
end

col_step = round ( ...
           task.action(1) * task.MAX_STEP_SIZE / 2 + ...
           task.action(2) * task.MAX_STEP_SIZE / 4 + ...
           task.action(3) * task.MAX_STEP_SIZE / 8 + ...
           task.action(4) * task.MAX_STEP_SIZE / 16 - ...
           task.action(5) * task.MAX_STEP_SIZE / 2 - ...
           task.action(6) * task.MAX_STEP_SIZE / 4 - ...
           task.action(7) * task.MAX_STEP_SIZE / 8 - ...
           task.action(8) * task.MAX_STEP_SIZE / 16 );

row_step = round ( ...
           task.action(9) * task.MAX_STEP_SIZE / 2 + ...
           task.action(10) * task.MAX_STEP_SIZE / 4 + ...
           task.action(11) * task.MAX_STEP_SIZE / 8 + ...
           task.action(12) * task.MAX_STEP_SIZE / 16 - ...
           task.action(13) * task.MAX_STEP_SIZE / 2 - ...
           task.action(14) * task.MAX_STEP_SIZE / 4 - ...
           task.action(15) * task.MAX_STEP_SIZE / 8 - ...
           task.action(16) * task.MAX_STEP_SIZE / 16 );

%introduces random noise into the movements with a magnitude 
% NOISE_MAG, typical
NOISE_MAG = 0.05;
col_step = round( col_step * ( 1 + 2 * NOISE_MAG * rand(1) - ...
    2 * NOISE_MAG * rand(1)));
row_step = round( row_step * ( 1 + 2 * NOISE_MAG * rand(1) - ...
    2 * NOISE_MAG * rand(1)));

task.col_pos = task.col_pos + col_step;
task.row_pos = task.row_pos + row_step;

task.border_hit = 0;
if task.row_pos > task.row_max 
    task.row_pos = task.row_max; 
    task.border_hit = task.border_hit + 1;
end
if task.row_pos < task.row_min 
    task.row_pos = task.row_min; 
    task.border_hit = task.border_hit + 1;
end
if task.col_pos > task.col_max 
    task.col_pos = task.col_max; 
    task.border_hit = task.border_hit + 1;
end
if task.col_pos < task.col_min 
    task.col_pos = task.col_min; 
    task.border_hit = task.border_hit + 1;
end

% creates sensory input vector
task.fov = task.data( ...
    task.row_pos - floor( task.fov_hgt/2): ...
    task.row_pos + floor( task.fov_hgt/2), ...
    task.col_pos - floor( task.fov_wid/2): ...
    task.col_pos + floor( task.fov_wid/2) );

task.sensory_input = zeros((task.fov_span + 2) ^ 2, 1);

for row = 1:task.fov_span + 2,
    for col = 1:task.fov_span + 2,
        task.sensory_input(row + (task.fov_span + 2) * (col - 1)) = ... 
        mean( mean( task.fov( (row - 1) * task.block_hgt + 1: row * task.block_hgt, ...
                          (col - 1) * task.block_wid + 1: col * task.block_wid )))...
                          / 256;
    end
end

% selects form of sensory data
%%%%%
% % 1. center-surround or
% task.sensory_input = (1 +  util_sigm( 10 * util_center_surround(...
%     reshape(task.sensory_input,[task.fov_span + 2 task.fov_span + 2]))))/2;
%%%%%
% 2. absolute
task.sensory_input = reshape(...
    task.sensory_input,[task.fov_span + 2 task.fov_span + 2]);
task.sensory_input = task.sensory_input(2:end-1,2:end-1);

task.sensory_input = task.sensory_input(:);
task.sensory_input = vertcat(task.sensory_input, 1 - task.sensory_input);
task.basic_feature_input = zeros(task.basic_feature_length,1);
task.reward = task_calc_reward( task);

