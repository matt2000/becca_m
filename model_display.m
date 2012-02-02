function model_display( model, N )
% provides a visual representation of the Nth cause-effect pair

num_groups = length(model.cause);
% 
% figure(177);
% for k = 2:num_groups,
%     subplot(num_groups-1, 2, (k-1)*2-1)
%     bar(model.cause{k}(:,N))
%     axis ([0 size(model.cause{k},1)+1 0 1])
%     ylabel(['grp ' num2str(k) ])
%     if (k == 2)
%         title(['model.cause for N = ' num2str(N) ]);
%     end
%     if (k == num_groups)
%         xlabel(['count = ' num2str(model.count(N)) ]);
%     end
% end
% 
% for k = 2:num_groups,
%     subplot(num_groups-1, 2, (k-1)*2)
%     bar(model.effect{k}(:,N))
%     axis ([0 size(model.effect{k},1)+1 0 1])
%     ylabel(['grp ' num2str(k) ])
%     if (k == 2)
%         title(['model.effect for N = ' num2str(N) ]);
%     end
% end

% Text display
disp(['================Transition pair ' num2str(N) ' =================']);
for k = 2:num_groups,
%for k = 2,
    nonz_cause = length(find(model.cause{k}(:,N)));
    nonz_effect = length(find(model.effect{k}(:,N)));
    if ( (nonz_cause > 0) || (nonz_effect > 0))
        
%     % debug
%     if ( (nonz_cause < 4) && (nonz_effect < 4))
%         
%    disp(['================Transition pair ' num2str(N) ' =================']);
    
       disp(['  -----Group ' num2str(k) ' -----']);
        for kk = 1:length( model.effect{k}(:,N)),
            if (~isempty(find(model.cause{k}(kk,N))) || ...
                    ~isempty(find(model.effect{k}(kk,N))))
                disp(['    Feature             ' num2str(kk) ': ' ...
                    num2str(model.cause{k}(kk,N)) '     ' ...
                    num2str(model.effect{k}(kk,N))])
            end
        end
    end
    
%     %debug
%     end
    
end

