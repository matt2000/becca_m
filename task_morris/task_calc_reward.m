function reward = task_calc_reward(task)

REWARD_WINDOW_WID = task.fov_wid / 4;
reward = 0;
if ((abs( task.col_pos - task.TARGET_COL) < REWARD_WINDOW_WID / 2) && ...
    (abs( task.row_pos - task.TARGET_ROW) < REWARD_WINDOW_WID / 2))
    reward = 1;
end
reward = reward - task.border_hit;