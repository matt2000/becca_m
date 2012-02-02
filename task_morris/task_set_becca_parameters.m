function task = task_set_becca_parameters( task)

task.HIDE_TARGET = 0;

task.agent.grouper.PROPENSITY_UPDATE_RATE = 10 ^ (-2.5);
task.agent.grouper.MAX_PROPENSITY = 0.2;
task.agent.grouper.GROUP_DISCOUNT = 2;
task.agent.grouper.NEW_GROUP_THRESHOLD = 0.4;
task.agent.grouper.MIN_SIG_CORR = 0.3; 
task.agent.grouper.MAX_GROUP_SIZE = 9;%17; 

task.agent.feature_map.NEW_FEATURE_MARGIN = 0.35;

task.agent.planner.ACTION_CANDIDATES = 10;
%task.agent.planner.EXPLORATION_FRACTION = 1; 
task.agent.planner.EXPLORATION_FRACTION = 0.3; 

