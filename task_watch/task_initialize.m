function task = task_initialize(task)

task.REPORTING_BLOCK_SIZE = 10 ^ 2;
task.TASK_DURATION = 10 ^ 2;
task.BACKUP_PERIOD = 10 ^ 3;
task.MAX_NUM_FEATURES = 5000;

task.step_ctr = 0;
task.sample_ctr = 0;
task.reward = 0;
task.data = [];

task.animate_flag = 0;

task.backup_filename_prefix = 'log/task_watch';
task.backup_filename_postfix = '_task.mat';

task.fov_span = 10;
task.state_length = 2 * task.fov_span^2;
task.action_length = 16;
task.basic_feature_length = 1;

% initialize image data
% load images, dropping the '.' and '..' directories
lib_dir = 'images/lib/';
filenames = dir(lib_dir);
addpath(lib_dir);
task.imgNames = filenames(3:end);
task.imgCount = length(task.imgNames);

% initialize the image to be viewed
task = task_initialize_image( task);

task.sensory_input = zeros(task.state_length, 1);
task.basic_feature_input = zeros(task.basic_feature_length, 1);

%initializes figures for display
close all
long_gray_colormap = [[0:255]' [0:255]' [0:255]']./255;
figure(2)
colormap(long_gray_colormap);
figure(4);
colormap(long_gray_colormap);
if (task.animate_flag)
    figure(6)
    colormap(long_gray_colormap);
    figure(7)
    colormap(long_gray_colormap);
end
%window positions for laptop
set(2, 'Position', [501 489 410 231])
set(4, 'Position', [931 37 340 680])
