function planner = planner_explore(planner)

% forms a planner.plan
planner.act_flag = 1;

% Exploratory commands are only generated at the basic command feature
% level (k = 3). Features and higher-level commands are not excited.
for k = 3,
    %handles motor commands as all-or-none
    planner.action = zeros( size( planner.action));
    
    % old code: only one action element active
    planner.action( ceil( rand(1) * length( planner.action))) = 1;

%     % new code
%     N = 1; %adjust this—typical number of ones per exploratory action
%     frac = (length( planner.plan{k}) + N) / length( planner.plan{k});
%     planner.plan{k}( find( rand( size( planner.plan{k})) * frac > 1)) = 1;

end
