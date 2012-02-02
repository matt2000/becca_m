function planner = planner_initialize( action_length)

planner.EXPLORATION_FRACTION = 0.2;     % real, 0 < x < 1
planner.OBSERVATION_FRACTION = 0.5;     % real, 0 < x < 1

planner.act_flag = 0;
planner.action = zeros( action_length, 1);
