% A test harness for a general reinforcement learning agent. 

clear all
format compact

MAX_ITERATIONS = 10^8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% selects for the task
%
% standard repertoire
task.dir = 'task_grid_1D';
% task.dir = 'task_grid_1D_ms';
% task.dir = 'task_grid_1D_noise';
% task.dir = 'task_grid_2D';
% task.dir = 'task_grid_2D_dc';
% task.dir = 'task_image_1D';
% task.dir = 'task_image_2D';
%task.dir = 'task_watch';
%task.dir = 'task_listen';
%
% under development
%task.dir = 'task_morris';

addpath(task.dir); 
task = task_initialize( task);

if ~exist('task.MAX_NUM_FEATURES', 'var')
    task.MAX_NUM_FEATURES = 700;
end

% the agent is an element of the task
task.agent = agent_initialize( task.state_length, ...
                    task.basic_feature_length, ...
                    task.action_length, ...
                    task.MAX_NUM_FEATURES);

task = task_restore( task);
task = task_set_becca_parameters( task);

for ctr = 1:MAX_ITERATIONS,
    task = task_step( task);
    tester_display;
    task.agent = agent_step( task.agent, ...
                             task.sensory_input, ...
                             task.basic_feature_input, ...
                             task.reward);
end 
