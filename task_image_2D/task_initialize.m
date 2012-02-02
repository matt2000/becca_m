function task = task_initialize( task)

task.BACKUP_PERIOD = 10 ^ 3;
task.REPORTING_BLOCK_SIZE = 10 ^ 2;
task.SHOW_PERCEPTION_FRAC = 0; %.1;
task.MAX_NUM_FEATURES = 1000;

task.sensory_input = [];
task.basic_feature_input = [];
task.action = [];

task.step_ctr = 0;
task.sample_ctr = 0;
task.reward = 0;
task.reward_history = [];

task.cumulative_reward = 0;
task.animate_flag = 0;
task.col_hist = [];
task.row_hist = [];
%task.restore_filename_prefix = 'log/task_watch';
task.restore_filename_prefix = 'log/task_image_2D';
task.backup_filename_prefix = 'log/task_image_2D';
task.backup_filename_postfix = '.mat';

% initializes the image to be used as the environment
filename = './images/block2.jpg'; 
%filename = './images/circle.jpg'; 
%filename = './images/box.jpg'; 
%filename = '.\images\lib_small\006_0067.jpg';

task.fov_span = 10;
task.state_length = 2 * task.fov_span^2;
task.action_length = 16;
task.basic_feature_length = 1;

task.data = imread( filename );
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

task.col_pos = ceil( rand(1) * (task.col_max - task.col_min)) + ...
                        task.col_min;
task.row_pos = ceil( rand(1) * (task.row_max - task.row_min)) + ...
                        task.row_min;

%debug                    
task.block_wid = floor(task.fov_wid/ task.fov_span);
task.block_hgt = floor(task.fov_hgt/ task.fov_span);
% task.block_wid = floor(task.fov_wid/ (task.fov_span + 2));
% task.block_hgt = floor(task.fov_hgt/ (task.fov_span + 2));

task.MAX_STEP_SIZE = task.fov_hgt;
task.TARGET_ROW = size( task.data, 1) / 2;
task.TARGET_COL = size( task.data, 2) / 2;

task.sensory_input = zeros(task.state_length, 1);
task.basic_feature_input = zeros(task.basic_feature_length, 1);

% disable warnings in Octave for divide by zero
% uncomment for use in Octave
%warning ('off', 'Octave:divide-by-zero');

%initializes figures for display
close all
long_gray_colormap = [[0:255]' [0:255]' [0:255]']./255;
figure(2)
colormap(long_gray_colormap);
task.h4 = figure(4);
colormap(long_gray_colormap);
if (task.animate_flag)
    figure(6)
    colormap(long_gray_colormap);
    figure(7)
    colormap(long_gray_colormap);
end
figure(8)
figure(9)
figure(10)
%window positions for laptop
set(2, 'Position', [9 439 1270 280])
set(4, 'Position', [931 37 340 680])
set(8, 'Position', [501 489 410 231])
set(9, 'Position', [8 470 484 250])
set(10, 'Position', [9 146 484 240])
