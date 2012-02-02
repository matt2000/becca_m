function model = model_add_group(model)

num_groups = length( model.cause);

model.hist  {num_groups + 1} = zeros(1, size( model.cause{num_groups}, 2));
model.cause {num_groups + 1} = zeros(1, size( model.cause{num_groups}, 2));
model.effect{num_groups + 1} = zeros(1, size( model.cause{num_groups}, 2));
