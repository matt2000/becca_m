
if ~(exist( 'i', 'var'))
    i = 1;
end

agent = task.agent;
n = 15;
agent.model.count((i-1)*n + 1:(i*n))
agent.model.reward_map((i-1)*n + 1:(i*n))
agent.model.hist{2}(:,(i-1)*n + 1:(i*n))
agent.model.hist{3}(:,(i-1)*n + 1:(i*n))
agent.model.cause{2}(:,(i-1)*n + 1:(i*n))
agent.model.cause{3}(:,(i-1)*n + 1:(i*n))
agent.model.effect{2}(:,(i-1)*n + 1:(i*n))
agent.model.effect{3}(:,(i-1)*n + 1:(i*n))


THRESH = 0.1;
n = 751;
disp('');
disp(['----------------- transition ' num2str(n) '-----------------']);
disp(['            count:  ' num2str(agent.model.count(n))])
disp(['            reward: ' num2str(agent.model.reward_map(n))])

disp('            history: ')
for k = 2:agent.num_groups,
    indx = find (agent.model.hist{k}(:,n) > THRESH);
    if ~isempty( indx)
        for kk = 1:length( indx)
            disp(['               group ' num2str(k) ...
                '  feature ' num2str(indx(kk)) ...
                ' : ' num2str( agent.model.hist{k}(indx(kk),n))])
        end
    end
end

disp('             cause: ')
for k = 2:agent.num_groups,
    indx = find (agent.model.cause{k}(:,n) > THRESH);
    if ~isempty( indx)
        for kk = 1:length( indx)
            disp(['               group ' num2str(k) ...
                '  feature ' num2str(indx(kk)) ...
                ' : ' num2str( agent.model.cause{k}(indx(kk),n))])
        end
    end
end

disp('             effect: ')
for k = 2:agent.num_groups,
    indx = find (agent.model.effect{k}(:,n) > THRESH);
    if ~isempty( indx)
        for kk = 1:length( indx)
            disp(['               group ' num2str(k) ...
                '  feature ' num2str(indx(kk)) ...
                ' : ' num2str( agent.model.effect{k}(indx(kk),n))])
        end
    end
end
