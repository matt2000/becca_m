function task_show_features(task)

% initializes feature sets to display
num_groups_display = length(task.agent.feature_activity);

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


%creates the image set representing all features individually
feature_image_set = [];
for k = 4:num_groups_display,
%for k = 30:num_groups_display,
    num_features_in_group = size(task.agent.feature_map.map{k},1);
    for k2 = 1:num_features_in_group
        
        this_feature_final{k,k2}{1}( ...
            find( this_feature_final{k,k2}{1} == 2)) = 0;

        if (~isempty( find( this_feature_final{k,k2}{1} > 1)))
            disp('task_listen.show_features:  this_feature_final > 1')
        end

        %debug
%         set( task.frequency_plot_handle, 'ydata', this_feature_final{k, k2}{1});
%         title(['Frequency content of feature ' num2str(k2) ' in group ' num2str(k) ]);
%         drawnow
%         name = ['feature_' num2str(k) '_' num2str(k2)];
%         filename = ['images/listen/' name '.jpg'];
%         print ('-f1', '-djpeg90', filename);
%         filename = ['audio/' name '.wav'];
% 
%         task.display_sound(this_feature_final{k, k2}{1}, filename);

        
        num_inputs = length( this_feature_final{k,k2}{1});
        scaled_input = ceil( this_feature_final{k,k2}{1} * num_inputs);
        
        feature_image = ones( num_inputs);
        for q = 1:num_inputs,
            feature_image(end-scaled_input(q) + 1:end,q) = 0;
        end
        
         
        [feature_image_hgt feature_image_wid] = size(feature_image);
        feature_image_border = horzcat( zeros( feature_image_hgt, 1), ...
            feature_image, zeros( feature_image_hgt, 1));
        feature_image_border = vertcat( zeros( 1, feature_image_wid + 2), ...
            feature_image_border, zeros( 1, feature_image_wid + 2));

        %adds the extra border indicating activity level
        [f_hgt f_wid] = size(feature_image_border);
        feature_background = ones( f_hgt+2, f_wid+2);

        feature_background(2:end-1,2:end-1) = feature_image_border;
        feature_image_set{k,k2} = feature_background;

    end
end

if ~isempty( feature_image_set)

    figure(4)
    clf
    num_feats_in_group = size( feature_image_set,2);
    rows_in_feat = size( feature_image_set{4,1},1);
    cols_in_feat = size( feature_image_set{4,1},2);
    master_feature = ones( (num_groups_display - 3)*(rows_in_feat + 2), ...
                           num_feats_in_group * (cols_in_feat + 2));
    for k = 4: num_groups_display,
        for k2 = 1: num_feats_in_group,
            if ~isempty( feature_image_set{k,k2})
                mask_indx = find( feature_image_set{k,k2} < 1.0);
                this_feature_pixels = ones(size( feature_image_set{k,k2}));
                this_feature_pixels( mask_indx) = ...
                    feature_image_set{k,k2}( mask_indx);
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
    print( '-f4', '-deps', ['log/log_elements_' datestr(floor(now)) '.eps']);

end