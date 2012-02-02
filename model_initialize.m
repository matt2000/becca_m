function model = model_initialize(basic_feature_length, action_length)

model.SIMILARITY_THRESHOLD = 0.9;       % real, 0 < x < 1
model.MAX_ENTRIES = 10^4;               % integer, somewhat large
model.CLEANING_PERIOD = 10^5;           % integer, somewhat large
model.UPDATE_RATE = 0.1;                % real, 0 < x < 1
model.STEP_DISCOUNT = 0.5;              % real, 0 < x < 1
model.TRACE_LENGTH = 10;                 % integer, small
model.TRACE_DECAY_RATE = 0.2;           % real, 0 < x < 1

model.debug_flag = 0;
model.filename_postfix = '_model.mat';

model.clean_count = 0;
model.cause{1}  = [];
model.cause{2}     = zeros(basic_feature_length, 2*model.MAX_ENTRIES);
model.cause{3}     = zeros(action_length, 2*model.MAX_ENTRIES);
model.effect = model.cause;
model.hist = model.cause;

model.count = zeros(1, 2*model.MAX_ENTRIES);
model.reward_map = zeros(1, 2*model.MAX_ENTRIES);
model.goal_map = zeros(1, 2*model.MAX_ENTRIES);

model.trace_indx = ones(1, model.TRACE_LENGTH);
model.trace_reward = zeros(1, model.TRACE_LENGTH);

% Initializes dummy transitions
model.last_entry = 1;
model.cause{2}(1,1)  = 1;
model.effect{2}(1,1) = 1;
%model.count(1) = eps;