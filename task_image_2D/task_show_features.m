function task_show_features(task)

% initializes feature sets to display
num_groups_display = length(task.agent.feature_activity);
span = task.fov_span;

for k = 1:num_groups_display,
    if k == 1
        empty_features{k} = zeros( task.state_length, 1);
    else
        empty_features{k} = zeros( size( task.agent.feature_activity{k}));
    end
end

%builds features
for k = 4:num_groups_display,

    for k2 = 1: size( task.agent.feature_map.map{k},1),
        this_feature = empty_features;
        this_feature{k}(k2) = 1;
        this_feature_final{k, k2} = agent_expand(task.agent, this_feature);
    end
end

pos_indx = 1:task.state_length / 2;
neg_indx = task.state_length/2 + 1: task.state_length;
pos_indx = pos_indx(:);
neg_indx = neg_indx(:);

%creates the image set representing all features individually
feature_image_set = [];
for k = 4:num_groups_display,
    num_features_in_group = size(task.agent.feature_map.map{k},1);
    for k2 = 1:num_features_in_group

       %remaps the interval(-1, 1) to (0, 4/5) for display
        pos_mask = find( this_feature_final{k,k2}{1}(pos_indx) < 2);
        neg_mask = find( this_feature_final{k,k2}{1}(neg_indx) < 2);        
        mask_indx = union( pos_mask, neg_mask);
        
        this_feature_pixels = ones( size( pos_indx));
        this_feature_pixels( pos_mask) = 0;
        this_feature_pixels( neg_mask) = 0;
        this_feature_pixels( pos_mask) = ...
            this_feature_pixels( pos_mask) + ...
            this_feature_final{k,k2}{1}(pos_mask);
        this_feature_pixels( neg_mask) = ...
            this_feature_pixels( neg_mask) - ...
            this_feature_final{k,k2}{1}(neg_mask + task.state_length/2);
        
        this_feature_pixels( mask_indx) = ...
            (util_sigm(this_feature_pixels( mask_indx) .* 2) + 1) / 2.5; 

        feature_image = reshape( this_feature_pixels, span, span);
        feature_image_border = horzcat( zeros( span, 1), ...
            feature_image, zeros( span, 1));
        feature_image_border = vertcat( zeros( 1, span + 2), ...
            feature_image_border, zeros( 1, span + 2));

        %adds the extra border indicating activity level
        [f_hgt f_wid] = size(feature_image_border);
        feature_background = ones( f_hgt+2, f_wid+2);

        feature_background(2:end-1,2:end-1) = feature_image_border;
        feature_image = feature_background;
        feature_image_set{k,k2} = feature_image;

    end
end

if ~isempty( feature_image_set)

    figure(4)
    clf
    num_feats_in_group = size( feature_image_set,2);
    rows_in_feat = size( feature_image_set{4,1},1);
    cols_in_feat = size( feature_image_set{4,1},2);
    master_feature = ones( (num_groups_display - 3) * (rows_in_feat + 2), ...
                           num_feats_in_group * (cols_in_feat + 2));
    for k = 4: num_groups_display,
        for k2 = 1: num_feats_in_group,
            if ~isempty( feature_image_set{k,k2})
                mask_indx = find( feature_image_set{k,k2} < 1.0);
                this_feature_pixels = ones( size( feature_image_set{k,k2}));
                this_feature_pixels( mask_indx) = feature_image_set{k,k2}( mask_indx);
                grp = k - 3;
                master_feature(( grp - 1) * (rows_in_feat + 2) + 2: ...
                                 grp      * (rows_in_feat + 2) - 1, ...
                               (k2 - 1) * (cols_in_feat + 2) + 2: ...
                                k2      * (cols_in_feat + 2) - 1) = ...
                    this_feature_pixels;
            end
        end
    end
    image(master_feature * 256)
    axis off
    axis equal
    set(4,'Name', 'features by group')
    print( task.h4, '-deps', ['log/log_elements_' datestr(floor(now)) '.eps']);
end