function model_display_pair( model, N )
% provides a visual representation of the Nth cause-effect pair

num_groups = length(model.cause);

figure(177);
for k = 2:num_groups,
    subplot(num_groups-1, 2, (k-1)*2-1)
    bar(model.cause{k}(:,N))
%     disp(['model.cause{' num2str(k) '}(' num2str(N) ')'])
%     model.cause{k}(:,N)
    axis ([0 size(model.cause{k},1)+1 0 1])
    ylabel(['g' num2str(k) ])
%    xlabel(['max of ' num2str(max(model.cause{k}(:,N))) ])
    if (k == 2)
        title(['model.cause for N = ' num2str(N) ]);
    end
    if (k == num_groups)
        xlabel(['count = ' num2str(model.count(N)) ]);
    end
end

for k = 2:num_groups,
    subplot(num_groups-1, 2, (k-1)*2)
    bar(model.effect{k}(:,N))
%     disp(['model.effect{' num2str(k) '}(' num2str(N) ')'])
%     model.effect{k}(:,N)
    axis ([0 size(model.effect{k},1)+1 0 1])
    ylabel(['g' num2str(k) ])
%    xlabel(['max of ' num2str(max(model.effect{k}(:,N))) ])
    if (k == 2)
        title(['model.effect for N = ' num2str(N) ]);
    end
end
