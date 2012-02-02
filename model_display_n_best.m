function model_display_n_best( model, N)
% provides a visual representation of the Nth cause-effect pair


[sorted_count sort_indx] = ...
    sort(model.count(1:model.last_entry), 2 ,'descend');

sort_indx = sort_indx(1: min( length(sort_indx), N));

for i = sort_indx,
    model_display_pair(model,i);
    pause
end

