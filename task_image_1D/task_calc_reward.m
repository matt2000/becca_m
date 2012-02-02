function reward = task_calc_reward(task)

DISTANCE_FACTOR = task.MAX_STEP_SIZE / 16;

reward = 0;
if (abs(task.col_pos - task.TARGET_COL) < DISTANCE_FACTOR)
    reward = 1;
end