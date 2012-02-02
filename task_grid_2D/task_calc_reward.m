function reward = task_calc_reward( task)
    reward = 0;   
    if ( (task.simple_state(1) == task.obstacle_row) && ...
         (task.simple_state(2) == task.obstacle_col) )
        reward = -1/2;
    end
    if ( (task.simple_state(1) == task.target_row) && ...
         (task.simple_state(2) == task.target_col) )
        reward = 1/2;
    end
    reward = reward - task.ENERGY_PENALTY * task.energy;
end
