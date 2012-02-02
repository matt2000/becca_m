function model = model_add_feature( model, k, has_dummy)

%add_feature to the model
model.hist{k}    = [model.hist{k};   zeros(1, size(model.hist{k},   2));];
model.cause{k}   = [model.cause{k};  zeros(1, size(model.cause{k},  2));];
model.effect{k}  = [model.effect{k}; zeros(1, size(model.effect{k}, 2));];

% if dummy feature is still in place, removes it
if (has_dummy)
    model.hist{k}   = model.hist{k}  ( 2:end,:);
    model.cause{k}  = model.cause{k} ( 2:end,:);
    model.effect{k} = model.effect{k}( 2:end,:);
end
