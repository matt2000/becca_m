function task = task_initialize( task)

task.REPORTING_BLOCK_SIZE = 10 ^ 2;
task.DURATION = 10 ^ 2;
task.BACKUP_PERIOD = 10 ^ 3;
task.SHOW_PERCEPTION_FRAC = 0.01;
task.HIDE_TARGET = 1;
task.MAX_NUM_FEATURES = 700;
task.agent = [];

task.step_ctr = 0;
task.sample_ctr = 0;
task.reward = 0;
task.border_hit = 0;
task.reward_history = [];

task.cumulative_reward = 0;
task.animate_flag = 0;
task.col_hist = [];
task.row_hist = [];

task.restore_filename_prefix = 'log/task_morris';
task.backup_filename_prefix = 'log/task_morris';
task.backup_filename_postfix = '_task.mat';

%task.fov_span = 10;
task.fov_span = 6;
task.state_length = 2 * task.fov_span^2;
task.action_length = 16;
task.basic_feature_length = 1;

% Initializes image data.
% Loads images, dropping the '.' and '..' directories.
lib_dir = 'images/lib/';
%lib_dir = 'images/lib_small/';
filenames = dir(lib_dir);
addpath(lib_dir);
task.imgNames = filenames(3:end);
task.imgCount = length(task.imgNames);

%debug
%start with a bigger, higher contrast target
filename = './images/block2.jpg'; 
%filename = '.\images\snickers\snickers_straight.jpg'; 
task.target_data = imread( filename);
if (length(size(task.target_data)) == 3)
    task.target_data = sum(task.target_data,3) / 3;
end

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
figure(8)
% figure(9)
% figure(10)
%window positions for laptop
set(2, 'Position', [2 452 1271 271])
set(4, 'Position', [931 37 340 680])
set(8, 'Position', [7 215 434 145])
% set(9, 'Position', [8 470 484 250])
% set(10, 'Position', [9 146 484 240])

