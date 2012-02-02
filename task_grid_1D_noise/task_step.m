function task = task_step(task)

task.action = round( task.agent.action);

task.world_state = task.world_state + task.action(1) - task.action(2);
energy = sum(task.action);

task.world_state = round( task.world_state);
task.world_state = min( task.world_state, 3);
task.world_state = max( task.world_state, 1);

real_features = zeros( task.num_real_features, 1);
real_features( task.world_state) = 1;

noise = round( rand(task.noise_inputs, 1));
task.basic_feature_input = vertcat( real_features, noise);

task.reward = -1/2;
if (task.world_state == 2)
    task.reward = 1/2;
end
task.reward = task.reward - energy * task.ENERGY_PENALTY;