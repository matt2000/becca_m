% function [grouper input_group group_added] = grouper_step(grouper, ...
%     sensory_input, basic_feature_input, previous_feature_activity)
function [grouper input_group group_added] = grouper_step(grouper, ...
    sensory_input, basic_feature_input, action, previous_feature_activity)

% incrementally estimates correlation between inputs and forms groups
% when appropriate
num_groups = length(previous_feature_activity);

% builds the feature vector
% combines sensory_input and basic_feature_input with 
% previous_feature_activity to create the full input set
input = previous_feature_activity;
input{1} = sensory_input;
input{2} = basic_feature_input;

%debug
input{3} = action;

for k = 1:num_groups,
    % decays previous input
    grouper.previous_input{k} = grouper.previous_input{k} * ...
        (1 - grouper.INPUT_DECAY_RATE);  

    % adds previous input to input
    input{k} = util_bounded_sum( input{k}, grouper.previous_input{k});
    
    % updates previous input, preparing it for the next iteration
    grouper.previous_input{k} = input{k};
end

% initializes remainder of entries to the input pool.
for k = 1:num_groups,
    grouper.feature_vector( grouper.indx_map{k}) = input{k};
end

group_added = 0;

if (grouper.features_full == 0) 

    % finds the upper bound on propensity based on how many groups
    % each feature is associated with
    % updates the propensity of each input to form new associations
    grouper.propensity( 1:grouper.last_entry, 1:grouper.last_entry) = ...
      grouper.propensity( 1:grouper.last_entry, 1:grouper.last_entry) + ...
      grouper.PROPENSITY_UPDATE_RATE * (grouper.MAX_PROPENSITY - ...
      grouper.propensity( 1:grouper.last_entry, 1:grouper.last_entry));

    % performs clustering on feature_input to create feature groups 
    % adapts correlation toward average activity correlation
    
    weighted_feature_vector = ...
        exp( - grouper.groups_per_feature ( 1:grouper.last_entry) * ...
            grouper.GROUP_DISCOUNT ) .* ...
            grouper.feature_vector( 1:grouper.last_entry);
    delta_corr =   ...
        repmat( weighted_feature_vector, 1, grouper.last_entry).* ...
        (weighted_feature_vector * weighted_feature_vector' - ...
            grouper.correlation( ...
            1:grouper.last_entry, 1:grouper.last_entry));
    grouper.correlation( 1:grouper.last_entry, 1:grouper.last_entry) = ...
        grouper.correlation( 1:grouper.last_entry, 1:grouper.last_entry) + ...
        grouper.propensity( 1:grouper.last_entry, 1:grouper.last_entry) .* ...
        delta_corr;

    %updates legal combinations in the correlation matrix
    grouper.correlation( 1:grouper.last_entry, 1:grouper.last_entry) = ...
        grouper.correlation( 1:grouper.last_entry, 1:grouper.last_entry) .* ...
        grouper.combination( 1:grouper.last_entry, 1:grouper.last_entry);

    grouper.propensity( 1:grouper.last_entry, 1:grouper.last_entry) = ...
        max( grouper.propensity( 1:grouper.last_entry, 1:grouper.last_entry) - ...
        abs(delta_corr), 0);
    
    if ( grouper.last_entry > grouper.MAX_NUM_FEATURES * 0.95)
        grouper.features_full = 1;
        disp(['==Max number of features almost reached (' ...
            num2str(grouper.last_entry) ')==']);
    end

    if (max( max( grouper.correlation)) > grouper.NEW_GROUP_THRESHOLD)

        group_added = 1;
        [indx1,indx2] = find( grouper.correlation == ...
            max( max( grouper.correlation)) );
        which_indx = ceil( rand(1) * length( indx1));
        indx1 = indx1(which_indx);
        indx2 = indx2(which_indx);
        lmnt = [indx1 indx2];
        grouper.correlation (lmnt, lmnt) = 0;
        grouper.combination(lmnt, lmnt) = 0;

        % Z tracks the available elements to add and the correlation 
        % with each
        Z = zeros( size( grouper.combination));
        Z(:,lmnt) = 1;
        Z(lmnt,:) = 1;

        while (1),
            T = abs( grouper.correlation .* Z);
            Tc = sum(T,1);
            Tr = sum(T,2);
            Tl = Tc + Tr';
            Tl = Tl / (2*length( lmnt));
            Tl( lmnt) = 0;
            if ( (max(Tl) < grouper.MIN_SIG_CORR) || ...
                    (length(lmnt) >= grouper.MAX_GROUP_SIZE))
                break
            end
            indx = find( Tl == max(Tl));
            indx = indx( ceil( rand(1) * length( indx)));
            lmnt = [lmnt indx];
            grouper.correlation (lmnt, lmnt) = 0;
            grouper.combination(lmnt, lmnt) = 0;
            Z(:,lmnt) = 1;
            Z(lmnt,:) = 1;
        end
        lmnt = sort( lmnt);
        grouper.groups_per_feature(lmnt) = ...
            grouper.groups_per_feature(lmnt) + 1;

        num_groups = num_groups + 1;

        grouper.input_map{num_groups} = [];
        for lmnt_ctr = 1:length( lmnt),
            grouper.input_map{num_groups} = ...
                vertcat(grouper.input_map{num_groups}, ...
                grouper.indx_map_inv( lmnt( lmnt_ctr), :));
        end

        %initializes a new group
        grouper.last_entry = grouper.last_entry + 1;
        grouper.indx_map{ num_groups} = grouper.last_entry;
        grouper.indx_map_inv( grouper.last_entry, :) = [1 num_groups];

    end
end

for k = 2:num_groups,
    % sorts inputs into their groups
    for input_ctr = 1:size(grouper.input_map{k},1),
        input_group{k}(input_ctr) =  ...
            input{ grouper.input_map{k}( input_ctr, 2)}...
                            ( grouper.input_map{k}( input_ctr, 1));
    end
    input_group{k} = input_group{k}(:);

%     % TODO: is this necessary?
%     if (k > 3)
%         %ensures that the total magnitude of the input features are 
%         %less than one
% %         input_group{k} = input_group{k}(:) / sqrt( length( input_group{k}));
%     end
end    
