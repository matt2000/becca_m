function reward = task_calc_reward(task)

DISTANCE_FACTOR = task.MAX_STEP_SIZE / 8;

reward = 0;
if ((abs(task.col_pos - task.TARGET_COL) < DISTANCE_FACTOR) && ...
    (abs(task.row_pos - task.TARGET_ROW) < DISTANCE_FACTOR))
    reward = 1;
end