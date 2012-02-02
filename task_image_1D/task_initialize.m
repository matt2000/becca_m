function task = task_initialize(task)

task.REPORTING_BLOCK_SIZE = 10 ^ 2;
task.BACKUP_PERIOD = 10 ^ 3;
task.fov_span = 10;
task.state_length = 2 * task.fov_span^2;
task.action_length = 16;
task.basic_feature_length = 1;

task.sensory_input = [];
task.basic_feature_input = [];
task.action = [];

task.step_ctr = 0;
task.reward = 0;
task.reward_history = [];
task.data = [];

task.cumulative_reward = 0;
task.animate_flag = 0;
task.col_hist = [];
%task.backup_filename_prefix = 'log/task_watch_5';
task.backup_filename_prefix = 'log/task_image_1D';
task.backup_filename_postfix = '.mat';


% initializes the image to be used as the environment
filename = './images/bar_test.jpg'; 

task.data = imread( filename );
if (length(size(task.data)) == 3)
    task.data = sum(task.data,3) / 3;
end

task.data = cast(task.data, 'double');

task.MAX_STEP_SIZE = size( task.data, 2) / 2;
task.TARGET_COL = size( task.data, 2) / 2;

task.fov_hgt = size(task.data,1);
task.fov_wid = size(task.data,1);
task.col_min = ceil( task.fov_wid/2) + 1;
task.col_max = size(task.data,2) - ceil( task.fov_wid/2) - 1;
task.col_pos = ceil( rand(1) * (task.col_max - task.col_min)) + task.col_min;

task.block_wid = floor(task.fov_wid/ task.fov_span);

task.sensory_input = zeros(task.state_length, 1);
task.basic_feature_input = zeros(task.basic_feature_length, 1);

%initializes figures for display
close all
long_gray_colormap = [[0:255]' [0:255]' [0:255]']./255;
figure(1)
colormap(long_gray_colormap);
figure(4);
colormap(long_gray_colormap);
if (task.animate_flag)
    figure(6)
    colormap(long_gray_colormap);
    figure(7)
    colormap(long_gray_colormap);
end
figure(8)
figure(10)
%window positions for laptop
set(1, 'Position', [1047 38 226 195])
set(4, 'Position', [931 37 340 680])
set(8, 'Position', [9 530 907 189])
set(10, 'Position', [9 193 907 248])
