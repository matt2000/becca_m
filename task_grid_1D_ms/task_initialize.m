function task = task_initialize( task)

task.state_length = 1;
task.action_length = 3;
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
task.display_features_flag = 0;

task.REPORTING_BLOCK_SIZE = 1000;
task.BACKUP_PERIOD = 1000;

task.restore_filename_prefix = 'log/task_grid_1D_ms';
task.backup_filename_prefix = 'log/task_grid_1D_ms';
task.backup_filename_postfix = '.mat';

close all
figure(1) 
clf
hold on
xlabel(['block (' num2str(task.REPORTING_BLOCK_SIZE) ...
    ' time steps per block)']);
ylabel('reward per block');

end

