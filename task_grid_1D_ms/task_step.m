function task = task_step(task)

new_action = task.agent.action;

task.action = round(new_action);

% occasional disturbance
if (rand(1) < 0.1)
    if (task.display_features_flag == 1)
        disp('-bump-');
    end
    task.action = task.action + round(rand(1) * 6) * round(rand(3,1));
end

task.world_state = task.world_state + task.action(1) - task.action(2);

% an approximation of metabolic energy
energy    = task.action(1) + task.action(2);
        
task.world_state = task.world_state - 9 * floor (task.world_state/9);
task.simple_state = floor( task.world_state) + 1;

task.basic_feature_input = zeros( task.basic_feature_length, 1);
task.basic_feature_input( task.simple_state) = 1;

% Assigns reward based on the current state
task.reward = 0;
task.reward = task.reward + task.basic_feature_input(9) * (-0.5);
task.reward = task.reward + task.basic_feature_input(4) * ( 0.5);

% Punishes actions just a little.
task.reward = task.reward - energy / 100;
task.reward = max( task.reward, -1);
