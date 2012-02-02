function task = task_step( task)

new_action = task.agent.action;
task.action = round(new_action);

task.world_state = task.world_state +   new_action(1:2) + ...
                                    2 * new_action(3:4) - ...
                                        new_action(5:6) - ...
                                    2 * new_action(7:8);

                                
task.energy =   sum(     new_action(1:2)) + ...
                sum( 2 * new_action(3:4)) + ...
                sum(     new_action(5:6)) + ...
                sum( 2 * new_action(7:8));

%enforces lower and upper limits on the grid world by looping them around.
%It actually has a toroidal topology.
indx = (task.world_state >= task.world_size + 0.5); 
task.world_state( indx) = task.world_state( indx) - task.world_size;

indx = (task.world_state <= 0.5); 
task.world_state( indx) = task.world_state( indx) + task.world_size;

task.simple_state = round( task.world_state);

task.basic_feature_input = zeros( task.basic_feature_length, 1);
task.basic_feature_input( task.simple_state(1) ) = 1;
task.basic_feature_input( task.simple_state(2) + task.world_size) = 1;
task.reward = task_calc_reward( task);
