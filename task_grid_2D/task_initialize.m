function task = task_initialize (task)

task.REPORTING_BLOCK_SIZE = 10 ^ 3;
task.BACKUP_PERIOD = 10 ^ 3;

task.ENERGY_PENALTY = 0.05;

task.world_size = 5;
task.world_state = [1 1]';
task.simple_state = [1 1]';
task.cumulative_reward = 0;
task.reward_history = [];
task.motor_output_hist = [];

% sets number of channels for interfacing with agent 
task.state_length = 1;
task.action_length = 9;
task.basic_feature_length = task.world_size .^2;

% defines positions of target and obstacle
task.target_row = 4;
task.target_col = 4;
task.obstacle_row = 2;
task.obstacle_col = 2;

task.animate_flag = 0;        
task.step_ctr = 0;
task.sensory_input = 0;
task.basic_feature_input = [];
task.action = [];
task.reward = [];

task.restore_filename_prefix = 'log/task_grid_2D';
task.backup_filename_prefix = 'log/task_grid_2D';
task.backup_filename_postfix = '.mat';

close all
figure(2)
clf
set(2, 'Position', [8 334 587 385]);
hold on
xlabel(['block (' num2str(task.REPORTING_BLOCK_SIZE) ...
    ' time steps per block)'])
ylabel('reward per block')

