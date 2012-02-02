function task = task_initialize( task)

task.REPORTING_BLOCK_SIZE = 10 ^ 3;
task.BACKUP_PERIOD = 10 ^ 3;

task.state_length = 1;
% DEBUG
% task.action_length = 6;
task.action_length = 9;
task.basic_feature_length = 9;

task.sensory_input = 0;
task.basic_feature_input = [];
task.action = [];
task.reward = [];

task.simple_state = [];
task.world_state = 1;

task.cumulative_reward = 0;
task.reward_history = [];
task.motor_output_hist = [];

task.step_ctr = 0;
task.display_features_flag = 1;

task.restore_filename_prefix = 'log/task_grid_1D';
task.backup_filename_prefix = 'log/task_grid_1D';
task.backup_filename_postfix = '.mat';

close all
figure(1) 
clf
hold on
xlabel(['block (' num2str(task.REPORTING_BLOCK_SIZE) ...
    ' time steps per block)']);
ylabel('reward per block');

end

